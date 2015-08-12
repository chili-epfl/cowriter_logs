Experiment with Diego
=====================


Summary of the task
-------------------

To help one Nao robot the "hand-write" a letter to another robot.

Took place on 14.01.2015, 22.01.2015, 28.01.2015 and 12.02.2015

Content of the logs
-------------------

- `words_demonstrations-*.log`: raw demonstration sent by Diego from the input
  tablet
- `shapes-*.log`: word worked on, name of the demonstrated letter, demonstrations after pre-processing (resampling, normalization), generated letters by the robot.

Parsing of the logs
-------------------

The `shapes-*.log` can be parsed with `log_replay.py`. Tested with
[this commit](https://github.com/chili-epfl/shape_learning/blob/c2a771180d4e9f4038cb4195da4d0ef036fcbb8f/tools/log_replay.py).
