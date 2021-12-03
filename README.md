# iterations-leak

Results:

```
   3,836,443,504 bytes allocated in the heap
   1,819,820,720 bytes copied during GC
     524,932,280 bytes maximum residency (4 sample(s))
       5,196,616 bytes maximum slop
            1124 MiB total memory in use (0 MB lost due to fragmentation)

                                     Tot time (elapsed)  Avg pause  Max pause
  Gen  0        26 colls,    26 par    1.487s   0.744s     0.0286s    0.0683s
  Gen  1         4 colls,     3 par    1.657s   0.850s     0.2125s    0.4907s

  Parallel GC work balance: 0.01% (serial 0%, perfect 100%)

  TASKS: 6 (1 bound, 5 peak workers (5 total), using -N2)

  SPARKS: 0 (0 converted, 0 overflowed, 0 dud, 0 GC'd, 0 fizzled)

  INIT    time    0.001s  (  0.001s elapsed)
  MUT     time    0.704s  (  0.699s elapsed)
  GC      time    3.145s  (  1.594s elapsed)
  EXIT    time    0.008s  (  0.006s elapsed)
  Total   time    3.857s  (  2.300s elapsed)

  Alloc rate    5,451,749,197 bytes per MUT second

  Productivity  18.2% of total user, 30.4% of total elapsed
```
