import 'package:design_mint/core/init/app_routes.dart';
import 'package:design_mint/ui/widgets/app_textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/appbar_gradient.dart';
import 'components/animated_menu_container.dart';
import 'components/feed_list.dart';
import 'home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ref.read(menuProvider.notifier).collapse();
      },
      child: NotificationListener<ScrollStartNotification>(
        onNotification: (notification) {
          if (ref.read(menuProvider).isExpanded) {
            ref.read(menuProvider.notifier).collapse();
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: AppTheme.darkBackground,
          floatingActionButton: SizedBox(
            height: 45,
            width: 45,
            child: FloatingActionButton(
              onPressed: () => context.pushNamed(createPostScreen),
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(50)),
              backgroundColor: AppTheme.primaryPeach.withValues(alpha: .8),
              child: HugeIcon(icon: HugeIconsStrokeRounded.add02, color: AppTheme.darkBackground),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                FeedList(ref: ref),

                TopGradient(),

                Container(
                  margin: const EdgeInsets.fromLTRB(60, 10, 60, 0),
                  child: AppTextField(hintText: 'Search Item ...'),
                ),

                const AnimatedMenuContainer(),

                Align(alignment: Alignment.topRight, child: ProfileAvatar()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Action bar ─────────────────────────────────────────────────────────
class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: .5, color: AppTheme.primaryPeach.withValues(alpha: .2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            spacing: 2,
            children: [
              HugeIcon(icon: HugeIconsStrokeRounded.view, color: AppTheme.primaryPeach, size: 18),
              AppTextView(heading: "View", fontSize: 12),
            ],
          ),
          Row(
            spacing: 2,
            children: [
              HugeIcon(icon: HugeIconsStrokeRounded.download01, color: AppTheme.primaryPeach, size: 18),
              AppTextView(heading: "Downloads", fontSize: 12),
            ],
          ),

          Row(
            spacing: 2,
            children: [
              HugeIcon(icon: HugeIconsStrokeRounded.hotPrice, color: AppTheme.primaryPeach, size: 18),
              AppTextView(heading: "Price", fontSize: 12),
            ],
          ),

          Row(
            spacing: 2,
            children: [
              HugeIcon(icon: HugeIconsStrokeRounded.bookmark01, color: AppTheme.primaryPeach, size: 18),
              AppTextView(heading: "Save", fontSize: 12),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Profile avatar ─────────────────────────────────────────────────────
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: .5, color: AppTheme.primaryPeach.withValues(alpha: .6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          'https://img.freepik.com/vector-premium/imagen-perfil-avatar-hombre-aislada-fondo-imagen-profil-avatar-hombre_1293239-4855.jpg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
