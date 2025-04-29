# Introduction 

This is the main repository for the free [RISC-V Processor Design Course](https://www.youtube.com/playlist?list=PLRDeZtyULZWgMGOpZxxIhsRzCFyqhQ_U8) available on Youtube.

Here, you will find all the slides, notes, and code for the course.

The goal of this course is to design a RISC-V RV32IM processor from scratch, that we'll call Tiny Vedas, to run [CoreMark](https://github.com/eembc/coremark), a standard benchmark for microcontrollers.

## Course Outline

The course is divided into main + bonus lectures.

**Main Lectures**
- [Lecture 1 - Intro & Setting up the Dev Environment](docs/lecture_1/slides.pdf)
- [Lecture 2 - Combinatorial Logic & Arithmetic and Logic Unit](docs/lecture_2/slides.pdf)
- [Lecture 3 - Multiplexers & Sequential Logic](docs/lecture_3/slides.pdf)
- [Lecture 4 - RISC-V RV32IM ISA, Tiny Vedas Architecture, and the IFU](docs/lecture_4/slides.pdf)
- [Lecture 5 - Design Top Level, Top Level Testbench, Instruction Decode](docs/lecture_5/slides.pdf)
- [Lecture 6 - EXU, Toolchain and Co-Simulation](docs/lecture_6/slides.pdf)
- [Lecture 7 - Data Hazards, Lane forwarding](docs/lecture_7/slides.pdf)
- [Lecture 8 - Pipeline Stalls, Multiplier and Divider](docs/lecture_8/slides.pdf)
- [Lecture 9 - Aligned and Unaligned memory access, Load/Store Unit](docs/lecture_9/slides.pdf)
- [Lecture 10 - Handling Branches, Control Hazards and Pipeline Flushes](docs/lecture_10/slides.pdf)
- [Lecture 11 - Running CoreMark, Conclusion](docs/lecture_11/slides.pdf)

**Bonus Lectures**
- Lecture B1 - Deploying Tiny Vedas to Arty Z7-20 FPGA
- Lecture B2 - Building a Chip: Tiny Vedas on 7nm with OpenRoad and ASAP7

Bonus lectures are only available to my [Patrons](https://patreon.com/riscv_mastery_course_0/membership?utm_medium=unknown&utm_source=join_link&utm_campaign=gitlab_codebase&utm_content=copyLink).

# What computer do I need?

All the course is designed to run on the latest LTS of Ubuntu. You can get it [here](https://ubuntu.com/download/desktop).

Anything built after the last decade should be more than enough to run the course.

# Cloning this repo

In order to run the examples for each lecture, you need to clone this repo. Make sure to [add an SSH Key to your gitlab account](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-to-configure-GitLab-SSH-keys-for-secure-Git-connections).

After that, you can clone the repo using the following command:

```bash
git clone git@gitlab.rv-mastery.com:risc-v-mastery/tiny-vedas.git
```

# Running the examples

Each lecture has its own folder. Inside each folder, you will find a `slides.md` file that contains the slides for the lecture, and a `Makefile` that will run the examples.

Before running the examples, make sure you have [installed the dependencies](docs/lecture_1/notes.md).

To run the examples, simply navigate to the lecture's `code` folder and run the `make` command.

```bash
cd docs/lecture_{N}/code
make
```

# Need Support?

I don't reply to inquiries about the course via email since it has 10K+ views. If you need support, consider becoming a [Patron](https://patreon.com/riscv_mastery_course_0/membership?utm_medium=unknown&utm_source=join_link&utm_campaign=gitlab_codebase&utm_content=copyLink). There, I have a dedicated support team specifically for this course.

# Need a certificate of completion?

I'm working on setting up a platform for final examination and certification. This will be a paid service, opportunely discounted for my patrons. I think this will be extremely helpful in getting past all the AI screening of resumes that employers are doing these days.

# Need Mentorship for your career/projects?

I'm opening up a few limited spots for mentorship. If you're interested, apply by sending an email to [mentorship@rv-mastery.com](mailto:mentorship@rv-mastery.com) with your background, what you're trying to accomplish and what timeline do you have in mind.






