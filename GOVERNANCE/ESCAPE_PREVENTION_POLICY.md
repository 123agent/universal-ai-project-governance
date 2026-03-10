# Escape Prevention Policy

## Typical escape patterns
- claiming work completed without evidence
- claiming tests ran without outputs
- shipping from the wrong baseline
- fixing one thing while regressing another
- using fallback defaults to hide missing data
- using polling to imitate realtime
- releasing artifacts that do not actually exist

## Controls
1. Mandatory baseline declaration
2. Mandatory release gate checklist
3. Mandatory regression checks
4. Mandatory evidence for tests
5. Mandatory known limitations section
6. Mandatory artifact existence check before release note
