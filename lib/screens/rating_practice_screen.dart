import 'package:flutter/material.dart';

import '../widgets/common_app_bar.dart';
import '../widgets/movie_rating_input.dart';

class RatingPracticeScreen extends StatefulWidget {
  const RatingPracticeScreen({super.key});

  @override
  State<RatingPracticeScreen> createState() => _RatingPracticeScreenState();
}

class _RatingPracticeScreenState extends State<RatingPracticeScreen> {
  double _rating = 0;
  double? _savedRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '평점 입력'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '영화는 어떠셨나요?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Center(
                child: MovieRatingInput(
                  rating: _rating,
                  onChanged: (rating) => setState(() => _rating = rating),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _rating == 0
                    ? '별점을 선택해 주세요.'
                    : '선택한 평점: ${_rating.toStringAsFixed(1)}점',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('saveRatingButton'),
                onPressed: _rating > 0
                    ? () => setState(() => _savedRating = _rating)
                    : null,
                child: const Text('평점 저장'),
              ),
              if (_savedRating != null) ...[
                const SizedBox(height: 16),
                Text(
                  '저장한 평점: ${_savedRating!.toStringAsFixed(1)}점',
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
