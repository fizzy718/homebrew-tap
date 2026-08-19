cask "agentmicro" do
  version "0.1.5"
  sha256 "2206de21947a426b072c5b8ef8b099f52387fa406e0bb529d6c2657c1612d458"

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
