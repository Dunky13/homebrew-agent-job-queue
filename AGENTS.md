# Tap agent guide

This public repository distributes Agent Job Queue. Its default `tap` branch is generated distribution metadata, not the app source branch.

Keep trusted helper changes synchronized with reviewed and tested `packaging/homebrew/` files in the app repository. Do not edit generated `Casks/` entries manually, disable checksum or signature checks, run downloaded Ruby, bypass quarantine, or delete queue data. Preserve running jobs and private configuration.

Commits require configured cryptographic signing and matching DCO sign-off. The refresh workflow uses GitHub-signed API commits on `tap` only, after validation. Do not use em dashes or commit credentials, local state, private logs, or machine-specific checkout paths.
