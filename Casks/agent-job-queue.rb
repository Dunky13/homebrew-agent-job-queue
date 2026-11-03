cask "agent-job-queue" do
  version "0.1.0,261"
  sha256 "4f4c5c0f14919a6fdf4dae1831ca62bd187774aedcb07096e7d3b7d3bfbe828a"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-261-d8ef9a9/Agent-Queue-0.1.0-universal.zip"
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
