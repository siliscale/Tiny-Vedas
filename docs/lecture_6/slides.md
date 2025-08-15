---
marp: true
theme: default
paginate: true
emoji: true
style: |
  section {
    background-color: #1a1a1a;
    color: #ffffff;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  }
  h1, h2 {
    color: #4a9eff;
  }
  a {
    color: #66b3ff;
  }
  code {
    background-color: #2d2d2d;
  }
  blockquote {
    border-top: 0.1em dashed #555;
    font-size: 60%;
    margin-top: auto;
    margin-bottom: 0;
  }
  * {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  }
  img[alt~="center"] {
  display: block;
  margin: 0 auto;
  margin-top: 2em;
  }
math: mathjax
---

# RISC-V Processor Design 🚀

## Building Tiny Vedas

Marco Spaziani Brunella, PhD
Lecture 6

---

# Agenda

- Instruction Execute
- Compiling a program
- Instruction Set Simulator (ISS)
- Simulation Manager
- Bug Fixing

---

# Instruction Execute

- For now, just ALU
- 1 clock cycle delay
- Then straight to the register file

---

# Compiling a program for RISC-V

- We'll use GNU RISC-V toolchain
- There's also LLVM toolchain, but we'll stick to GNU


---

# Instruction Set Simulator (ISS)

- To my surprise, the only hardware-ready, open-source ISS got deprecated
- So I had to build a custom one (not open-source, might sell it in the future)
- Executable is in the `tools` folder

---

# Putting it all together --> Simulation Manager

![width:280px center](./figs/fig1.png)


---

# What's next?

- Running regression tests
   - Smoke test list that runs at each commit
   - Ideally, set-up a CI/CD pipeline
   - Plan to do a bonus lecture about it

