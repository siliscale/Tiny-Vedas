# Notes for Lecture 5

## Installing Verible

Get the latest pre-compiled version of Verible from your platfrom [here](https://github.com/google/verible/releases).

Un-archive where you like and export it to your PATH.

```bash
$ tar -xvf verible-<version>-Linux-x86_64.tar.gz
$ export PATH="$PATH:<path-to-verible>/bin"
```

## Installing Espresso

Espresso is from the 80s, so the original version is hard to find, but there's a modern version [here](https://github.com/nelsonjchen/espresso-logic-minimizer.git).

```bash
git clone https://github.com/classabbyamp/espresso-logic.git
cd espresso-src
make
export PATH=$PATH:<../bin-folder>
```

You can now run the Decode Generation script from this repository.
