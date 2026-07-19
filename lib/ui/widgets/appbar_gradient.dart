

import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class TopGradient extends StatelessWidget {
  const TopGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.2, 0.6, 0.75, 1.0],
          colors: [
            AppTheme.darkBackground.withValues(alpha: 1.0),
            AppTheme.darkBackground.withValues(alpha: 0.8),
            AppTheme.darkBackground.withValues(alpha: 0.3),
            AppTheme.darkBackground.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}