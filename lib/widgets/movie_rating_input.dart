import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieRatingInput extends StatelessWidget {
  const MovieRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  final double rating;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return KeyedSubtree(
      key: ValueKey(rating),
      child: RatingBar.builder(
        initialRating: rating,
        minRating: 0.5,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 40,
        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
        unratedColor: colors.primaryContainer,
        itemBuilder: (context, index) =>
            Icon(Icons.star_rounded, color: colors.primary),
        onRatingUpdate: onChanged,
      ),
    );
  }
}
