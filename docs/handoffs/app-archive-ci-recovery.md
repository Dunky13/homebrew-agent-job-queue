# App archive CI recovery

## Failure and repair

[Refresh run 40956511962](https://github.com/Dunky13/homebrew-agent-job-queue/actions/runs/40956511962), at tap commit `b45ee373129beb41bc4658daf5232c90e05994a9`, failed with `Unexpected installer asset`. Its trusted helper accepted only the old installer ZIP. The latest public release, `build-156-2755c95`, instead contains `Agent-Queue-0.1.0-universal.zip`.

Copy the five canonical trusted files from [companion app PR 55](https://github.com/Dunky13/agent-job-queue/pull/55): `packaging/homebrew/refresh.go`, `refresh_test.go`, `test-cask.rb`, `.github/workflows/refresh.yml`, and the root `LICENSE`. The files in this repair match the companion source candidate byte for byte. Generated `Casks/` entries and published releases remain unchanged by this PR. Merge this tap repair before the source repair.

The helper accepts the old installer asset only while validating the existing predecessor state against its public release and archive checksum. A full read-only refresh exposed that build 150's tap cask differs from the cask attached to its release: the trusted tap template advanced from a script installer to a managed app after publication. This repair compares that predecessor against either the exact frozen trusted managed-app template from tap `b45ee373129beb41bc4658daf5232c90e05994a9` or the bounded original public cask. Both are data and are never evaluated or republished. Arbitrary cask drift still fails.

The latest release must use the app ZIP. Checksums, signed publication, expected-head comparison, ancestry and quarantine remain enforced. Regressions cover both historical template states, successful migration, drift, corrupt legacy archives, unrelated ancestry and rejection of same-build, latest-installer and unknown-asset states.

## Local evidence

The actual published build-156 manifest fails the old helper with the hosted error and passes the copied helper. Standalone race tests, vet, formatting, workflow lint and Ruby syntax checks pass:

```sh
go test -race -p 2 -parallel 2 refresh.go refresh_test.go
go vet -p 2 refresh.go
gofmt -l refresh.go refresh_test.go
actionlint .github/workflows/refresh.yml
ruby -c test-cask.rb
```

Source-side Homebrew lifecycle and parity validation is recorded in the companion app recovery handoff. Local fixtures do not establish hosted publication, Apple acceptance or installed runtime behavior.

## Delivery boundary

Merge requires final-head CI, independent review and owner approval. After merge, a scheduled refresh can reconcile the existing public release; explicit dispatch also publishes metadata and requires the corresponding authorization:

```sh
gh workflow run refresh.yml --repo Dunky13/homebrew-agent-job-queue --ref tap
gh run list --repo Dunky13/homebrew-agent-job-queue --workflow refresh.yml --limit 5
```

Successful PR tests do not prove a successful refresh. Verify the refresh run and resulting signed generated commit before declaring delivery recovered. No app rebuild, Apple submission, new release or local installation is needed for this tooling sync.
