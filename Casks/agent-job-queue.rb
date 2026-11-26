cask "agent-job-queue" do
  version "0.1.0,315"
  sha256 "84540fcf2da463086db65de3656af715c6a86a6a82e489640a197500d038ac5f"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-315-429bac4/Agent-Queue-0.1.0-universal.zip"
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
