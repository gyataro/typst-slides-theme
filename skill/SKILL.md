---
name: tilework
description: Make or edit slide decks (weekly progress reports, research talks, presentations) with the tilework Typst theme. Use when the user asks for slides, a deck, a presentation or a weekly report, or edits a Typst file that imports @local/tilework.
---

# Tilework slides

## Start a deck

Needs Typst 0.15 or newer. For an existing deck, keep the version it imports.

    typst init @local/tilework:{{VERSION}} <dir>

`<dir>` gets `report.typ` and `talk.typ` with sample figures and data. All content is
placeholder: keep the one that fits, delete the other, replace everything in it, and
remove unused sample files. Never invent results, dates or citations; ask for them.

## Build and check

Always pass the font path, or the wrong fonts are used:

    typst compile --font-path "{{FONTS}}" report.typ
    mkdir -p build
    typst compile --font-path "{{FONTS}}" --ppi 110 report.typ "build/{0p}.png"

Look at every changed page. Fix all warnings. Check the page count: overflowing text
usually spills onto an extra page. Then delete `build` and give the user the PDF.

## Deck types

- `#show: report.with(title, subtitle, author, institution, date)`: the stamp shows the date
- `#show: talk.with(title, subtitle, author, institution, venue, date)`: the stamp shows the venue

`date` is a `datetime`. Then `#title-slide()`, `= Section`, `== Slide title`.

## Pieces

- `#graph(read("figures/x.dot"))`: Graphviz, for automatic layout (CFGs, call graphs).
  Prefer `rankdir=LR`. Use palette colors as `"$gold"` in DOT. Split graphs of more than
  about 15 nodes, as labels become too small.
- `#flow(...)`: placed diagrams, from `component`, `store`, `focus`, `zone` and `arrow`;
  `pause` between items reveals them in steps. `talk.typ` has an example.
- `#bar-chart(rows, unit: "%", highlight: "label")`: rows are (label, number) pairs, such as
  `csv("data/x.csv").slice(1)`
- `#code(```c ... ```, highlight: (3,))`: code with highlighted lines
- `#status("good" | "warn" | "bad")[label]` and `#report-table(columns, header, ..cells)`
- `#fit(figure)`: scale any other figure to the slide; `graph` and `flow` already do this
- `#only(1)[...]`, `#pause`: Touying animations

## Design rules

- Titles state the finding, not the topic.
- Keep content slides plain: no ornament beyond the built-in top border.
- Gold marks the focus, dashed rust an untrusted zone, navy a data store.
- In a chart, only the result under discussion is blue.
- Use `palette.<name>`; do not add new colors.
- One idea per slide. Split a slide rather than shrink its text.
