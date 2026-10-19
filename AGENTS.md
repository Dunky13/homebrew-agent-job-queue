# Tap agent guide

This public repository distributes Agent Job Queue. Its default `tap` branch is generated distribution metadata, not the app source branch.

Keep trusted helper changes synchronized with reviewed and tested `packaging/homebrew/` files in the app repository. Do not edit generated `Casks/` entries manually, disable checksum or signature checks, run downloaded Ruby, or delete queue data. The [app issue #4](https://github.com/Dunky13/agent-job-queue/issues/4) exception clears only `com.apple.quarantine` from this cask's verified staged download before installation. Never expand it to other paths, other attributes, system-wide security settings, or a manual install. Preserve running jobs and private configuration.

Commits require configured cryptographic signing and matching DCO sign-off. The refresh workflow uses GitHub-signed API commits on `tap` only, after validation. Do not use em dashes or commit credentials, local state, private logs, or machine-specific checkout paths.
