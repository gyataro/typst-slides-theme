// Placeholder content throughout.
#import "@local/tilework:0.1.0": *

#show: report.with(
  subtitle: [Project name],
  author: [Xiwen Teoh],
  institution: [National University of Singapore],
  date: datetime(year: 2026, month: 11, day: 23),
)

#title-slide()

== Two of three workstreams need attention

#report-table((1.1fr, .8fr, 1.4fr), ([Workstream], [Status], [Next step]),
  [Analysis], status("good")[On track], [Run full corpus],
  [Harness], status("warn")[At risk], [Fix flaky runs],
  [Disclosure], status("bad")[Blocked], [Await vendor reply],
)

== Done this week

- Finished item, with its outcome
- Finished item, with its outcome
- Finished item, with its outcome

== The length check guards the copy

#graph(read("figures/cfg.dot"))

== Variant B covers more than the baseline

#bar-chart(csv("data/coverage.csv").slice(1), unit: "%", highlight: "Variant B")

#v(1em)
#text(15pt, fill: palette.muted)[Placeholder data. Symbolic execution background: @king1976.]

== Next week

+ First priority
+ Second priority
+ Third priority

== References

#bibliography("refs.bib", title: none)
