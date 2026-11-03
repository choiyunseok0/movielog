import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/rating_with_movie.dart';
import '../view_models/my_ratings_view_model.dart';
import '../widgets/movie_poster.dart';

class MyRatingsScreen extends StatelessWidget {
  const MyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyRatingsViewModel>();
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('내가 등록한 평점')),
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
          MyRatingsLoadStatus.success => ListView.builder(
            padding: const EdgeInsets.all(16),
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
    final date = MaterialLocalizations.of(context)
        .formatCompactDate(rating.createdAt.toLocal());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              height: 96,
              child: MoviePoster(url: entry.movie?.posterUrl, title: title),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text('★ ${rating.score}점'),
                  Text(date),
                  if (rating.comment case final comment?
                      when comment.isNotEmpty)
                    Text(comment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
