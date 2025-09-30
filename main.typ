#import "@preview/cram-snap:0.2.2": cram-snap, theader

#set page(
  paper: "us-letter",
  flipped: true,
  margin: 0.25in,
)
#set text(font: "Public Sans", size: 10pt)

#show: cram-snap.with()

#v(-3.5em)

#table(
  columns: (1fr, 1fr),
  theader[Kernel Basics],
  [*monolithic*: all in kernel],
  [*microkernel*: user-level servers (context-switch)],
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
    + if interrupt: ISR; if syscall: kernel space
  ],
  table.cell(colspan: 2, [
    *kernel*: bootloader, init hardware, software DS, ISRs
  ])
)

#table(
  theader[Processes],
  [
```c
pid_t p = fork();
int x = 0;
if (p == 0) {
  // child
} else {
  kill(p, SIGTERM);
  waitpid(p, NULL, 0);
}
printf("both");
```
  ],
  [
- ```c waitpid(pid, status, opts)```: status = ```c int*``` for process status; opts = flag bit mask
- ```c x``` has two copies but ```c &x``` has same address in virtual mem
],
  [`exec` replaces calling process with new process; `execl` = list, `execv` = array (path, args; `e` = path, args, env; `p` = args, `$PATH`)],
  [
- `LDPRELOAD` for shims; ```c int (*original_rand)(void) = dlsym(RTLD_NEXT, "rand")```
- `-fPIC`: position-independent code; `-ldl`: link against dynamic linker (loading of `.so` at runtime)
  ]
)
