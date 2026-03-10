#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
RELEASES_DIR = ROOT / "RELEASES"

REQUIRED_RELEASE_HEADINGS = [
    "## Baseline",
    "## Scope",
    "## Passed tests",
    "## Known limitations",
    "## Rollback note",
]


def list_release_notes() -> list[Path]:
    if not RELEASES_DIR.exists():
        return []
    return sorted(
        [
            p for p in RELEASES_DIR.iterdir()
            if p.is_file() and p.suffix.lower() == ".md" and p.name != "README.md"
        ]
    )


def audit_release(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    errors: list[str] = []

    for heading in REQUIRED_RELEASE_HEADINGS:
        if heading not in text:
            errors.append(f"Missing heading: {heading}")

    # Require at least one concrete test command line (e.g. "command: pytest ...")
    if not re.search(r"command\s*:\s*\S+", text, flags=re.IGNORECASE):
        errors.append("Missing concrete test command (expected 'command: <cmd>')")

    # Require a non-empty baseline value (not just the placeholder)
    baseline_match = re.search(r"##\s*Baseline\s*\n+(.+)", text)
    if not baseline_match or baseline_match.group(1).strip() in ("", "<baseline>"):
        errors.append("Missing or placeholder baseline declaration")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit release note quality.")
    parser.add_argument("--strict", action="store_true", help="Exit non-zero on failures.")
    args = parser.parse_args()

    releases = list_release_notes()
    failed = False

    print("Release gate audit")
    print("==================")
    print(f"Repository root: {ROOT}")
    print()

    if not releases:
        print("No release notes found in RELEASES/")
        failed = True
    else:
        print(f"Found {len(releases)} release note(s)")
        print()
        for path in releases:
            print(f"- {path.relative_to(ROOT)}")
            errors = audit_release(path)
            if errors:
                failed = True
                for err in errors:
                    print(f"    ERROR: {err}")
            else:
                print("    OK")

    print()
    print(f"passed: {not failed}")

    if args.strict and failed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
