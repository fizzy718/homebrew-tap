cask "agentmicro" do
  version "0.1.3"
  sha256 "b232fab187e656bab87012c8863f31346a81fe2ec06f5b6fa6e78e8824f0b721"

  url "https://github.com/fizzy718/AgentMicro/releases/download/v#{version}/AgentMicro-macos-universal-#{version}.dmg"
  name "AgentMicro"
  desc "Menu bar companion for Codex task status"
  homepage "https://github.com/fizzy718/AgentMicro"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "AgentMicro.app"

  uninstall quit: "com.agentmicro.macos"

  zap trash: "~/Library/Preferences/com.agentmicro.macos.plist"
end
