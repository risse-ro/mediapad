import 'package:flutter/material.dart';

// I shamelessly took this from the assignment
// was going to make my own/alter it but I ran out of time 👼 Hopefully that's ok

class StarRating extends StatelessWidget {
  final int rating;
  final Function(int)? onRatingChanged;
  final double size;
  final bool isFinished;

  const StarRating({
    required this.rating,
    this.onRatingChanged,
    this.size = 24,
    this.isFinished = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Colors.amber;
    final Color inactiveColor = Colors.grey;
    final Color unWatchedColor = Colors.grey.withAlpha(75);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon;
        Color color;

        if (isFinished) {
          icon = index < rating ? Icons.star : Icons.star_border;
          color = index < rating ? activeColor : inactiveColor;
        } else {
          icon = Icons.star;
          color = unWatchedColor;
        }

        return GestureDetector(
          onTap: (onRatingChanged != null && isFinished)
              ? () => onRatingChanged!(index + 1)
              : null,
          child: Icon(icon, color: color, size: size),
        );
      }),
    );
  }
}
