#!/usr/bin/env python3
"""
Audit source file line counts and module folder naming/structure.

Checks:
  - Files exceeding line count limits (warn: 500, hard: 1000)
  - Folders with forbidden generic names that lack a README
  - Module folders that contain source files but no entry point

Excludes governance-pack directories, generated files, and common
non-source directories (node_modules, .git, etc.).
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent

HARD_LIMIT = 1000
WARN_LIMIT = 500

# Directories skipped entirely during traversal
SKIP_DIRS: set[str] = {
    ".git",
    "node_modules",
    "__pycache__",
    ".venv",
    "venv",
    ".env",
    "dist",
    "build",
    ".next",
    ".nuxt",
    "coverage",
    ".cache",
    ".mypy_cache",
    ".pytest_cache",
    "target",        # Rust / Java / Maven
    "vendor",        # Go / PHP
    # Governance-pack documentation dirs — not source code
    "GOVERNANCE",
    "PRODUCT",
    "DESIGN",
    "ARCH",
    "TASKS",
    "QA",
    "RELEASES",
    "templates",
}

SOURCE_EXTENSIONS: set[str] = {
    ".py", ".ts", ".tsx", ".js", ".jsx",
    ".go", ".rs", ".java", ".kt", ".swift",
    ".cs", ".cpp", ".c", ".h", ".rb", ".php",
}

# Folder names that require an explicit README to justify their existence
GENERIC_NAMES: set[str] = {
    "utils", "util", "helpers", "helper",
    "misc", "common", "shared", "lib",
    "stuff", "other", "tmp", "temp",
}

# Valid entry point filenames (any of these counts)
ENTRY_POINTS: set[str] = {
    "__init__.py",
    "index.ts",
    "index.tsx",
    "index.js",
    "index.jsx",
    "mod.rs",       # Rust
    "main.go",      # Go (alternative)
    "README.md",    # fallback — acceptable if it lists public interface
}


def iter_source_dirs(root: Path):
    """Yield directories that contain at least one source file, depth-first."""
    for path in root.rglob("*"):
        if not path.is_dir():
            continue
        if any(part in SKIP_DIRS for part in path.parts):
            continue
        yield path


def iter_source_files(root: Path):
    """Yield source files, skipping excluded directories."""
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if any(part in SKIP_DIRS for part in path.parts):
            continue
        if path.suffix in SOURCE_EXTENSIONS:
            yield path


def count_lines(path: Path) -> int:
    try:
        return sum(1 for _ in path.open(encoding="utf-8", errors="replace"))
    except OSError:
        return 0


def audit_file_sizes(root: Path) -> tuple[list[str], list[str]]:
    """Return (errors, warnings) for file size violations."""
    errors: list[str] = []
    warnings: list[str] = []
    for path in iter_source_files(root):
        lines = count_lines(path)
        rel = path.relative_to(root)
        if lines > HARD_LIMIT:
            errors.append(f"{rel}  ({lines} lines — hard limit {HARD_LIMIT})")
        elif lines > WARN_LIMIT:
            warnings.append(f"{rel}  ({lines} lines — warn limit {WARN_LIMIT})")
    return errors, warnings


def audit_generic_folder_names(root: Path) -> list[str]:
    """Return errors for generic folder names without a README."""
    errors: list[str] = []
    for path in iter_source_dirs(root):
        if path.name.lower() not in GENERIC_NAMES:
            continue
        # Check if folder has source files (otherwise irrelevant)
        has_source = any(
            f.suffix in SOURCE_EXTENSIONS for f in path.iterdir() if f.is_file()
        )
        if not has_source:
            continue
        has_readme = (path / "README.md").exists()
        if not has_readme:
            errors.append(
                f"{path.relative_to(root)}/  "
                f"(generic name '{path.name}' — add README.md to justify)"
            )
    return errors


def audit_missing_entry_points(root: Path) -> list[str]:
    """Return errors for module folders with source files but no entry point."""
    errors: list[str] = []
    for path in iter_source_dirs(root):
        if any(part in SKIP_DIRS for part in path.relative_to(root).parts):
            continue
        source_files = [
            f for f in path.iterdir()
            if f.is_file() and f.suffix in SOURCE_EXTENSIONS
        ]
        if not source_files:
            continue
        has_entry = any((path / ep).exists() for ep in ENTRY_POINTS)
        if not has_entry:
            errors.append(
                f"{path.relative_to(root)}/  "
                f"(has {len(source_files)} source file(s) but no entry point)"
            )
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit module structure.")
    parser.add_argument("--strict", action="store_true", help="Exit non-zero on failures.")
    parser.add_argument("--no-entry-point-check", action="store_true",
                        help="Skip entry point check (use during initial migration).")
    args = parser.parse_args()

    size_errors, size_warnings = audit_file_sizes(ROOT)
    name_errors = audit_generic_folder_names(ROOT)
    entry_errors = [] if args.no_entry_point_check else audit_missing_entry_points(ROOT)

    print("Module structure audit")
    print("======================")
    print(f"Repository root: {ROOT}")
    print(f"Limits: warn > {WARN_LIMIT} lines, hard > {HARD_LIMIT} lines")
    print()

    if size_errors:
        print(f"File size ERRORS ({len(size_errors)}) — must fix before release:")
        for e in size_errors:
            print(f"  ERROR  {e}")
        print()

    if size_warnings:
        print(f"File size WARNINGS ({len(size_warnings)}) — plan a split:")
        for w in size_warnings:
            print(f"  WARN   {w}")
        print()

    if name_errors:
        print(f"Generic folder name violations ({len(name_errors)}):")
        for e in name_errors:
            print(f"  ERROR  {e}")
        print()

    if entry_errors:
        print(f"Missing entry point violations ({len(entry_errors)}):")
        for e in entry_errors:
            print(f"  ERROR  {e}")
        print()

    failed = bool(size_errors or name_errors or entry_errors)

    if not (size_errors or size_warnings or name_errors or entry_errors):
        print("All checks passed.")
    else:
        print(f"passed: {not failed}")

    if args.strict and failed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
