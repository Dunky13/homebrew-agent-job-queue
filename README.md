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

Each successfully published main installer dispatches this tap's refresh workflow with the exact tag and source commit. The source delivery job waits for the returned workflow run and independently verifies the signed tap commit, strict manifest and cask. A newer published descendant may supersede an older request; the tap never rolls back.

The 15-minute schedule is recovery, together with manual dispatch. GitHub can delay or drop scheduled events. Refresh selects the highest published build through a bounded paginated search, validates the actual installer ZIP checksum and release identity, regenerates the cask from its trusted local template, and checks the real Homebrew DSL before publication. Even an unchanged build is revalidated, making drift a visible failure. Downloaded Ruby is never executed.

Updates use this repository's GitHub Actions token and GitHub-signed API commits with a matching DCO trailer, verified after publication. Current checkout identity and expected-head comparison reject stale writes. The source repository uses a private GitHub App with Actions write access to this tap only for dispatch and run status. The App has no content-write access; its key is stored only in the source repository. See [source PR 8](https://github.com/Dunky13/agent-job-queue/pull/8) and its delivery guide for setup. No personal access token or App secret is needed in this tap.

Pull requests into tap run isolated read-only refresh tests. Production refresh jobs serialize separately, check out the current tap branch, and accept publication only on schedule or explicit workflow dispatch.

An owner can trigger refresh after a validated app release:

```sh
gh workflow run refresh.yml --repo Dunky13/homebrew-agent-job-queue --ref tap
```

Maintainer tooling is reviewed and tested in the app repository under `packaging/homebrew/`. Copy reviewed refresh.go, refresh_test.go, test-cask.rb, the refresh workflow, and the root LICENSE here through signed, DCO-signed-off commits. The Go helper and its copied tests use only the standard library, without Python or app-module downloads. Validate them with `go test -p 2 refresh.go refresh_test.go` using Go 1.26 or later. Source-only renderer parity tests remain in the app repository.

The source delivery job requires exact helper parity, so merge a companion tap tooling PR before the corresponding source change. Published metadata is under `Casks/`; leave it to the refresh workflow. The current cask retains its original release identity and installation requirements until a newer validated app release is published. The MIT license covers this tap's tooling; the installer includes its own notices.

The quarantine preflight uses `preflight_steps` when supported, with a legacy `preflight` fallback. The real Homebrew DSL helper checks that exactly one preflight precedes the installer and both binary artifacts. A failed attribute removal aborts installation. The app repository's macOS tests cover a quarantined private fixture, retained unrelated attributes, both compatibility paths, and failure before installer execution.

The quarantine behavior retains the [issue #4 implementation and validation](https://github.com/Dunky13/agent-job-queue/pull/5). The current delivery handoff is available as [Markdown](docs/handoffs/source-pr-8.md) and [standalone HTML](docs/handoffs/source-pr-8.html), with a complete [setup and recovery guide](docs/homebrew-delivery.md). Reviewed template changes retain a verified historical cask until a newer numbered app release is published, then render the new build with current trusted tooling. This preserves provenance across repeated tooling updates.
