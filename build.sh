#!/usr/bin/env bash

set -e

python-appimage build app -p 3.10 -l manylinux2014_x86_64 ./appimage

# Run twice - conan reports lots of info on the first run
./conan-appimage-x86_64.AppImage --version
version_string=$(./conan-appimage-x86_64.AppImage --version)
version_string=${version_string#Conan version }

mv conan-appimage-x86_64.AppImage conan-${version_string}-x86_64.AppImage

function gh_export()
{
    [[ "${GITHUB_ENV-}" ]] || local -r GITHUB_ENV="/dev/null"
    export -- "$@" && printf "%s\n" "$@" >> "${GITHUB_ENV}"
}

gh_export CONAN_VERSION="${version_string}"
