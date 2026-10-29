cask "agent-job-queue" do
  version "0.1.0,162"
  sha256 "5755a0d266137029a39882f82a058e72ae762017505dee12a2e6c58bc008306a"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-162-d53dc7b/Agent-Queue-0.1.0-universal.zip"
  name "Agent Queue"
  desc "Shared heavy-command queue with a macOS menu-bar app"
  homepage "https://github.com/Dunky13/agent-job-queue"

  depends_on macos: :sequoia

  # Preserve quarantine so macOS can assess the notarized release.

  app "Agent Queue.app"

  uninstall quit: "io.went.agent-queue"

  caveats <<~EOS
    Open Agent Queue from Applications to finish setup; it registers its own
    background services and adds agent-heavy and agent-remote to ~/.local/bin.
    macOS may ask you to allow Agent Queue in Login Items settings.
    Before removing the app, stop its services with:
      ~/.local/bin/agent-heavy install --app-bundle "#{appdir}/Agent Queue.app" --unregister-services
  EOS
end
