// Single entry point: decks import only this file.
#import "@preview/touying:0.8.0": *
#import "@preview/codly:2.0.0" as codly
#import "palette.typ": palette
#import "ornament.typ": *
#import "components.typ": *

#let gutter = 46pt

#let slide(title: auto, ..args) = touying-slide-wrapper(self => {
  let header = pad(x: gutter, top: 36pt, align(top, display(29pt,
    if title == auto { utils.display-current-heading(level: 2) } else { title })))
  let footer = pad(x: gutter, bottom: 18pt, align(bottom, {
    set text(10.5pt, fill: palette.muted)
    grid(columns: (1fr, auto), self.store.footer,
      context utils.slide-counter.display() + " / " + utils.last-slide-number)
  }))
  touying-slide(self: utils.merge-dicts(self, config-page(
    header: header, footer: footer, background: align(top, edge-border()))), ..args)
})

#let title-slide() = touying-slide-wrapper(self => {
  let s = self.store
  let background = {
    place(top, cover-band(s.tile))
    place(top + right, dx: -62pt, dy: 74pt, stamp(s.tile, s.value, s.date.display("[year]")))
  }
  touying-slide(
    self: utils.merge-dicts(self,
      config-common(freeze-slide-counter: true),
      config-page(background: background, header: none, footer: none,
        margin: (left: gutter, right: 330pt, top: 120pt, bottom: 40pt))),
    {
      set par(leading: .4em, spacing: 10pt)
      v(1fr)
      display(s.title-size, self.info.title)
      v(14pt)
      text(20pt, self.info.subtitle)
      v(1.4fr)
      text(15pt, fill: palette.muted)[#self.info.author \ #self.info.institution]
    },
  )
})

#let section-slide(body) = touying-slide-wrapper(self => {
  let background = {
    place(rect(width: 100%, height: 100%, fill: palette.navy))
    place(top + right, rect(width: 316pt, height: 100%, fill: tiles("wave", 105.2pt,
      dark: palette.night.at(0), mid: palette.night.at(1), bg: palette.navy)))
  }
  touying-slide(
    self: utils.merge-dicts(self,
      config-common(freeze-slide-counter: true),
      config-page(background: background, header: none, footer: none,
        margin: (left: gutter, right: 340pt, y: 40pt))),
    align(horizon, display(46pt, fill: palette.paper, utils.display-current-heading(level: 1))),
  )
})

#let base(title: none, subtitle: none, author: none,
  institution: none, date: none, value: none, tile: none,
  title-size: 40pt, footer: none, body) = {
  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio("16-9"),
      fill: palette.paper,
      margin: (x: gutter, top: 96pt, bottom: 44pt),
      header-ascent: 0pt, footer-descent: 0pt,
    ),
    config-common(slide-fn: slide, new-section-slide-fn: section-slide,
      zero-margin-header: true, zero-margin-footer: true),
    config-methods(init: (self: none, body) => {
      set text(font: "Inter", size: 19pt, fill: palette.ink, number-type: "lining")
      set par(leading: .65em)
      set list(marker: text(palette.tile-mid, sym.bullet), spacing: .9em)
      set enum(spacing: .9em)
      show link: set text(fill: palette.blue)
      show raw: set text(font: "DejaVu Sans Mono")
      show raw.where(block: true): set text(16pt)
      show: codly.line-set_(fill: palette.wash, stroke: none)
      show raw.where(block: true): codly.new
      body
    }),
    config-colors(primary: palette.indigo),
    config-info(title: title, subtitle: subtitle, author: author, institution: institution),
    config-store(date: date, value: value, tile: tile, title-size: title-size, footer: footer),
  )
  body
}

// Weekly report: the stamp shows `date`.
#let report(title: [Weekly progress], subtitle: none, date: none, ..args, body) = {
  let day = date.display("[day padding:none] [month repr:short]")
  base(title: title, subtitle: subtitle, date: date, value: day, tile: "bloom", title-size: 48pt,
    footer: [#title · #day #date.year()], ..args, body)
}

// Talk: the stamp shows the venue.
#let talk(title: none, subtitle: none, venue: none, date: none, ..args, body) = base(
  title: title, subtitle: subtitle, date: date, value: venue, tile: "vine",
  footer: [#title · #venue #date.year()], ..args, body)
