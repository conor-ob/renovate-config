# renovate-config

Shared [Renovate](https://docs.renovatebot.com/) presets for conor-ob repos.
Each repo extends `default`, adds the stack presets it needs, and lists its
own exceptions. A policy change is then one PR here, not one per repo.

## Using it

Put this in the repo's `renovate.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>conor-ob/renovate-config",
    "github>conor-ob/renovate-config:storybook"
  ]
}
```

`github>conor-ob/renovate-config` is the `default` preset. List stack presets
after it, because later presets override earlier ones. There's no `#tag` pin,
so each repo picks up a change here on its next Renovate run.

## Presets

| Preset | For | What it does |
| --- | --- | --- |
| `default` | Every repo | The baseline policy. Its rules and reasons are in hq's [Renovate baseline](https://github.com/conor-ob/hq/blob/main/docs/renovate.md#policy). |
| `expo` | Expo apps | Expo and React Native patches grouped and auto-merged. Their minors and majors aren't offered. An SDK major waits on the Dashboard for approval. Packages the SDK pins (`react`, `react-native` and some native modules) and majors of `typescript`, `@types/react`, `@babel/*` and `@react-navigation/*` never move on their own. |
| `astro` | Astro sites | `typescript` majors aren't offered until `@astrojs/check`'s peer range allows them. |
| `storybook` | Storybook users | Every storybook package in one PR. |
| `vite-plus` | vite-plus users | `vite-plus`, `@voidzero-dev/vite-plus-core` and the `vite: npm:@voidzero-dev/vite-plus-core@…` alias in one PR, majors included, with one 7-day cooldown. |
| `library` | Published packages | Ranges only widen. `engines` is never touched, and `@types/node` majors are raised by hand. |

Each rule's reason is in its `description`.

## Repo exceptions

Anything only one repo needs goes in that repo's `renovate.json`, after
`extends`, with a `description` that gives the reason:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["github>conor-ob/renovate-config"],
  "packageRules": [
    {
      "description": "Repo exception: graphql-request needs graphql 16.",
      "matchPackageNames": ["graphql"],
      "matchUpdateTypes": ["major"],
      "enabled": false
    }
  ]
}
```

When a second repo needs the same exception, move it here as a stack preset.

## Guards

Renovate opens security fixes one package at a time, so a repo needs a CI check
that fails when an update splits packages that must share a version:

- pnpm repos: strict peer dependencies.
- `expo`: `expo install --check` in CI.
- `vite-plus`: a check that the lockfile holds only one
  `@voidzero-dev/vite-plus-core` version.

## Development

`pnpm install`, then `pnpm validate`. CI runs the same check on every PR and on
`main`. It validates every preset with `renovate-config-validator --strict`,
and checks that each config in `tests/invalid` is rejected.
