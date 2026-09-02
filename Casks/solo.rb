cask "solo" do
  arch arm: "arm64", intel: "amd64"

  version "0.3.1"
  sha256 arm:   "e503b4a14f4ec78b6e9d8a07a430ed50795bc511183b028282544173d311b93d",
         intel: "b83656e28d9316f6116e41c13d28acb67ef7c33eb010e7695078b69f8acba796"

  url "https://github.com/raml-dev/solo/releases/download/#{version}/solo-darwin-#{arch}.dmg",
      verified: "github.com/raml-dev/solo/releases/download/"
  name "Solo"
  desc "The lightweight, fast, open-source API client for modern development"
  homepage "https://github.com/raml-dev/solo"

  app "Solo.app"
end
