import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/rating_with_movie.dart';
import '../view_models/my_ratings_view_model.dart';
import '../theme/app_colors.dart';

class MyRatingsScreen extends StatelessWidget {
  const MyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyRatingsViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: AppColors.onSurface,
        title: const Text(
          '내가 등록한 평점',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: switch (vm.status) {
          MyRatingsLoadStatus.idle || MyRatingsLoadStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          MyRatingsLoadStatus.empty => const Center(
            child: Text('등록한 평점이 없어요.'),
          ),
          MyRatingsLoadStatus.error => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(vm.message ?? '', textAlign: TextAlign.center),
                  TextButton(onPressed: vm.load, child: const Text('다시 시도')),
                ],
              ),
            ),
          ),
          MyRatingsLoadStatus.success => ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemCount: vm.ratings.length,
            itemBuilder: (context, index) =>
                _RatingCard(entry: vm.ratings[index]),
          ),
        },
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.entry});

  final RatingWithMovie entry;

  @override
  Widget build(BuildContext context) {
    final rating = entry.rating;
    final title = entry.movie?.title ?? '영화 #${rating.movieId}';
    final posterUrl = entry.movie?.posterUrl;
    final comment = rating.comment;
    const placeholder = ColoredBox(color: AppColors.outlineVariant);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.outlineVariant, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: posterUrl == null || posterUrl.isEmpty
                    ? placeholder
                    : Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        semanticLabel: '$title 포스터',
                        errorBuilder: (_, _, _) => placeholder,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '별점 ${rating.score} / 5',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (comment != null && comment.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      comment,
                      style: const TextStyle(color: AppColors.outline),
                    ),
                  ],
                  if (posterUrl == null || posterUrl.isEmpty) ...[
                    const SizedBox(height: 10),
                    const Text(
                      '포스터 정보 없음',
                      style: TextStyle(color: AppColors.outline),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
