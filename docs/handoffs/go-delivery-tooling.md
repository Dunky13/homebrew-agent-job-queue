# Go refresh tooling handoff

Date: 2026-10-20

## Outcome and scope

The tap refresh controller and tests use Go's standard library. The refresh workflow installs Go, runs the copied tests on pull requests, and runs the reviewed controller on scheduled or explicit distribution refreshes. Python helpers are removed.

The trusted files are copied from the app repository's `packaging/homebrew/`: `refresh.go`, `refresh_test.go`, `test-cask.rb`, and `.github/workflows/refresh.yml`, together with its root `LICENSE`. Source-only renderer parity tests stay in the app repository and are not copied here.

Generated `Casks/` files retain their existing bytes and release identity. This tooling change does not publish a new app release, install the app, migrate a live queue, or remove prerequisites from the currently published installer.

## Preserved delivery checks

The controller reads only the fixed public app repository. It validates strict release metadata, the requested source identity, the actual installer checksum, and the trusted cask rendered locally. Downloaded Ruby is treated as bounded historical data and is never executed. The real Homebrew DSL validates only the locally rendered cask.

Publication requires the tap's own GitHub Actions token, an allowed workflow event, the current distribution head, and an expected-head compare-and-swap. The resulting commit must have a verified signature and an author-matching DCO sign-off. Pull requests cannot publish. Newer builds require verified source ancestry; stale or conflicting identities fail visibly.

When a trusted template changes, the existing cask is validated against its historical public artifact and retained until a newer numbered app release is available. Installer quarantine handling remains limited to this cask's verified staged download. Uninstall and upgrade preserve jobs, private queue support, and enabled remote access.

## Validation

Shared queued validation passed: source-side packaging, delivery, and tooling race tests completed in 3.033, 1.896, and 2.343 seconds respectively. The actual standalone tap tests passed under race detection in 1.531 seconds with module downloads and workspaces disabled. Go vet, workflow lint, Ruby syntax, and diff checks also passed.

Independent GPT-6.1 Sol high source review found no remaining material issue after the linked recovery guide was updated to Go. All five copied files match the source exactly, and generated cask bytes remain unchanged. Hosted CI, live publication, and installation are separate verification steps.

The source-side copy test runs exactly `refresh.go` and `refresh_test.go` outside the app module, with module downloads and workspaces disabled. This prevents app-only test imports from accidentally becoming tap prerequisites.

## Merge and release order

Review this companion change together with the app's Go migration. Merge the tap tooling update before the corresponding source change, because source delivery enforces byte-identical trusted tooling. Human approval remains required for merge.

The next successfully published app build can then drive a normal refresh through the source delivery job. Verify the exact tap run and its signed metadata readback before calling Homebrew delivery complete. No live refresh or release publication has been performed as part of local validation.

For the first Pueue-to-Go app installation, finish all running and waiting jobs, including cleanup, before migration. The app installer enforces this boundary. A Python-based installation also requires old remote access to be disabled. A tooling PR alone does not perform that migration.

## Verification entry point

```sh
go test -p 2 refresh.go refresh_test.go
go vet refresh.go
actionlint .github/workflows/refresh.yml
ruby -c test-cask.rb
```

Apply the operator's shared resource queue policy to broad validation. The test fixtures do not publish metadata or operate on the installed queue.

This handoff has a complete self-contained [HTML version](go-delivery-tooling.html).
