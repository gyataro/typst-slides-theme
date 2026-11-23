# Tilework

Typst theme for weekly reports and research talks, usable from any folder.

## Install

Needs [Typst](https://github.com/typst/typst/releases) 0.15 or newer, and a POSIX shell
(Git Bash on Windows).

```bash
git clone https://github.com/gyataro/typst-slides-theme.git
```

```bash
sh typst-slides-theme/install.sh
```

This copies the theme into Typst's local packages and installs a Claude Code skill. It
prints the font path to use below. Run it again after `git pull` or any theme edit.

## Use

```bash
typst init @local/tilework:0.1.0 my-slides
```

```bash
typst watch --font-path "<font path>" my-slides/report.typ
```

The new folder has `report.typ` and `talk.typ`; keep the one you need.

For coding agents that do not read Claude skills, point the project's `AGENTS.md` at the
installed `SKILL.md`.

## Offline machines

Typst downloads Touying, Fletcher, Diagraph and Codly on first use. For a machine without
internet, build both templates on a connected one and copy its Typst package cache
(`~/.cache/typst/packages` on Linux).

## License

The theme is under the MIT License. Newsreader and Inter are bundled in `theme/fonts` under the SIL Open Font License.
