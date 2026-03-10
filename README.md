# Universal AI Project Governance

Project-agnostic governance pack for AI-assisted software delivery.

## Purpose
This repository provides reusable standards for:
- product definition
- design standards
- architecture boundaries
- execution constraints
- testing and release gates
- anti-escape controls for AI agents

## Core principle
No AI agent may claim completion, testing, or release readiness without evidence.

## Suggested repo structure
- GOVERNANCE/
- PRODUCT/
- DESIGN/
- ARCH/
- TASKS/
- QA/
- RELEASES/
- templates/
- scripts/

## Usage
1. Copy this pack into a new repository.
2. Fill in PRODUCT, DESIGN, ARCH documents before implementation.
3. Require all builder agents to follow GOVERNANCE rules.
4. Require QA/release gates before packaging or shipping.
