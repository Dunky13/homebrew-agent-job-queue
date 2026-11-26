cask "agent-job-queue" do
  version "0.1.0,316"
  sha256 "cf698848ae03a2c350d159f42d21fc4ecd45ca9ec8b21d4e4da8e58b2ab428ea"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-316-248a728/Agent-Queue-0.1.0-universal.zip"
  name "Agent Queue"
  desc "Shared heavy-command queue with a macOS menu-bar app"
  homepage "https://github.com/Dunky13/agent-job-queue"

  depends_on macos: :sequoia

  # Preserve quarantine so macOS can assess the notarized release.

  app "Agent Queue.app"

  uninstall quit: "io.went.agent-queue"

  caveats <<~EOS
    Open Agent Queue from Applications to use its menu bar.
    Before removing the app, finish its jobs, then run this. It quits the app and removes its login item:
      ~/.local/bin/agent-heavy install --app-bundle "#{appdir}/Agent Queue.app" --unregister-services
  EOS
end
