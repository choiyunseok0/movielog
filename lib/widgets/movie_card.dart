import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.imageAspectRatio = 16 / 9,
    this.compact = false,
    this.showRating = false,
    this.ratingOverlay = false,
    this.showMetadata = true,
    this.rank,
  });

  final Movie movie;
  final VoidCallback onTap;
  final double imageAspectRatio;
  final bool compact;
  final bool showRating;
  final bool ratingOverlay;
  final bool showMetadata;
  final int? rank;

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
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: imageAspectRatio,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(compact ? 12 : 16),
                    child: Image.asset(
                      movie.posterAsset,
                      fit: BoxFit.cover,
                      semanticLabel: '${movie.title} 포스터',
                    ),
                  ),
                ),
                if (rank != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        child: Text(
                          '$rank',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (showRating && ratingOverlay)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              movie.averageRating.toStringAsFixed(1),
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: compact ? 8 : 12),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: compact ? textTheme.titleMedium : textTheme.titleLarge,
            ),
            if (showRating && !ratingOverlay) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                  const SizedBox(width: 3),
                  Text(
                    movie.averageRating.toStringAsFixed(1),
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
            if (showMetadata) ...[
              const SizedBox(height: 4),
              Text(
                '${movie.year} · ${movie.genre}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: compact ? 12 : null,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
