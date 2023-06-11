import 'package:flutter/material.dart';

typedef void ScoreChangeCallback(double score);

class RatingView extends StatelessWidget {
  final int starCount;
  final double score;
  final ScoreChangeCallback onScoreChanged;

  RatingView({
    this.starCount = 5,
    this.score = 0.0,
    this.onScoreChanged,
  });

  _buildStar(BuildContext context, int index) {
    Icon icon;

    if (index >= score) {
      icon = Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > score - 1 && index < score) {
      icon = Icon(
        Icons.star_half,
        color: Theme.of(context).primaryColor,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: Theme.of(context).primaryColor,
      );
    }
    return InkResponse( onTap: onScoreChanged == null ? null : () => onScoreChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(starCount, (index) => _buildStar(context, index)),
    );
  }
}
