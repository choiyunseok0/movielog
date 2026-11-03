import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common_app_bar.dart';
import '../widgets/favorite_genres.dart';
import '../widgets/profile_edit_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: '내 프로필'),
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),
            const ProfileEditButton(),
            const SizedBox(height: 40),
            const ProfileStats(),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('내가 등록한 평점'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/my/ratings'),
            ),
            const SizedBox(height: 24),
            const FavoriteGenres(),
          ],
        ),
      ),
    );
  }
}
