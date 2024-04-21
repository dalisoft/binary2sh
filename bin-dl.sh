#!/bin/sh
set -eu

OS=""
VENDOR=""
ARCH=""
LINUX_STD="gnu musl "
IS_CHMOD_ALLOWED=true
BINARY_SUFFIX=""

case "$(uname)" in
Darwin)
  OS="darwin"
  VENDOR="apple"
  ;;
Linux)
  OS="linux"
  VENDOR="unknown"
  ;;
FreeBSD)
  OS="freebsd"
  VENDOR="unknown"
  ;;
*)
  OS="windows windows-msvc win32"
  VENDOR="pc"
  IS_CHMOD_ALLOWED=false
  BINARY_SUFFIX=".exe"
  ;;
esac

case "$(uname -m)" in
arm64 | aarch64)
  ARCH="arm64 aarch64"
  ;;
x86_64 | amd64)
  ARCH="x86_64 x64 amd64"
  ;;
i386)
  ARCH="x86 i386"
  ;;
armv7)
  ARCH="armv7"
  ;;
*) ;;
esac

repository=""
binary_name=""
binary_version=""

while :; do
  case "${1-}" in
  --repository=?*)
    repository=${1#*=}
    ;;
  --name=?*)
    binary_name=${1#*=}
    ;;
  --version=?*)
    binary_version=${1#*=}
    ;;
  --) # End of all options.
    shift
    break
    ;;
  *) # Default case: If no more options then break out of the loop.
    break ;;
  esac

  shift
done

if [ -n "${GH_TOKEN-}" ]; then
  RELEASES=$(curl -sL \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GH_TOKEN-}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${repository}/releases")
else
  RELEASES=$(curl -sL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/${repository}/releases")
fi
DOWNLOAD_URLS=$(echo "${RELEASES}" | grep "browser_download_url")

for os_name in ${OS}; do
  for vendor_name in ${VENDOR}; do
    for arch_name in ${ARCH}; do
      for linux_std in ${LINUX_STD}; do
        linux_suffix=""

        if [ "$os_name" = "linux" ]; then
          linux_suffix="-$linux_std"
        fi

        VARIANTS=""

        # variant 1: https://github.com/jqlang/jq/releases
        # variant 1: https://github.com/conventionalcommit/commitlint/releases
        VARIANTS="${os_name}-${arch_name}"
        # variant 2: https://github.com/dprint/dprint/releases
        VARIANTS="${VARIANTS} ${arch_name}-${vendor_name}-${os_name}${linux_suffix}"
        # variant 3: https://github.com/biomejs/biome/releases
        VARIANTS="${VARIANTS} ${os_name}-${arch_name}"
        # variant 4: https://github.com/oxc-project/oxc/releases
        VARIANTS="${VARIANTS} ${os_name}-${arch_name}${linux_suffix}"
        # variant 5: https://github.com/jsona/jsona/releases
        # variant 5: https://github.com/KeisukeYamashita/commitlint-rs/releases
        VARIANTS="${VARIANTS} ${arch_name}-${vendor_name}-${os_name}${linux_suffix}"

        for PLATFORM_VARIANTS in ${VARIANTS}; do
          if [ -n "${binary_version}" ]; then
            VARIANT_WITH_NAMES="${binary_name}-${binary_version}-${PLATFORM_VARIANTS} ${binary_name}-${PLATFORM_VARIANTS}"
          else
            VARIANT_WITH_NAMES="${binary_name}-${PLATFORM_VARIANTS} ${binary_name}-.*-${PLATFORM_VARIANTS}"
          fi

          for NAME_VARIANT in ${VARIANT_WITH_NAMES}; do
            FORMAT_VARIANTS="${NAME_VARIANT} ${NAME_VARIANT}.tar.gz ${NAME_VARIANT}.zip"

            for FORMAT_VARIANT in ${FORMAT_VARIANTS}; do
              TAG_URL=$(echo "${DOWNLOAD_URLS}" | grep "${FORMAT_VARIANT}" | xargs | cut -d ':' -f2,3 | xargs | cut -d ' ' -f1 | xargs)

              if [ -z "${TAG_URL}" ]; then
                continue
              fi

              case "${TAG_URL}" in
              *.tar.gz)
                curl -fsSL "${TAG_URL}" | tar -xzvf - "${binary_name}${BINARY_SUFFIX}"
                ;;
              *.zip)
                curl -fsSL "${TAG_URL}" | funzip - >"${binary_name}${BINARY_SUFFIX}"
                ;;
              *)
                curl -fsSLO "${TAG_URL}"
                ;;
              esac

              if $IS_CHMOD_ALLOWED; then
                chmod 755 "${binary_name}"
              fi

              # break after found
              exit 0

              # end of FORMAT_VARIANT
            done
            # end of NAME_VARIANT
          done
          # end of PLATFORM_VARIANTS
        done

        if [ -z "${linux_suffix}" ]; then
          break
        fi

        # end of `linux_std`
      done
      # end of `arch_name`
    done
    # end of `vendor_name`
  done
  # end of `os_name`
done
