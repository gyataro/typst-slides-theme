// Content pieces: figures, diagrams, charts, code, status.
#import "@preview/touying:0.8.0": touying-reducer
#import "@preview/fletcher:0.5.8" as fletcher: edge, node
#import "@preview/diagraph:0.3.8": raw-render
#import "@preview/codly:2.0.0" as codly
#import "palette.typ": palette

// Center a figure in the space left on the slide, scaled to fit within limits.
#let fit(body, max: 1.4) = block(width: 100%, height: 1fr, align(center + horizon, layout(area => {
  let m = measure(body)
  let k = calc.min(max, area.width / m.width, area.height / m.height)
  scale(k * 100%, reflow: true, body)
})))

// ---- Fletcher diagrams, fitted to the slide. `pause` works between items; this needs 0.5.8, as 0.6.0 lacks `hide`.
#let flow = touying-reducer.with(
  reduce: (..args) => fit(fletcher.diagram(
    spacing: (90pt, 46pt),
    node-stroke: 1.2pt + palette.indigo,
    node-fill: palette.wash,
    node-corner-radius: 4pt,
    node-inset: 12pt,
    edge-stroke: 1.2pt + palette.ink,
    ..args,
  )),
  cover: fletcher.hide,
)
#let component = node
#let focus = node.with(fill: palette.gold-wash, stroke: 2pt + palette.gold)
#let store(pos, body, ..args) = node(pos, text(fill: palette.paper, body),
  fill: palette.navy, stroke: none, ..args)
// Untrusted zone around named nodes: zone(<a>, <b>)
#let zone(..names, inset: 14pt) = node(enclose: names.pos(), inset: inset, fill: none,
  stroke: (paint: palette.rust, thickness: 1.4pt, dash: "dashed"))
#let arrow(from, to, ..args) = {
  let label = args.pos().map(l => if type(l) == content { text(.75em, l) } else { l })
  edge(from, to, "-|>", ..label, ..args.named())
}

// ---- Graphviz, fitted to the slide: graph(read("figures/x.dot")). "$name" in DOT is a palette color.
#let graph(dot, ..args) = {
  let defaults = "bgcolor=transparent; node [shape=box, style=\"rounded,filled\", fontsize=16, fillcolor=\"$wash\", color=\"$indigo\", penwidth=1.2]; edge [fontsize=13, color=\"$ink\", penwidth=1.2];"
  let src = dot.replace("{", "{" + defaults, count: 1)
  // Longest names first, so "$gold-wash" is not read as "$gold".
  for (name, c) in palette.pairs().sorted(key: p => -p.at(0).len()) {
    if type(c) == color { src = src.replace("$" + name, c.to-hex()) }
  }
  fit(raw-render(raw(src, lang: "dot", block: true), math-mode: "text", ..args))
}

// ---- Charts. rows: (label, number) pairs; `highlight` is the label to emphasize.
#let bar-chart(rows, unit: "", highlight: none) = {
  let top = calc.max(..rows.map(r => float(r.at(1))))
  grid(
    columns: (auto, 1fr, auto), row-gutter: 18pt, column-gutter: 14pt, align: horizon,
    ..rows.map(r => (
      r.at(0),
      rect(width: float(r.at(1)) / top * 100%, height: 34pt,
        fill: if r.at(0) == highlight { palette.blue } else { palette.sky }),
      text(weight: "bold")[#r.at(1)#unit],
    )).flatten(),
  )
}

// ---- Code. code(```c ... ```, highlight: (3,)) marks lines in gold.
#let code(body, highlight: ()) = codly.new(body,
  highlighted: highlight.map(n => (n, palette.gold-wash)))

// ---- Status: "good", "warn" or "bad". Shape and label carry it without color.
#let status(kind, label) = {
  let (c, mark) = (
    good: (palette.indigo, sym.circle.filled),
    warn: (palette.gold-text, sym.triangle.filled),
    bad: (palette.rust, sym.square.filled),
  ).at(kind)
  box(grid(columns: 2, gutter: 7pt, align: horizon, text(c, mark), text(c, weight: "bold", label)))
}

// Table with a header row: report-table((1fr, auto), ([A], [B]), [..], [..])
#let report-table(columns, header, ..cells) = table(
  columns: columns, align: horizon, inset: (x: 0pt, y: 13pt),
  stroke: (x, y) => (bottom: .8pt + if y == 0 { palette.indigo } else { palette.rule }),
  table.header(..header.map(h => text(.8em, weight: "bold", fill: palette.indigo, h))),
  ..cells,
)
