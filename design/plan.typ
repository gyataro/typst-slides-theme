// Design plan: page 1 is the system, page 2 the tiles, pages 3-8 are mock slides. All content is placeholder.
#import "@preview/fletcher:0.6.0": diagram, edge, node

#let paper = rgb("#fbfaf7")
#let ink = rgb("#1c1b18")
#let muted = rgb("#5c5850")
#let rule-c = rgb("#e6e2d9")
#let navy = rgb("#17264f")
#let indigo = rgb("#2d3276")
#let blue = rgb("#0060df")
#let sky = rgb("#b5cfe4")
#let wash = rgb("#eaf1f7")
#let gold = rgb("#a9782a")
#let rust = rgb("#a8432f")

#let serif = "Newsreader 16pt"
#set page(width: 800pt, height: 450pt, margin: 0pt, fill: paper)
#set text(font: "Inter", size: 16pt, fill: ink)
#set par(leading: .6em)
#set text(number-type: "lining")

// Tiles come from theme/make_tiles.py; their color tokens are replaced here.
#let tile-img(name, size, dark: indigo, mid: rgb("#7f9fd0"), bg: paper) = {
  let src = read("../theme/tiles/" + name + ".svg")
  for (token, c) in (("#000001", dark), ("#000002", mid), ("#000003", bg)) {
    src = src.replace(token, c.to-hex())
  }
  image(bytes(src), format: "svg", width: size)
}
#let tiles(name, size, ..colors) = tiling(size: (size, size), tile-img(name, size, ..colors))
#let edge-border(w, h, dark: rgb("#8fabd3"), mid: rgb("#b9cbe3")) = rect(width: w, height: h * 98%,
  fill: tiling(size: (h / 12 * 20, h), tile-img("border", h / 12 * 20, dark: dark, mid: mid)))
#let display(size, body, c: ink) = text(font: serif, size: size, weight: 600, fill: c, body)
#let at(x, y, body) = place(top + left, dx: x, dy: y, body)

#let stamp(w, h, body, fill: navy) = box(width: w, height: h, {
  let r = 4pt
  let nx = int(calc.round(w / 13pt))
  let ny = int(calc.round(h / 13pt))
  place(rect(width: w, height: h, fill: rgb("#dbe7f1")))
  for i in range(nx + 1) {
    for y in (0pt, h) { place(dx: w / nx * i - r, dy: y - r, circle(radius: r, fill: paper)) }
  }
  for i in range(ny + 1) {
    for x in (0pt, w) { place(dx: x - r, dy: h / ny * i - r, circle(radius: r, fill: paper)) }
  }
  place(dx: 14pt, dy: 14pt, block(width: w - 28pt, height: h - 28pt, fill: fill, body))
})

#let postmark(c) = box(width: 96pt, height: 96pt, {
  place(circle(radius: 48pt, stroke: 1.6pt + c))
  place(dx: 14pt, dy: 14pt, circle(radius: 34pt, stroke: 1pt + c))
  place(center + horizon, text(13pt, weight: "bold", fill: c)[23 NOV\ 2026])
})

