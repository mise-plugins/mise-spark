#!/usr/bin/env bash

set -euo pipefail

TOOL_NAME="spark"
TOOL_TEST="spark-shell --version"

CURRENT_DOWNLOADS_URL="https://downloads.apache.org/spark/"
ARCHIVE_URL="https://archive.apache.org/dist/spark/"

fail() {
	echo -e "mise-$TOOL_NAME: $*"
	exit 1
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_versions() {
	local url="$1"
	curl -s "$url" |
		grep -o "spark-.*" |
		cut -d '/' -f1 |
		xargs -I{} curl -s "${url}{}/" |
		grep -o ">spark-.*\.tgz</a" |
		sed 's/>spark-//' |
		sed 's/\.tgz<\/a//'
}

download_release() {
	local version filename base_version url
	version="$1"
	filename="$2"

  base_version=$(echo "$version" | cut -d'-' -f1)

	url="${ARCHIVE_URL}spark-${base_version}/spark-${version}.tgz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl -fsSL -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "mise-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert spark-shell executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
