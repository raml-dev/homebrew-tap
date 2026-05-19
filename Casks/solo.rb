cask "solo" do
  arch arm: "arm64", intel: "amd64"

  version "0.2.0"
  sha256 arm:   "292d75537d6ea1081227e48b16edbe25c1fc8759b0031632d61260f5f3a8087a",
         intel: "63a5fd54e52370c5c18b330e8f5537d0784d1709d9c568fba147b14d8880c581"

  url "https://github.com/raml-dev/solo/releases/download/#{version}/solo-darwin-#{arch}.dmg",
      verified: "github.com/raml-dev/solo/releases/download/"
  name "Solo"
  desc "The lightweight, fast, open-source API client for modern development"
  homepage "https://github.com/raml-dev/solo"

  app "Solo.app"
end
