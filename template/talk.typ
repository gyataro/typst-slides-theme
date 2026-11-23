// Placeholder content throughout.
#import "@local/tilework:0.1.0": *

#show: talk.with(
  title: [A longer research talk title that wraps],
  subtitle: [Conference name],
  venue: [VENUE],
  author: [Xiwen Teoh],
  institution: [National University of Singapore],
  date: datetime(year: 2026, month: 11, day: 23),
)

#title-slide()

= Approach

== The parser is the only path across the boundary

#flow(
  component((0, 0), [Client], name: <client>),
  zone(<client>),
  focus((1, 0), [Parser], name: <parser>),
  arrow(<client>, <parser>, [request], label-pos: 60%),
  pause,
  component((2, 0), [Planner], name: <planner>),
  arrow(<parser>, <planner>, [object]),
  pause,
  component((3, 0), [Executor], name: <executor>),
  store((2, 1), [Store], name: <store>),
  arrow(<planner>, <executor>, [plan]),
  arrow(<planner>, <store>),
)

== A dense control flow graph still fits

#graph(read("figures/dense.dot"))

== The patch bounds the length before the copy

#only(1)[
  #code(```c
  uint8_t buf[64];
  size_t len = read_u16(pkt);
  memcpy(buf, pkt->data, len);
  ```, highlight: (3,))

  #status("bad")[Vulnerable] #h(6pt) Length comes from the packet and is never checked.
]
#only(2)[
  #code(```c
  uint8_t buf[64];
  size_t len = read_u16(pkt);
  if (len > sizeof(buf)) return -1;
  memcpy(buf, pkt->data, len);
  ```, highlight: (3,))

  #status("good")[Patched] #h(6pt) Length is bounded before the copy.
]
