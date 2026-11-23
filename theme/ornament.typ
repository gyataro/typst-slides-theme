// Decoration: tiles, edge border, and stamp.
#import "palette.typ": palette

#let serif = "Newsreader 16pt" // Newsreader's family name inside the font file
#let display(size, body, fill: palette.ink) = text(font: serif, size: size, weight: 600, fill: fill, body)

// SVGs come from make_tiles.py; their color tokens are replaced here.
#let tile(name, width, dark: palette.indigo, mid: palette.tile-mid, bg: palette.paper) = {
  let src = read("tiles/" + name + ".svg")
  for (token, c) in (("#000001", dark), ("#000002", mid), ("#000003", bg)) {
    src = src.replace(token, c.to-hex())
  }
  image(bytes(src), format: "svg", width: width)
}

#let tiles(name, size, ..colors) = tiling(size: (size, size), tile(name, size, ..colors))

#let edge-border(height: 10pt) = {
  let w = height / 12 * 20
  // Slightly under one repeat tall, so the next row's bar never shows.
  rect(width: 100%, height: height * 98%, fill: tiling(size: (w, height),
    tile("border", w, dark: palette.edge.at(0), mid: palette.edge.at(1))))
}

#let cover-band(name, size: 88pt) = rect(width: 100%, height: size,
  fill: tiles(name, size, dark: palette.band.at(0), mid: palette.band.at(1)))

#let stamp(name, value, note) = {
  let (w, h, r, m) = (238pt, 326pt, 4.2pt, 15pt)
  let (nx, ny) = (17, 24)
  let side = w - 2 * m
  box(width: w, height: h, {
    place(rect(width: w, height: h, fill: rgb("#dbe7f1")))
    for i in range(nx + 1) {
      for y in (0pt, h) { place(dx: w / nx * i - r, dy: y - r, circle(radius: r, fill: palette.paper)) }
    }
    for i in range(ny + 1) {
      for x in (0pt, w) { place(dx: x - r, dy: h / ny * i - r, circle(radius: r, fill: palette.paper)) }
    }
    place(dx: m, dy: m, block(width: side, height: h - 2 * m, fill: palette.navy, {
      place(rect(width: side, height: side, fill: palette.indigo))
      place(tile(name, side, dark: white, mid: palette.sky, bg: palette.indigo))
      place(bottom, block(width: side, height: h - 2 * m - side, inset: (x: 15pt), align(horizon, context {
        // Long values shrink to stay on one line beside the year.
        let room = side - 74pt
        let size = calc.min(42pt, 42pt * (room / measure(display(42pt, value)).width))
        grid(columns: (1fr, auto), align: horizon,
          display(size, fill: palette.paper, value), text(11.5pt, fill: palette.sky, note))
      })))
    }))
  })
}
