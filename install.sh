#!/bin/sh
# Install the theme as a local Typst package and as a Claude Code skill.
# Safe to run again; run it after every update. Other installed versions are kept.
# Overrides: TYPST_PACKAGE_PATH, CLAUDE_CONFIG_DIR.
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
version=$(sed -n 's/^version = "\([0-9.]*\)".*/\1/p' "$repo/typst.toml")
[ -n "$version" ] || { echo "No version found in typst.toml" >&2; exit 1; }

case "$(uname -s)" in
  Darwin) data="$HOME/Library/Application Support" ;;
  MINGW*|MSYS*|CYGWIN*) data=$(cygpath -u "$APPDATA") ;;
  *) data="${XDG_DATA_HOME:-$HOME/.local/share}" ;;
esac
packages="${TYPST_PACKAGE_PATH:-$data/typst/packages}"
package="$packages/local/tilework/$version"
skill="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/tilework"

# Build a full copy first, so a failed run leaves the installed version alone.
mkdir -p "$(dirname "$package")" "$skill"
rm -rf "$package.new"
mkdir "$package.new"
cp -R "$repo/typst.toml" "$repo/README.md" "$repo/theme" "$repo/template" "$package.new/"
rm -rf "$package"
mv "$package.new" "$package"

fonts="$package/theme/fonts"
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) fonts=$(cygpath -m "$fonts") ;; esac
escaped=$(printf '%s' "$fonts" | sed 's/[&|\\]/\\&/g')
sed -e "s|{{FONTS}}|$escaped|g" -e "s|{{VERSION}}|$version|g" "$repo/skill/SKILL.md" > "$skill/SKILL.md"

echo "Package: $package"
echo "Skill:   $skill/SKILL.md"
echo "Fonts:   $fonts"
command -v typst >/dev/null 2>&1 || echo "Typst is not on PATH: install 0.15 or newer from https://github.com/typst/typst/releases"
