#!/usr/bin/env python3
from __future__ import annotations

import argparse
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent

REQUIRED_FILES = [
    "README.md",
    "GOVERNANCE/ENGINEERING_CONSTITUTION.md",
    "GOVERNANCE/RELEASE_GATES.md",
    "GOVERNANCE/AGENT_EXECUTION_RULES.md",
    "GOVERNANCE/ESCAPE_PREVENTION_POLICY.md",
    "GOVERNANCE/TESTING_POLICY.md",
    "GOVERNANCE/BASELINE_AND_PROVENANCE_POLICY.md",
    "GOVERNANCE/UI_AND_DATA_INTEGRITY_POLICY.md",
    "GOVERNANCE/DEFINITION_OF_DONE.md",
    "GOVERNANCE/REALTIME_SYSTEM_STANDARD.md",
    "GOVERNANCE/CORE_LOOP_STANDARD.md",
    "PRODUCT/README.md",
    "DESIGN/README.md",
    "ARCH/README.md",
    "TASKS/README.md",
    "QA/README.md",
    "QA/RELEASE_DECISION_TEMPLATE.md",
    "RELEASES/README.md",
    "templates/CURRENT_ITERATION_TEMPLATE.md",
    "templates/RELEASE_NOTE_TEMPLATE.md",
    "templates/AGENT_SYSTEM_PROMPT_TEMPLATE.md",
    "templates/ADR_TEMPLATE.md",
    "templates/BLOCKERS_TEMPLATE.md",
    "scripts/governance_audit.py",
    "scripts/release_gate_audit.py",
    "scripts/module_structure_audit.py",
    ".github/workflows/governance-ci.yml",
]

REQUIRED_PHRASES = {
    "GOVERNANCE/ENGINEERING_CONSTITUTION.md": [
        "Do not claim testing without executable evidence",
        "Do not claim release readiness without release-gate evidence",
    ],
    "GOVERNANCE/RELEASE_GATES.md": [
        "Test gate",
        "Regression gate",
        "Documentation gate",
    ],
    "GOVERNANCE/AGENT_EXECUTION_RULES.md": [
        "Work on exactly one iteration goal",
        "Do not mark tasks complete without evidence",
    ],
    "GOVERNANCE/ESCAPE_PREVENTION_POLICY.md": [
        "claiming work completed without evidence",
        "Mandatory artifact existence check before release note",
    ],
    "GOVERNANCE/TESTING_POLICY.md": [
        "unit tests",
        "integration tests",
        "regression tests",
    ],
    "GOVERNANCE/UI_AND_DATA_INTEGRITY_POLICY.md": [
        "Fake healthy is unacceptable",
        "Missing data must be visible",
    ],
    "templates/RELEASE_NOTE_TEMPLATE.md": [
        "Passed tests",
        "Known limitations",
        "Rollback note",
    ],
    "GOVERNANCE/MODULE_STRUCTURE_POLICY.md": [
        "Hard violation",
        "entry point",
        "AI handoff standard",
    ],
}


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit governance repository structure.")
    parser.add_argument("--strict", action="store_true", help="Exit non-zero on failures.")
    args = parser.parse_args()

    missing_files: list[str] = []
    missing_phrases: dict[str, list[str]] = {}

    for rel in REQUIRED_FILES:
        path = ROOT / rel
        if not path.exists():
            missing_files.append(rel)

    for rel, phrases in REQUIRED_PHRASES.items():
        path = ROOT / rel
        if not path.exists():
            continue
        text = read_text(path)
        missing = [p for p in phrases if p not in text]
        if missing:
            missing_phrases[rel] = missing

    print("Governance audit")
    print("================")
    print(f"Repository root: {ROOT}")
    print()

    if missing_files:
        print("Missing files:")
        for item in missing_files:
            print(f"  - {item}")
    else:
        print("Missing files: none")

    print()

    if missing_phrases:
        print("Missing required phrases:")
        for rel, phrases in missing_phrases.items():
            print(f"  - {rel}")
            for phrase in phrases:
                print(f"      * {phrase}")
    else:
        print("Missing required phrases: none")

    failed = bool(missing_files or missing_phrases)
    print()
    print(f"passed: {not failed}")

    if args.strict and failed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
