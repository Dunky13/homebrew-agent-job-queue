cask "agent-job-queue" do
  version "0.1.0,263"
  sha256 "93c1f886eeb3200f20a381a9fdd6773ad3f9e85d295a1f1e9d8660240513fecd"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-263-b34ee05/Agent-Queue-0.1.0-universal.zip"
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