#let slide(title, n, body) = {
  pagebreak()
  at(0pt, 0pt, edge-border(800pt, 9.6pt))
  at(44pt, 34pt, display(28pt, title))
  at(44pt, 92pt, block(width: 712pt, height: 310pt, body))
  at(44pt, 421pt, text(10pt, fill: muted)[Weekly report · W47])
  place(top + right, dx: -44pt, dy: 421pt, text(10pt, fill: muted)[#n])
}

// ---------- 1. System
#at(44pt, 30pt, display(30pt)[Design system])
#at(44pt, 78pt, text(14pt, fill: muted)[Tilework from the website, postage from the moodboard, plain paper for content.])

#let swatch(c, name, use, light: false) = box(width: 108pt, {
  rect(width: 108pt, height: 52pt, fill: c, stroke: if light { .7pt + rule-c })
  v(-8pt)
  text(11pt, weight: "bold", name)
  linebreak()
  text(10pt, fill: muted)[#raw(c.to-hex()) \ #use]
})
#at(44pt, 112pt, grid(columns: 6, gutter: 12.8pt,
  swatch(paper, [Paper], [background], light: true),
  swatch(navy, [Navy], [stamp, sections]),
  swatch(indigo, [Indigo], [tiles, outlines]),
  swatch(blue, [Blue], [links, main series]),
  swatch(sky, [Sky], [fills, baselines]),
  swatch(gold, [Gold], [look here]),
))
#at(44pt, 246pt, grid(columns: (230pt, 222pt, 220pt), gutter: 20pt,
  {
    text(12pt, weight: "bold", fill: indigo)[Type]
    v(0pt)
    display(26pt)[Newsreader]
    linebreak()
    text(16pt)[Inter for text and labels]
    linebreak()
    text(font: "DejaVu Sans Mono", 13pt)[mono for code()]
  },
  {
    text(12pt, weight: "bold", fill: indigo)[Diagram vocabulary]
    v(2pt)
    set text(12pt)
    let key(b, s) = box(width: 44pt, height: 20pt, baseline: 5pt, fill: b, stroke: s, radius: 3pt)
    grid(columns: 2, gutter: 9pt, align: horizon,
      key(wash, 1.2pt + indigo), [component],
      key(paper, (paint: rust, thickness: 1.4pt, dash: "dashed")), [untrusted zone],
      key(rgb("#f7eeda"), 2pt + gold), [this week's focus],
      key(navy, none), [data store],
    )
  },
  {
    text(12pt, weight: "bold", fill: indigo)[Decoration budget]
    v(2pt)
    set text(12pt)
    [Cover: stamp, postmark, tiles\ Section: full tile field\ Content: thin edge border\ Figures: no ornament]
  },
))

// ---------- 2. Tiles
#pagebreak()
#at(44pt, 30pt, display(30pt)[Tile family])
#let panel(name, label, use) = box(width: 224pt, {
  box(width: 224pt, height: 224pt, fill: tiles(name, 112pt))
  v(-4pt)
  text(14pt, weight: "bold", label)
  h(8pt)
  text(13pt, fill: muted, use)
})
#at(44pt, 88pt, grid(columns: 3, gutter: 20pt,
  panel("bloom", [Bloom], [reports]),
  panel("vine", [Vine], [talks]),
  panel("wave", [Wave], [sections]),
))
#at(44pt, 374pt, edge-border(712pt, 24pt))
#at(44pt, 412pt, { text(14pt, weight: "bold")[Border]; h(8pt); text(13pt, fill: muted)[content slides, shown enlarged] })

// ---------- 3. Cover
#pagebreak()
#at(0pt, 0pt, rect(width: 800pt, height: 84pt, fill: tiles("bloom", 84pt, dark: rgb("#b9cbe3"), mid: rgb("#d9e4f0"))))
#at(44pt, 150pt, display(46pt)[Weekly progress])
#at(44pt, 212pt, text(20pt)[Project name])
#at(44pt, 372pt, text(14pt, fill: muted)[Xiwen Teoh\ National University of Singapore])
#at(512pt, 70pt, stamp(226pt, 310pt, {
  place(rect(width: 198pt, height: 198pt, fill: indigo))
  place(tile-img("bloom", 198pt, dark: white, mid: sky, bg: indigo))
  place(bottom + left, dx: 14pt, dy: -26pt, display(40pt, c: paper)[W47])
  place(bottom + right, dx: -14pt, dy: -28pt, text(11pt, fill: sky)[2026])
}))
#at(452pt, 196pt, rotate(-12deg, postmark(gold)))

