cask "agent-job-queue" do
  version "0.1.0,166"
  sha256 "33a0efa7ee2e6cc11282a20d510d0ac11244695f5f811ae21c65369a11614a85"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-166-2295abe/Agent-Queue-0.1.0-universal.zip"
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
