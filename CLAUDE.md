# Agent instructions

## Project information

### Project host machine

Ubuntu-based computer belonging to and having access to a physical robot to execute tasks on and monitor it, usually powered from the robot battery.

## Code generation

- avoid code duplication
- generate easy-to-follow, human-readeable code
- use self-explaining variable, function and macro names

## Comments and docstrings

Code is the single source of truth for *what* happens. Comments and docstrings must not restate it,
because they are not updated when someone changes the code by hand and then become wrong.

- Write only what the code cannot say: purpose, motivation, context, constraints, trade-offs, and
  why a non-obvious choice was made (e.g. "keys rotate, so the result is stored at ingest").
- Do not describe the code's implicit logic: no lists of the rules, checks, steps,
  branches, return values, field names, settings or call order of the function/class/module
  (e.g. never "Rules executed here: 1) ... 2) ...").
- Prefer a short inline comment right next to the relevant code, instead of a big docstring at the start of the file. The global docstring shall contain only the big picture.
- Behaviour documentation for humans belongs in the readme files, not in code comments.

## Keep related documents up-to-date

- Keep readme files up-to-date.

## Tests

- Do not implement tests if there are no tests already in the repo, only if explicitely asked.
- Create only minimal amount of tests to target mainly inter-module integration breaks and feature degradations.
- Where available, prefer and suggest tests based on real-world data or measurement.

## Other instructions

- If you run tests, read `tests/README.md` first.
- Read `CLAUDE.local.md` as well, if it exists.
