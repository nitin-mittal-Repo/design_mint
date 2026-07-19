

import 'package:design_mint/ui/utils/app_theme.dart';
import 'package:flutter/material.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int totalScreens;
  final int currentIndex; // 0-based

  const OnboardingProgressIndicator({
    super.key,
    required this.totalScreens,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalScreens, (index) {
        final bool isActive = index == currentIndex;
        return Container(
          height: 5,
          width: index == currentIndex ? 16 : 8,
          margin: EdgeInsets.only(
            right: index == totalScreens - 1 ? 0 : 4,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryPeach
                : AppTheme.darkGray,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}