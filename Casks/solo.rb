cask "solo" do
  arch arm: "arm64", intel: "amd64"

  version "0.1.0"
  sha256 arm:   "d1bf80b2149bfcf6af50dbff7898fe3903a00c9145f8ef7d05fa127cad3122ea",
         intel: "336198a1bfbf163e879aad5dd6f08cbc56bb803da6980c5d2706a26b3d61d2e4"

  url "https://github.com/raml-dev/solo/releases/download/#{version}/solo-darwin-#{arch}.dmg",
      verified: "github.com/raml-dev/solo/releases/download/"
  name "Solo"
  desc "The lightweight, fast, open-source API client for modern development"
  homepage "https://github.com/raml-dev/solo"

  app "Solo.app"
end
