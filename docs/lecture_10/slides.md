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
Lecture 10

---

# Agenda

- Branches
- Pipeline Flushing
- Branch Penalty

---

# Branches

- Instructions used to implement conditional code execution: if, else, while, for, etc.
- Branches can be unconditional or conditional


---

# Unconditional Branches in RISC-V

- JAL and JALR operation, they involve also a reg file side effect generation
   - JAL -> pc += sext(offset), rd = pc + 4
   - JALR -> rd = pc + 4, pc = rs1 + sext(offset)

![center](./figs/fig1.png)

---

# Conditional Branches in RISC-V

- BEQ, BNE, BLT, BGE, BLTU, BGEU
- All of them follow the same pattern:
  - pc += sext(offset) if cond is true
  - pc += 4 if cond is false


![center](./figs/fig2.png)

---

# Implementing Branching in the Pipeline

- We fetch instructions sequentially by default --> Assume the branch is never taken
- Whenever we change the pc, it means that the instructions we fetched are now invalid
- We need to flush the pipeline: get rid of the instructions we fetched and get new ones

---

# Branch Penalty

- Once we take a branch and flush the pipeline, we need to wait for the pipeline to be filled again
- We thus incur a penalty in taking a branch, as every time we take a branch we need to fill again the pipeline
- The branch penalty, measured in clock cycles, is the same as the pipeline stages

---

# Improvements (not covered in this course) 

- Branch preditcion: Based on how many times a branch has been taken in the past, we can predict if it will be taken or not
- Different ways of doing this, with a varying grade of complexity and prediction performance:
  - 2-bit branch preditctor
  - TAGE predictor


