import 'package:flutter/material.dart';

class GoalCounter extends StatefulWidget {
  GoalCounter({
    super.key,
    required this.completedBookCount,
    required this.goalCount,
    required this.mediaType,
  });

  int completedBookCount;
  int goalCount;
  String mediaType;

  @override
  State<GoalCounter> createState() => _GoalCounter();
}

class _GoalCounter extends State<GoalCounter> {
  late String mediaString;
  // this function calculates how much a user must complete
  // each month to reach their goal at the end of the year
  int calculateGoal(int goal, int completedAmount) {
    double remainingBookAmt =
        (goal - completedAmount) / (12 - DateTime.now().month);
    if (remainingBookAmt.round() == 1) {
      mediaString = widget.mediaType;
    } else {
      mediaString = '${widget.mediaType}s';
    }
    return remainingBookAmt.round().toInt();
  }

  @override
  void initState() {
    setState(() {
      calculateGoal(widget.goalCount, widget.completedBookCount);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              LinearProgressIndicator(
                backgroundColor: const Color.fromARGB(92, 180, 165, 156),
                borderRadius: BorderRadius.circular(25),
                color: Color.fromARGB(255, 151, 189, 63),
                minHeight: 20,
                value: widget.completedBookCount / widget.goalCount,
              ),
              Text(''),
              Text(
                '${widget.completedBookCount}/${widget.goalCount}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24, left: 24, top: 4),
          child: widget.completedBookCount >= widget.goalCount
              ? Text(
                  "You reached your goal!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 107, 73, 54),
                    fontSize: 14,
                  ),
                )
              : Text(
                  'To reach your annual goal, you need to read around ${calculateGoal(widget.goalCount, widget.completedBookCount)} $mediaString per month',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 107, 73, 54),
                    fontSize: 14,
                  ),
                ),
        ),
      ],
    );
  }
}
