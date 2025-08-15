# Notes for Lecture 1

## Installing Verilator

```bash
$ sudo apt install help2man autoconf bison flex build-essential

$ git clone https://github.com/verilator/verilator
$ cd verilator
$ git checkout <latest-tag>

$ autoconf
$ ./configure
$ make -j$(nproc)
$ sudo make install
```

## Installing GTKWave

```bash
$ sudo apt install gtkwave
```

