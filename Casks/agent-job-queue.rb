cask "agent-job-queue" do
  version "0.1.0,94"
  sha256 "aaa89d93bb4249e909036d9ed0f7a0d7ac5536af907f6fad176bb6cb8f679a30"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-94-fe05988/Agent-Job-Queue-Installer-0.1.0-universal.zip"
  name "Agent Job Queue"
  desc "Shared heavy-command queue with a macOS menu-bar app"
  homepage "https://github.com/Dunky13/agent-job-queue"

  depends_on macos: :sequoia

  # Preserve quarantine so macOS can assess the notarized release.

  application = "#{Dir.home}/Applications/Agent Queue.app"
  app "Agent Job Queue Installer.app/Contents/Resources/payload/Agent Queue.app", target: application

  # Stable per-user wrappers survive staged cask cleanup and future upgrades.
  binary "Agent Job Queue Installer.app/Contents/Resources/payload/source/links/agent-heavy"
  binary "Agent Job Queue Installer.app/Contents/Resources/payload/source/links/agent-remote"

  # The app artifact owns app removal and upgrade rollback.
  uninstall quit: "io.went.agent-queue",
            script: {
              executable: "/bin/rm",
              args: ["-f", "--", "#{Dir.home}/Library/LaunchAgents/io.went.agent-queue.plist"],
              sudo: false,
            }

  caveats <<~EOS
    Installs Agent Queue for this account without Python, uv, or a Go toolchain.
    Open Agent Queue to finish setup. Command-line tools are ready after setup completes.
    Release installer and app are Developer ID signed and notarized.
    Quarantine is retained. Phone access is off until enabled.
    Uninstall preserves the independent queue, jobs, credentials and remote access.
    Disable phone access in settings before uninstall to stop its HTTPS service.
  EOS
end
