# Copyright 2026-present raml-dev
# SPDX-License-Identifier: AGPL-3.0-only

set -euo pipefail

log() {
  printf '[homebrew-tap] %s\n' "$*" >&2
}

die() {
  log "ERROR: $*"
  exit 1
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    die "missing required environment variable: ${name}"
  fi
}

repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

REPO_ROOT="$(repo_root)"
WORK_DIR="${RUNNER_TEMP:-/tmp}/homebrew-tap-work"
RELEASE_JSON_PATH="${WORK_DIR}/release.json"
SHA256SUMS_PATH="${WORK_DIR}/SHA256SUMS"
CASK_PATH="${REPO_ROOT}/Casks/${CASK_NAME}.rb"

release_api_headers() {
  if [[ -n "${SOURCE_GITHUB_TOKEN:-${GITHUB_TOKEN:-}}" ]]; then
    printf '%s\n' \
      "-H" "Authorization: Bearer ${SOURCE_GITHUB_TOKEN:-${GITHUB_TOKEN}}" \
      "-H" "Accept: application/vnd.github+json"
  else
    printf '%s\n' "-H" "Accept: application/vnd.github+json"
  fi
}

fetch_release_json() {
  local -a curl_args

  mapfile -t curl_args < <(release_api_headers)
  if curl -fsSL "${curl_args[@]}" "${PACKAGE_RELEASE_API_URL}" > "${RELEASE_JSON_PATH}"; then
    return
  fi

  curl -fsSL -H "Accept: application/vnd.github+json" "${PACKAGE_RELEASE_API_URL}" > "${RELEASE_JSON_PATH}"
}

validate_release() {
  jq -e '.prerelease == false' "${RELEASE_JSON_PATH}" >/dev/null || die "refusing to ingest a prerelease"
  jq -e '.draft == false' "${RELEASE_JSON_PATH}" >/dev/null || die "refusing to ingest a draft release"
}

validate_dispatch() {
  [[ -n "${CASK_NAME}" ]] || die "missing cask name"
  [[ -n "${HOMEBREW_SOURCE_REPOSITORY}" ]] || die "missing source repository"
  case "${PACKAGE_RELEASE_API_URL}" in
    */repos/"${HOMEBREW_SOURCE_REPOSITORY}"/releases/*) ;;
    *)
      die "dispatch source repository mismatch for release API URL: expected ${HOMEBREW_SOURCE_REPOSITORY}"
      ;;
  esac
}

release_asset_browser_url() {
  local asset_name="$1"
  jq -r --arg asset_name "${asset_name}" '
    .assets[]
    | select(.name == $asset_name)
    | .browser_download_url
  ' "${RELEASE_JSON_PATH}"
}

download_public_url() {
  local url="$1"
  local output_path="$2"
  curl -fsSL "${url}" > "${output_path}"
}

download_sha256sums() {
  local url

  url="$(release_asset_browser_url "SHA256SUMS")"
  [[ -n "${url}" && "${url}" != "null" ]] || die "release asset not found: SHA256SUMS"
  download_public_url "${url}" "${SHA256SUMS_PATH}"
}

sha256_for_asset() {
  local asset_name="$1"
  awk -v asset_name="${asset_name}" '$2 == asset_name { print $1 }' "${SHA256SUMS_PATH}"
}

render_cask() {
  local intel_sha arm_sha cask_file

  intel_sha="$(sha256_for_asset "${CASK_NAME}-darwin-amd64.dmg")"
  arm_sha="$(sha256_for_asset "${CASK_NAME}-darwin-arm64.dmg")"
  [[ -n "${intel_sha}" ]] || die "missing SHA256SUMS entry for ${CASK_NAME}-darwin-amd64.dmg"
  [[ -n "${arm_sha}" ]] || die "missing SHA256SUMS entry for ${CASK_NAME}-darwin-arm64.dmg"

  mkdir -p "$(dirname "${CASK_PATH}")"

  cat > "${CASK_PATH}" <<EOF
cask "${CASK_NAME}" do
  arch arm: "arm64", intel: "amd64"

  version "${PACKAGE_RELEASE_VERSION}"
  sha256 arm:   "${arm_sha}",
         intel: "${intel_sha}"

  url "https://github.com/${HOMEBREW_SOURCE_REPOSITORY}/releases/download/#{version}/${CASK_NAME}-darwin-#{arch}.dmg",
      verified: "github.com/${HOMEBREW_SOURCE_REPOSITORY}/releases/download/"
  name "${PACKAGE_APP_NAME}"
  desc "${PACKAGE_APP_DESCRIPTION}"
  homepage "https://github.com/${HOMEBREW_SOURCE_REPOSITORY}"

  app "${PACKAGE_APP_NAME}.app"
end
EOF
}

main() {
  require_env "CASK_NAME"
  require_env "HOMEBREW_SOURCE_REPOSITORY"
  require_env "PACKAGE_RELEASE_VERSION"
  require_env "PACKAGE_RELEASE_API_URL"
  require_env "PACKAGE_APP_NAME"
  require_env "PACKAGE_APP_DESCRIPTION"

  mkdir -p "${WORK_DIR}"

  log "validating dispatch..."
  validate_dispatch
  log "fetching release..."
  fetch_release_json
  log "validating release..."
  validate_release
  log "downloading checksums..."
  download_sha256sums
  log "rendering cask..."
  render_cask
}

main "$@"
