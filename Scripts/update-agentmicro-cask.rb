#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "net/http"
require "pathname"
require "uri"

REPOSITORY = "fizzy718/AgentMicro"
CASK_PATH = Pathname(__dir__).join("..", "Casks", "agentmicro.rb").realpath
RELEASE_URL = URI("https://api.github.com/repos/#{REPOSITORY}/releases/latest")

response = Net::HTTP.start(RELEASE_URL.host, RELEASE_URL.port, use_ssl: true) do |http|
  request = Net::HTTP::Get.new(RELEASE_URL)
  request["Accept"] = "application/vnd.github+json"
  request["User-Agent"] = "homebrew-tap-agentmicro-updater"
  token = ENV.fetch("GITHUB_TOKEN", ENV.fetch("GH_TOKEN", ""))
  request["Authorization"] = "Bearer #{token}" unless token.empty?
  http.request(request)
end

abort "GitHub release request failed: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

release = JSON.parse(response.body)
abort "Latest AgentMicro release is not publishable" if release.fetch("draft") || release.fetch("prerelease")

version = release.fetch("tag_name").delete_prefix("v")
asset_name = "AgentMicro-macos-universal-#{version}.dmg"
asset = release.fetch("assets").find { |candidate| candidate["name"] == asset_name }
abort "Latest AgentMicro release is missing #{asset_name}" unless asset

digest = asset.fetch("digest", "").delete_prefix("sha256:")
abort "Release asset has no SHA-256 digest" unless digest.match?(/\A[0-9a-f]{64}\z/)

contents = CASK_PATH.read
updated = contents.sub(/^  version ".*"$/, "  version \"#{version}\"")
updated = updated.sub(/^  sha256 "[0-9a-f]{64}"$/, "  sha256 \"#{digest}\"")
abort "Could not update the AgentMicro Cask version and checksum" if updated == contents && !contents.include?("version \"#{version}\"")

if ARGV == ["--check"]
  abort "AgentMicro Cask is out of date (latest is #{version})" unless updated == contents
  puts "AgentMicro Cask is current (#{version})"
  exit 0
end

abort "Usage: #{File.basename($PROGRAM_NAME)} [--check]" unless ARGV.empty?

if updated == contents
  puts "AgentMicro Cask is already current (#{version})"
else
  CASK_PATH.write(updated)
  puts "Updated AgentMicro Cask to #{version}"
end
