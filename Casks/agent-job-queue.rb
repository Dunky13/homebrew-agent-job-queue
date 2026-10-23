cask "agent-job-queue" do
  version "0.1.0,66"
  sha256 "a52f91cc1992c815c53b92a3382784f98f7b9b6971e89605ef945d4c4c0bffee"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-66-8ce8301/Agent-Job-Queue-Installer-0.1.0-universal.zip"
  name "Agent Job Queue"
  desc "Shared heavy-command queue with a macOS menu-bar app"
  homepage "https://github.com/Dunky13/agent-job-queue"

  depends_on macos: :sequoia

  # Preserve quarantine so macOS can assess the notarized release.

  payload = "#{staged_path}/Agent Job Queue Installer.app/Contents/Resources/payload"
  installer script: {
    executable: "#{payload}/source/bin/agent-heavy",
    args:       ["install", "--payload", payload],
    sudo:       false,
  }

  # Stable per-user wrappers survive staged cask cleanup and future upgrades.
  binary "Agent Job Queue Installer.app/Contents/Resources/payload/source/links/agent-heavy"
  binary "Agent Job Queue Installer.app/Contents/Resources/payload/source/links/agent-remote"

  uninstall quit: "io.went.agent-queue",
            delete: [
              "#{Dir.home}/Applications/Agent Queue.app",
              "#{Dir.home}/Library/LaunchAgents/io.went.agent-queue.plist",
            ]

  caveats <<~EOS
    Installs and opens Agent Queue for this account without Python, uv, or a Go toolchain.
    Release installer and app are Developer ID signed and notarized.
    Quarantine is retained. Phone access is off until enabled.
    Uninstall preserves the independent queue, jobs, credentials and remote access.
    Disable phone access in settings before uninstall to stop its HTTPS service.
  EOS
end
