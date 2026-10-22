# Notarized installer transition

Updated on 2026-10-22 with the source repository's Developer ID and Apple
notarization change. This companion update changes trusted rendering and tests;
it does not rewrite generated Casks records or publish an installer.

## Behavior

New releases use a cask without quarantine-removal preflight actions. Its
installer directly executes the signed Go controller with the existing private
payload. Stable CLI wrappers, non-root installation, independent queue retention
and non-destructive uninstall behavior remain in place.

For an unchanged published build, the refresh helper retains the exact
historical cask after validating it against its original bounded public asset.
It does not execute that historical Ruby. The next numbered release adopts the
new template. Keep the current paired Casks manifest and Ruby file throughout
this transition; never remove them to force a template change.

## Verification

The source repository tests renderer parity, trusted delivery, historical-cask
preservation and the actual Homebrew DSL. Quarantined inert fixtures establish
attribute preservation only. Its opt-in real-artifact test requires Developer
ID signatures for the expected team and Apple notarization before executing a
quarantined cask against a private daemon and home. Native Homebrew installer
process groups receive bounded teardown; uncertain cleanup retains private
fixture tools rather than exposing a surviving installer to system launchctl.

Standalone refresh tests and Ruby syntax are the applicable checks in this tap.
Apple accepted the source test payload, enclosing installer and DMG with no
reported issues. The source's complete local final-artifact validation passed,
including the real quarantined cask installation against private state. All
204 staged entries retained quarantine and the additional test attribute; the
private daemon remained healthy. Unsigned and incomplete installer rejection
and timeout/normal-exit/cancellation descendant cleanup also passed.

That run caught a fixture fidelity issue: copying only the payload into an
incomplete outer app blocked execution before Go started. Staging the complete
signed and stapled installer fixed the test with its original deadline and
quarantine checks intact. Both hosted architectures now select that regression
in the source's final notarized acceptance job.

The tap's runtime fixture includes the same complete-enclosure repair. All
four trusted tooling files match the source seed byte for byte; source delivery
verifies this parity at the tap commit before updating generated casks.

These are local test artifacts without embedded commit/build identity. A
production release still needs its own tracked build, Apple acceptance and
fresh source acceptance jobs. No claim of offline standalone executable first
launch is made.

## Delivery

Merge this trusted helper update before the source notarization change. Existing
published downloads retain their original signatures and historical cask.
Source publication must finish Apple notarization, ticket stapling and fresh
Apple Silicon/Intel acceptance before dispatching this tap. The source then
verifies exact helper parity and the generated cask at the signed tap commit.
The operator's installed app and queue are not changed by merging these files.

A complete standalone [HTML version](notarized-installers.html) accompanies
this handoff.
