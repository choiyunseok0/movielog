import 'package:flutter/material.dart';

import 'movie_rating_input.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, this.initialRating = 0});

  final double initialRating;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _rating = widget.initialRating;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('영화는 어떠셨나요?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            MovieRatingInput(
              rating: _rating,
              onChanged: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            if (_rating > 0)
              TextButton(
                onPressed: () {
                  setState(() {
                    _rating = 0;
                  });
                },
                child: const Text('다시 선택하기'),
              )
            else
              const SizedBox(height: 16),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating == 0
                    ? null
                    : () => Navigator.of(context).pop(_rating),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