// ---------- 4. Talk cover
#pagebreak()
#at(0pt, 0pt, rect(width: 800pt, height: 84pt, fill: tiles("vine", 84pt, dark: rgb("#b9cbe3"), mid: rgb("#d9e4f0"))))
#at(44pt, 150pt, block(width: 400pt, display(38pt)[Research talk title]))
#at(44pt, 208pt, text(18pt)[Conference name])
#at(44pt, 372pt, text(14pt, fill: muted)[Xiwen Teoh\ National University of Singapore])
#at(512pt, 70pt, stamp(226pt, 310pt, {
  place(rect(width: 198pt, height: 198pt, fill: indigo))
  place(tile-img("vine", 198pt, dark: white, mid: sky, bg: indigo))
  place(bottom + left, dx: 14pt, dy: -26pt, display(34pt, c: paper)[VENUE])
  place(bottom + right, dx: -14pt, dy: -28pt, text(11pt, fill: sky)[2026])
}))

// ---------- 5. Section
#pagebreak(weak: false)
#at(0pt, 0pt, rect(width: 800pt, height: 450pt, fill: navy))
#at(500pt, 0pt, rect(width: 300pt, height: 450pt, fill: tiles("wave", 100pt, dark: rgb("#6f8fc4"), mid: rgb("#3d5590"), bg: navy)))
#at(44pt, 190pt, display(46pt, c: paper)[Evaluation])

// ---------- 4. Diagram
#slide([The parser is the only path across the boundary], 3, align(center + horizon, diagram(
  spacing: (92pt, 46pt),
  node-stroke: 1.2pt + indigo, node-fill: wash, node-corner-radius: 4pt, node-inset: 12pt,
  edge-stroke: 1.2pt + ink,
  node((0, 0), [Client], name: <c>),
  node((1, 0), [Parser], name: <p>, fill: rgb("#f7eeda"), stroke: 2pt + gold),
  node((2, 0), [Planner], name: <a>),
  node((3, 0), [Executor], name: <e>),
  node((2, 1), text(fill: paper)[Store], name: <s>, fill: navy, stroke: none),
  edge(<c>, <p>, "-|>", text(12pt)[request], label-pos: 60%),
  edge(<p>, <a>, "-|>", text(12pt)[object]),
  edge(<a>, <e>, "-|>", text(12pt)[plan]),
  edge(<a>, <s>, "<|-|>"),
  node(enclose: (<c>,), fill: none, inset: 14pt, stroke: (paint: rust, thickness: 1.4pt, dash: "dashed")),
)))

// ---------- 5. Weekly status
#let status(c, mark, label) = box(baseline: 2pt, grid(columns: 2, gutter: 7pt, align: horizon,
  text(c, 17pt, mark), text(c, weight: "bold", label)))
#slide([Two of three workstreams need attention], 1, {
  table(columns: (1.1fr, .8fr, 1.4fr), align: horizon, inset: (x: 0pt, y: 13pt),
    stroke: (x, y) => (bottom: .8pt + if y == 0 { indigo } else { rule-c }),
    ..([Workstream], [Status], [Next step]).map(h => text(13pt, weight: "bold", fill: indigo, h)),
    [Analysis], status(indigo, sym.circle.filled, [On track]), [Run full corpus],
    [Harness], status(gold, sym.triangle.filled, [At risk]), [Fix flaky runs],
    [Disclosure], status(rust, sym.square.filled, [Blocked]), [Await vendor reply],
  )
})

// ---------- 6. Chart
#slide([Variant B covers more than the baseline], 4, {
  let row(l, v, c) = (l, rect(width: v / 80 * 100%, height: 34pt, fill: c), text(weight: "bold")[#v%])
  grid(columns: (90pt, 1fr, 50pt), row-gutter: 20pt, column-gutter: 14pt, align: horizon,
    ..row([Baseline], 41, sky), ..row([Variant A], 58, sky), ..row([Variant B], 73, blue))
  v(22pt)
  text(13pt, fill: muted)[Placeholder data. One strong color marks the result under discussion.]
})
