cask "solo" do
  arch arm: "arm64", intel: "amd64"

  version "0.1.0"
  sha256 arm:   "730fd04c137d8cc12619ad4f4df2837e4946ccf16be9e9628126768044b231bc",
         intel: "1cd7e5627068e77d033580aa31015296885cbec727f1f7b48318adbf4726675b"

  url "https://github.com/raml-dev/solo/releases/download/#{version}/solo-darwin-#{arch}.dmg",
      verified: "github.com/raml-dev/solo/releases/download/"
  name "Solo"
  desc "The lightweight, fast, open-source API client for modern development"
  homepage "https://github.com/raml-dev/solo"

  app "Solo.app"
end
