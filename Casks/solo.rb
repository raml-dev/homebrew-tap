cask "solo" do
  arch arm: "arm64", intel: "amd64"

  version "0.1.0"
  sha256 arm:   "656b50585e5ae6e4a1f0198e8e05c4a9ae21fac9d883e816193b4fad4ef74d54",
         intel: "af210865fb4b1e6e28069eed248ddf9465ba72ab98d205b3b31884fa09a60cc9"

  url "https://github.com/raml-dev/solo/releases/download/#{version}/solo-darwin-#{arch}.dmg",
      verified: "github.com/raml-dev/solo/releases/download/"
  name "Solo"
  desc "The lightweight, fast, open-source API client for modern development"
  homepage "https://github.com/raml-dev/solo"

  app "Solo.app"
end
