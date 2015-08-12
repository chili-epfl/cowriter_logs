Experiment in Normandie
=======================


Summary of the task
-------------------

Children teaching hand-writing to a Nao robot Over 2 weeks of experiments.

Took place from 21/07/2015 to 30/07/2015.

Content of the logs
-------------------

`robot_progress` : progression of the robot over all session for each child
( each time the robot progress to middle point in between last state and child demonstration, so this set is sufficient to reconstruct children progression : demo = robot-state-1 + 2`*`(robot-state-2 - robot-state-1) )

`all_logs` : all the events from cowriter's node `learning_word_nao` for each
child

Parsing of the logs
-------------------

Those log can be parsed and analysed with `log_analysis.py`. Tested with
[this commit](https://github.com/chili-epfl/allograph/blob/master/tools/log_analysis.py).
