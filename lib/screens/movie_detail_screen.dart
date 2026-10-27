import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/mock_movies.dart';
import '../widgets/rating_dialog.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final int movieId;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;
  double? _myRating;

  Future<void> _openRatingDialog() async {
    final rating = await showDialog<double>(
      context: context,
      builder: (context) => RatingDialog(initialRating: _myRating ?? 0),
    );

    if (!mounted || rating == null) return;

    setState(() {
      _myRating = rating;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${rating.toStringAsFixed(1)}점 평점을 남겼습니다.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? '즐겨찾기에 추가했습니다.' : '즐겨찾기에서 삭제했습니다.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = findMovieById(widget.movieId);

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('영화 정보를 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cinema Archive',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: '공유',
            icon: SvgPicture.asset(
              'assets/icons/share.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: _DetailActionBar(
        isFavorite: _isFavorite,
        hasRating: _myRating != null,
        onFavoritePressed: _toggleFavorite,
        onRatingPressed: _openRatingDialog,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          AspectRatio(
            aspectRatio: 1.05,
            child: Image.asset(
              movie.posterAsset,
              fit: BoxFit.cover,
              semanticLabel: '${movie.title} 포스터',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${movie.year} · ${movie.genre} · ${movie.durationMinutes}분',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: movie.averageRating,
                      itemCount: 5,
                      itemSize: 22,
                      unratedColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      movie.averageRating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(1,245)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: movie.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          side: BorderSide.none,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 20),
                Text('시놉시스', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  movie.synopsis,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(height: 1.65),
                ),
                if (_myRating != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    '내 평점 ${_myRating!.toStringAsFixed(1)}점',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailActionBar extends StatelessWidget {
  const _DetailActionBar({
    required this.isFavorite,
    required this.hasRating,
    required this.onFavoritePressed,
    required this.onRatingPressed,
  });

  final bool isFavorite;
  final bool hasRating;
  final VoidCallback onFavoritePressed;
  final VoidCallback onRatingPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: isFavorite ? '즐겨찾기 삭제' : '즐겨찾기 추가',
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: onFavoritePressed,
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                      ),
                      icon: Icon(
                        isFavorite
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                      ),
                      label: const Text('즐겨찾기'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: onRatingPressed,
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                    icon: const Icon(Icons.rate_review_outlined),
                    label: Text(hasRating ? '다시 선택하기' : '평점 남기기'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
