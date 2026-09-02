cask "solo" do
  arch arm: "arm64", intel: "amd64"

  version "0.3.0"
  sha256 arm:   "448b5a054573f98b3ee46cdea321296f930914e1ab2225ac7132c2feece9034b",
         intel: "6e57d1f14b78439e5678efc485b5f2a3b8d3a1019cefdca084af5c4aa001ef50"

  url "https://github.com/raml-dev/solo/releases/download/#{version}/solo-darwin-#{arch}.dmg",
      verified: "github.com/raml-dev/solo/releases/download/"
  name "Solo"
  desc "The lightweight, fast, open-source API client for modern development"
  homepage "https://github.com/raml-dev/solo"

  app "Solo.app"
end
