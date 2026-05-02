cask "solo" do
  arch arm: "arm64", intel: "amd64"

  version "0.1.0"
  sha256 arm:   "b69adbe5a5d46785e2b4cbe370afe0d625a7b2f7d02a806dc773f303b9273aa9",
         intel: "d32995ed18e6be0196e74e06a2c88d04b22fd13b969eb02206e74ec55e80f256"

  url "https://github.com/raml-dev/solo/releases/download/#{version}/solo-darwin-#{arch}.dmg",
      verified: "github.com/raml-dev/solo/releases/download/"
  name "Solo"
  desc "The lightweight, fast, open-source API client for modern development"
  homepage "https://github.com/raml-dev/solo"

  app "Solo.app"
end
