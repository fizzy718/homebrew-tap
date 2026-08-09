cask "agentmicro" do
  version "0.1.4"
  sha256 "baa02f8afe828c016a6c11ae46cd48b7130dbc6e596b691481a5a40bbfb36429"

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
