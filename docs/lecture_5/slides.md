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
Lecture 5

---

# Agenda

- Top-level design
- Top-level testbench
- Instruction Memory (ICCM)
- Instruction Decode - Stage 0
- Instruction Decode - Stage 1

---

# Top-level design

- Instantiates the following units:
  - ICCM
  - IFU
  - IDU0
  - IDU1


---

# Top-level testbench

- Instantiates the core and the ICCM
- Generates the clock and reset signal
- Applies the reset
- Runs the simulation for a certain number of cycles
- Verilator will run the simulation and check the output

---

# Instruction Memory (ICCM)

- Byte-addressable, word-aligned
- 1024 words (4096 bytes)
- 1CC instruction latency

---

# Instruction Decode - Stage 0

- Gets the instruction from the IFU Stage
- Decodes the instruction by going through the decode tables
- Generates the control signals for the IDU1 and EXU units
- Generates the register file read addresses

---

# Decode Tables

- Custom format to define the instructions and the control signals
- Converted into [Espresso](https://en.wikipedia.org/wiki/Espresso_heuristic_logic_minimizer) Logic Synthesis format
- Run through the Logic Synthesis tool to get the minimized logic and converted to SystemVerilog files

---

# Instruction Decode - Stage 1

- Gets the instruction from the IDU0 Stage
- Gets the data from the register file
- Generates the control signals for the EXU unit




