# iterations-leak

```haskell
main :: IO ()
main = do
  task <- getSomeTask 10000000
  let run = runTask task
  runTask task `onException` printTaskName task
```

results in

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

```haskell
main :: IO ()
main = do
  task <- getSomeTask 10000000
  let run = runTask task
  run *> run
```

results in

```
   6,234,180,464 bytes allocated in the heap
   2,813,201,368 bytes copied during GC
     968,126,072 bytes maximum residency (5 sample(s))
       9,564,552 bytes maximum slop
            2095 MiB total memory in use (0 MB lost due to fragmentation)

                                     Tot time (elapsed)  Avg pause  Max pause
  Gen  0        44 colls,    44 par    1.524s   0.762s     0.0173s    0.0645s
  Gen  1         5 colls,     4 par    3.663s   1.863s     0.3725s    0.9561s

  Parallel GC work balance: 0.01% (serial 0%, perfect 100%)

  TASKS: 6 (1 bound, 5 peak workers (5 total), using -N2)

  SPARKS: 0 (0 converted, 0 overflowed, 0 dud, 0 GC'd, 0 fizzled)

  INIT    time    0.001s  (  0.001s elapsed)
  MUT     time    1.267s  (  1.257s elapsed)
  GC      time    5.187s  (  2.625s elapsed)
  EXIT    time    0.001s  (  0.006s elapsed)
  Total   time    6.457s  (  3.890s elapsed)

  Alloc rate    4,919,342,994 bytes per MUT second

  Productivity  19.6% of total user, 32.3% of total elapsed
```

When compiled `getSomeIterations` is worker-wrapper-transformed and the worker looks like this:

```
Rec {
-- RHS size: {terms: 30, types: 53, coercions: 7, joins: 0/2}
$wgetSomeIterations
  = \ @ m_s25P ww_s261 ww1_s26k ww2_s26o ->
      case ww2_s26o of ds_X1OJ {
        __DEFAULT ->
          let { lvl8_s22M = ww1_s26k (lvl7_r2cg `cast` <Co:7>) } in
          let {
            lvl9_s22N
              = $wgetSomeIterations ww_s261 ww1_s26k (-# ds_X1OJ 1#) } in
          ww_s261
            (Next
               ()
               (\ b_avB ->
                  case b_avB of {
                    False -> lvl8_s22M;
                    True -> lvl9_s22N
                  }));
        0# -> ww_s261 lvl3_r2cc
      }
end Rec }
```

Note how the recursive call has floated outside of the `Next` constructor.

Based on [Sharing, Space Leaks, and Conduit and friends](https://www.well-typed.com/blog/2016/09/sharing-conduit).
