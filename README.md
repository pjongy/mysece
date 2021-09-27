# mysece

my security environment

## start
```
$ docker run --rm -v "$PWD/project:/home/dev/project" pjongy/mysece:{version}
```

## installed
- gdb-peda
  ```
  $ gdb
  ```
- pwntools (python3)
  ```
  $ python3
  [python3] >>> import pwn
  ```
- volatility (python3)
  ```
  $ volatility --help
  ```
- one_gadget
  ```
  $ one_gadget
  ```
- radare2
  ```
  $ r2
  ```
