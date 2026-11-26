# renovate-config

Shared Renovate presets that conor-ob repos extend.

## Dependency updates

**Lockstep set**:
Packages that must share a version, or satisfy each other's peer ranges, for
the app to work. A set is either a release train (published together at one
version, such as storybook and its addons) or peer-bound (tied by declared peer
ranges, such as Ionic and react-router).
_Avoid_: monorepo group, linked packages

**Guard**:
A CI check that makes a broken dependency update fail instead of merging, such
as strict peer dependencies or `expo install --check`.
_Avoid_: safety net, gate

**Stack preset**:
A preset a repo opts into by name for a Lockstep set that two or more repos
share, or for a kind of repo (`library`). A set only one repo has stays in that
repo's exceptions until a second repo needs it.
