#import "@preview/cram-snap:0.2.2": cram-snap, theader

#set page(
  paper: "us-letter",
  flipped: true,
  margin: 1cm,
)
#set text(font: "Public Sans", size: 11pt)

#show: cram-snap.with(
  title: [CPSC3220 Exam 1],
)

#table(
  columns: (1fr, 1fr),
  theader[Kernel Basics],
  [*monolithic*: all in kernel],
  [*microkernel*: user-level servers (context-switch = slower)],
  [
    kernel to user:
    + save registers/mem state
    + load process state/mem
    + jump & switch modes
  ],
  [
    user to kernel (*trap*):
    + save processor state
    + load kernel state
    + if interrupt, go to ISR; if syscall, go to kernel space
  ],
  table.cell(colspan: 2, [
    *kernel*: bootloader, init hardware, software DS, ISRs
  ])
)
