# Agent Job Queue Homebrew tap

Homebrew distribution for [Agent Job Queue](https://github.com/Dunky13/agent-job-queue), a macOS menu-bar app and shared queue for heavy coding-agent commands.

The first installer release is pending. Until a validated app release publishes its manifest and the refresh workflow succeeds, this tap has no installable cask.

After that first refresh:

```sh
brew install --cask dunky13/agent-job-queue/agent-job-queue
brew upgrade --cask dunky13/agent-job-queue/agent-job-queue
```

Requires macOS 15 or later and Homebrew. The prebuilt universal app supports Apple Silicon and Intel; Xcode is not required. Setup installs dependencies and private per-user queue support, opens the app, and links `agent-heavy` and `agent-remote` into Homebrew's bin directory.

The build is ad hoc signed, not notarized. Homebrew quarantine remains enabled; macOS may require its normal approval before opening the app.

Uninstall removes the menu app and Homebrew links. It preserves the queue daemon, active jobs, private backend, operator commands, data, credentials, and enabled remote access. Disable remote access in settings or with `agent-remote disable` first if its HTTPS service should stop. No destructive zap action is supplied.

## Distribution updates

The default branch `tap` is a generated distribution channel. App source and its required pull-request checks remain in the app repository on protected `main`.

The refresh workflow checks public app releases every 15 minutes; GitHub can delay scheduled runs. It selects the highest published build with a valid strict manifest, verifies the actual installer ZIP checksum and release identity, regenerates the cask from the trusted local template, and checks the real Homebrew DSL before publication. It never executes Ruby downloaded from a release.

Updates use the tap repository's GitHub Actions token and GitHub-signed API commits, with a matching DCO trailer verified after publication. Checkout identity and expected-head comparison prevent stale updates. No personal access token or cross-repository secret is needed.

An owner can trigger refresh after a validated app release:

```sh
gh workflow run refresh.yml --repo Dunky13/homebrew-agent-job-queue --ref tap
```

Maintainer tooling is reviewed and tested in the app repository under `packaging/homebrew/`. Copy reviewed controller/template changes here through signed, DCO-signed-off commits. Published metadata is under `Casks/`; leave it to the refresh workflow. The MIT license covers this tap's tooling; the installer includes its own notices.
