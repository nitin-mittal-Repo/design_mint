// widgets/animated_menu_container.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import '../../../../core/init/app_routes.dart';
import '../../../utils/app_theme.dart';
import '../../../widgets/app_textview.dart';
import '../home_provider.dart';

class AnimatedMenuContainer extends ConsumerStatefulWidget {
  const AnimatedMenuContainer({super.key});

  @override
  ConsumerState<AnimatedMenuContainer> createState() => _AnimatedMenuContainerState();
}

class _AnimatedMenuContainerState extends ConsumerState<AnimatedMenuContainer> {
  bool _showItems = false; // ✅ local delay state

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final menuNotifier = ref.read(menuProvider.notifier);
    final isExpanded = menuState.isExpanded;

    // ✅ watch isExpanded and trigger delay
    ref.listen(menuProvider, (previous, next) {
      if (next.isExpanded) {
        // expanding → wait 1 sec then show items
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _showItems = true);
        });
      } else {
        // collapsing → hide items immediately
        setState(() => _showItems = false);
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: menuNotifier.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        clipBehavior: Clip.antiAlias,
        width: isExpanded ? screenWidth / 2 : 45,
        height: isExpanded ? screenHeight : 45,
        padding: EdgeInsets.symmetric(horizontal: isExpanded ? 20 : 10, vertical: isExpanded ? 20 : 10),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: isExpanded ? AppTheme.darkGray.withValues(alpha: .9) : Colors.transparent,
          borderRadius: BorderRadius.circular(isExpanded ? 20 : 50),
          border: Border.all(width: .5, color: AppTheme.primaryPeach.withValues(alpha: .2)),
        ),
        child: Stack(
          children: [
            // ── icon ────────────────────────────────────────────
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: HugeIcon(
                  key: ValueKey(isExpanded),
                  icon: isExpanded ? HugeIconsStrokeRounded.cancel01 : HugeIconsStrokeRounded.menu03,
                  color: AppTheme.primaryPeach,
                ),
              ),
            ),

            // ── menu items with 1s delay ─────────────────────────
            if (isExpanded)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _showItems ? 1.0 : 0.0, // ✅ controlled by delay
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MenuItem(icon: HugeIconsStrokeRounded.home01, label: 'Home', route: homeScreen, onClose: menuNotifier.collapse),
                      _MenuItem(icon: HugeIconsStrokeRounded.profile02, label: 'Create', route: createPostScreen, onClose: menuNotifier.collapse),
                      _MenuItem(icon: HugeIconsStrokeRounded.creativeMarket, label: 'My Posts', route: '/create', onClose: menuNotifier.collapse),
                      _MenuItem(icon: HugeIconsStrokeRounded.money01, label: 'My Earning', route: '/search', onClose: menuNotifier.collapse),
                      _MenuItem(icon: HugeIconsStrokeRounded.starCircle, label: 'Rating', route: '/search', onClose: menuNotifier.collapse),
                      const SizedBox(height: 24),
                      Divider(color: AppTheme.primaryPeach.withValues(alpha: .15)),
                      _MenuItem(icon: HugeIconsStrokeRounded.logout01, label: 'Logout', route: '/logout', onClose: menuNotifier.collapse),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Private menu item ─────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final List<String>? innerList;
  final String label;
  final String route;
  final VoidCallback onClose;

  const _MenuItem({required this.icon, required this.label, required this.route, required this.onClose, this.innerList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
         context.pushNamed(route);
         onClose();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(icon: icon, color: AppTheme.primaryPeach, size: 20),
                const SizedBox(width: 14),
                Flexible(
                  child: AppTextView(heading: label, textOverflow: TextOverflow.ellipsis, fontSize: 16, textColor: AppTheme.primaryPeach),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
