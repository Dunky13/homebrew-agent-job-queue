cask "agent-job-queue" do
  version "0.1.0,18"
  sha256 "74a85271027c3bd70923f1d97e190969e8d8626bf309910eb49e54c5439a16bc"

  url "https://github.com/Dunky13/agent-job-queue/releases/download/build-18-9a57e20/Agent-Job-Queue-Installer-0.1.0-universal.zip"
  name "Agent Job Queue"
  desc "Shared heavy-command queue with a macOS menu-bar app"
  homepage "https://github.com/Dunky13/agent-job-queue"

  depends_on formula: "caddy"
  depends_on formula: "pueue"
  depends_on formula: "python@3.12"
  depends_on formula: "uv"
  depends_on macos: :sequoia

  # Ad hoc signed and not notarized: clear quarantine only on this staged build
  # before executing its installer or copying its app and command wrappers.
  if respond_to?(:preflight_steps)
    preflight_steps do
      run "/usr/bin/xattr",
          args: ["-dr", "com.apple.quarantine", "{{staged_path}}"],
          must_succeed: true
    end
  else
    preflight do
      system_command "/usr/bin/xattr",
                     args: ["-dr", "com.apple.quarantine", staged_path],
                     must_succeed: true
    end
  end

  # The vendor installer also prepares private per-user CLI support and services.
  payload = "#{staged_path}/Agent Job Queue Installer.app/Contents/Resources/payload"
  installer script: {
    executable: "#{payload}/source/scripts/install-user.sh",
    args:       ["--payload", payload],
    sudo:       false,
  }

  binary "Agent Job Queue Installer.app/Contents/Resources/payload/source/bin/agent-heavy"
  binary "Agent Job Queue Installer.app/Contents/Resources/payload/source/bin/agent-remote"

  # Keep the independent backend available to running jobs and other installers.
  uninstall quit:   "io.went.agent-queue",
            delete: [
              "#{Dir.home}/Applications/Agent Queue.app",
              "#{Dir.home}/Library/LaunchAgents/io.went.agent-queue.plist",
            ]

  caveats <<~EOS
    Installs and opens Agent Queue for this macOS account without a manual setup step.
    Phone access is off until enabled in the app. This build is ad hoc signed, not notarized.
    Installation clears quarantine only on this cask's staged files so they can run.
    Uninstall removes the menu app and Homebrew command links. The shared per-user backend,
    operator commands, queue jobs, credentials and enabled remote access remain available.
    Disable phone access in settings before uninstall if you want its HTTPS service stopped.
  EOS
end
