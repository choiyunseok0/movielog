import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: colors.surfaceContainer,
          backgroundImage: const AssetImage(
            'assets/images/profile/profile_movielog.jpg',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/person.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              semanticsLabel: '프로필',
            ),
            const SizedBox(width: 8),
            Text('무비러버', style: textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '좋아하는 영화를 기록하고 있어요',
          style: textTheme.bodyMedium?.copyWith(color: colors.outline),
        ),
      ],
    );
  }
}
