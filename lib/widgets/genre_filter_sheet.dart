import 'package:flutter/material.dart';

import '../data/mock_movies.dart';

class GenreFilterSheet extends StatefulWidget {
  const GenreFilterSheet({super.key, required this.initialGenres});

  final Set<String> initialGenres;

  @override
  State<GenreFilterSheet> createState() => _GenreFilterSheetState();
}

class _GenreFilterSheetState extends State<GenreFilterSheet> {
  late final Set<String> _selectedGenres = {...widget.initialGenres};

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '장르 필터',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: _selectedGenres.isEmpty
                          ? null
                          : () {
                              setState(_selectedGenres.clear);
                            },
                      child: const Text('전체 해제'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: movieGenres.length,
                  itemBuilder: (context, index) {
                    final genre = movieGenres[index];
                    return CheckboxListTile(
                      key: ValueKey('genre-$genre'),
                      value: _selectedGenres.contains(genre),
                      title: Text(genre),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (selected) {
                        setState(() {
                          if (selected ?? false) {
                            _selectedGenres.add(genre);
                          } else {
                            _selectedGenres.remove(genre);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop({..._selectedGenres});
                      },
                      child: const Text('적용하기'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
