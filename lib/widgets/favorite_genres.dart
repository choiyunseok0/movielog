import 'package:flutter/material.dart';

class FavoriteGenres extends StatelessWidget {
  const FavoriteGenres({super.key});

  static const genres = ['드라마', 'SF', '애니메이션'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '선호하는 장르',
          style: textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genres.map((genre) {
            return Chip(
              label: Text(genre),
              labelStyle: textTheme.bodyMedium?.copyWith(
                color: colors.onPrimaryContainer,
              ),
              backgroundColor: colors.primaryContainer,
              side: BorderSide.none,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}
