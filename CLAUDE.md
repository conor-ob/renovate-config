# renovate-config

Shared Renovate presets for every conor-ob repo. Each rule's reason is in its
`description`; keep it true when you change the rule.

## Checks

`pnpm install`, then `pnpm validate`, which mirrors CI. It validates every
preset in strict mode (a config that needs migrating fails too), then checks
that each config in `tests/invalid` is still rejected.

## Changing a preset

- **Every repo follows `main` with no tag pin**, so a merged change reaches
  all of them on their next Renovate run. Keep each PR to one policy change.
- **Presets sit at the repo root.** `github>conor-ob/renovate-config:<name>`
  resolves to `<name>.json` there, and `default.json` is what a bare
  `github>conor-ob/renovate-config` loads. A new root `.json` file is a new
  preset, and `pnpm validate` picks it up.
- **Rule order decides.** In `packageRules` a later rule overrides an earlier
  one, and a repo extends `default` before its stack presets, so a stack preset
  can override `default`. Write each rule's reason in its `description`.
- **The validator checks syntax, not behaviour.** To see what a rule does, dry
  run Renovate on a scratch git repo holding a small fixture (`package.json`,
  `.nvmrc`, a `Dockerfile`) and a `renovate.json` with the presets merged in
  (Renovate can't load a `github>` preset on the local platform):
  `LOG_LEVEL=debug LOG_FORMAT=json node_modules/.bin/renovate --platform=local --dry-run=lookup --onboarding=false`,
  then read the `packageFiles with updates` and `flattened updates` log
  lines. The local platform stops before branch updates.
- **Regexes run on RE2**, as Renovate runs them. `pnpm-workspace.yaml` lets re2
  build, so the validator rejects syntax RE2 lacks, such as lookaheads.

## Agent skills

### Issue tracker

GitHub Issues on `conor-ob/renovate-config`. Moving a repo onto these presets
is tracked in that repo. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`,
`ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root, the ADR
folder created when first needed. See `docs/agents/domain.md`.
