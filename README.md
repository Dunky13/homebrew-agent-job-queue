# Agent Job Queue Homebrew tap

Homebrew distribution for [Agent Job Queue](https://github.com/Dunky13/agent-job-queue), a macOS menu-bar app and shared queue for heavy coding-agent commands.

A cask becomes available after a validated app release publishes its manifest and the refresh workflow succeeds. On a new tap, installation remains unavailable until that first refresh.

After that first refresh:

```sh
brew install --cask dunky13/agent-job-queue/agent-job-queue
brew upgrade --cask dunky13/agent-job-queue/agent-job-queue
```

Requires macOS 15 or later and Homebrew. The prebuilt universal app supports Apple Silicon and Intel; Xcode is not required. Setup installs dependencies and private per-user queue support, opens the app, and links `agent-heavy` and `agent-remote` into Homebrew's bin directory.

The build is ad hoc signed, not notarized. After Homebrew verifies the download's SHA-256, the cask removes only `com.apple.quarantine` from its own staged files before any installer or command runs. This deliberate trust decision for this tap avoids Gatekeeper blocking the unnotarized installer. Signatures and other extended attributes remain intact, and system-wide security settings are unchanged. No Apple Developer Program membership is required. Manually downloaded ZIP or DMG builds can still require macOS approval.

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

The quarantine preflight uses `preflight_steps` when supported, with a legacy `preflight` fallback. The real Homebrew DSL helper checks that exactly one preflight precedes the installer and both binary artifacts. A failed attribute removal aborts installation. The app repository's macOS tests cover a quarantined private fixture, retained unrelated attributes, both compatibility paths, and failure before installer execution.

The [issue #4 implementation and validation](https://github.com/Dunky13/agent-job-queue/pull/5) also includes the portable Markdown and HTML handoff. Merge the synchronized tap tooling before that app PR publishes a newer build, then run the refresh workflow. Its monotonic build check leaves the existing generated cask unchanged until a newer app release is available.
