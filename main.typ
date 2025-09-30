#import "@preview/cram-snap:0.2.2": cram-snap, theader

#set page(
  paper: "us-letter",
  flipped: true,
  margin: 1cm,
)
#set text(font: "Public Sans", size: 11pt)

#show: cram-snap.with(
  title: [Git Cheatsheet],
)

#table(
  columns: (1fr),
  theader(colspan: 1)[Kernel Basics],
  [monolithic: all in kernel],
  [microkernel: user-level servers (context-switch = slower)],
)
