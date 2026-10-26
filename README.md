# Agent Job Queue Homebrew tap

Homebrew distribution for [Agent Job Queue](https://github.com/Dunky13/agent-job-queue), a macOS menu-bar app and shared queue for heavy coding-agent commands.

A cask becomes available after a validated app release publishes its manifest and the refresh workflow succeeds. On a new tap, installation remains unavailable until that first refresh.

After that first refresh:

```sh
brew install --cask dunky13/agent-job-queue/agent-job-queue
brew upgrade --cask dunky13/agent-job-queue/agent-job-queue
```

Requires macOS 15 or later and Homebrew. The prebuilt universal app supports Apple Silicon and Intel; Xcode is not required. Homebrew installs the app in your account's Applications folder and links `agent-heavy` and `agent-remote` into its bin directory. Open Agent Queue to complete its private per-user queue setup. The command-line tools are ready after setup completes; the app shows progress and offers Retry on failure.

New releases from the source repository's notarized pipeline use Developer ID signatures and Apple notarization. Their casks keep quarantine. The managed-app template uses Homebrew's native app artifact and leaves backend setup to the app's existing first-launch flow, so it never runs setup through a group-writable Caskroom or a restricted installation hook. Historical casks retain their original behavior until a newer numbered release replaces them. Download checksums identify bytes; they do not replace Apple notarization or Gatekeeper policy. First launch can require access to Apple's notarization service.

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

The managed-app template has no executable install hooks. Its real Homebrew DSL check verifies the native app target, stable command wrappers, bounded non-root login-entry removal, and safe uninstall. Quarantined fixtures check app relocation and attribute preservation without executing their contents; real notarized relocation and signed first-launch setup are verified separately in source CI. Homebrew can restore a managed app when a later artifact fails to install. The first upgrade from an old script-installer cask still executes that old cask's deletion rules, and its metadata cannot acquire app rollback support retroactively.

Historical ad hoc quarantine behavior is documented in the [issue #4 implementation and validation](https://github.com/Dunky13/agent-job-queue/pull/5). The current delivery handoff is available as [Markdown](docs/handoffs/source-pr-8.md) and [standalone HTML](docs/handoffs/source-pr-8.html), with a complete [setup and recovery guide](docs/homebrew-delivery.md). Reviewed template changes retain a verified historical cask until a newer numbered app release is published, then render the new build with current trusted tooling. This preserves provenance across repeated tooling updates.
