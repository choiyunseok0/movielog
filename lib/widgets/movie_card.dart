import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${movie.title} 상세 보기',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  movie.posterAsset,
                  fit: BoxFit.cover,
                  semanticLabel: '${movie.title} 포스터',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(movie.title, style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${movie.genre} · ${movie.year}',
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
