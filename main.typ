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
    - *kernel*: bootloader, init hardware, software DS, ISRs
    - OS: user $->$ kernel $->$ HAL $->$ hardware
      - HAL: abstracts device specific code (interrupts, hardware timers)
      - dyn. installed device drivers: software added to kernel after running
  ])
)

#table(
  columns: (1fr, 1fr),
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
  ],
  [
  - ```c ptrace(PTRACE_TRACEME)``` in child
  - ```c ptrace(PTRACE_SETOPTIONS, child, 0, PTRACE_O_TRACESYSGOOD)```
  - ```c ptrace(PTRACE_SYSCALL, child, 0, 0)```
  - ```c ptrace(PTRACE_GET_SYSCALL_INFO, child, sizeof(struct ptrace_syscall_info), &psi)```
  - ```c ptrace(PTRACE_CONT, child, 0, 0)```
  ],
  [
  *zombie*: dead child process marked as defunct (but accessible)
```c
if (fork() == 0) {
  return 0;
} else  {
  // needs wait to prevent zombie
  wait(NULL);
  sleep(5);
}
```
  ],
)

#table(
  columns: (1.35fr, 1fr),
  theader[IPC],
  table.cell(colspan: 2, [
    - *types*: producer-consumer (1-way), client-server (2-way), FS (async)
  ]),
  [
    - shared memory: ```c char* shared_block = (char*)mmap(NULL, BLOCKSIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_SHARED, -1, 0)```
    - signals: ```c signal(SIGSEGV, handle_seg_fault)```
    - pipe (named/unnamed)
```c
// sender
if ((fp = fopen(FIFO_FILE, "w")) == NULL) { exit(1); }
fputs(argv[1], fp);
fclose(fp);
// receiver: create if doesn't exist
mkfifo(FIFO_FILE, 0666);
while (1) {
    fp = fopen(FIFO_FILE, "r");
    fget(readbuf, 80, fp);
    printf("received string: %s\n", readbuf);
    fclose(fp); }
```
]
  , [
    - message passing (mailbox):
```c 
// client
int msqidC = msgget((MAILBOX_NUMBER + 1), 0600 | IPC_CREAT);
msgp.mtype = 1;
strncpy(msgp.txt, "hi", sizeof(msgp.txt)-1);
msgsnd(msqidS, &msgp, sizeof(msgp) - sizeof(long), 0);
// server
int msqidS = msgget(MAILBOX_NUMBER, 0600 | IPC_CREAT);
result = msgrcv(msqidS, &cmbox, sizeof(msgp)-sizeof(long), 1, 0);
```
    - files, sockets, RPC
  ],
)
