import 'package:flutter/material.dart';
import '../widgets/appbar_backbtn.dart';
import '../widgets/appbar_gradient.dart';
import 'app_theme.dart';

class AppComponent {
  static Widget appScaffold({bool backButtonVisible = true, double topPadding = 50, required Widget body}) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(height: topPadding),
              body,
            ],
          ),

          TopGradient(),

          if (backButtonVisible) Padding(padding: const EdgeInsets.only(top: 30.0), child: const AppBarBackButton()),
        ],
      ),
    );
  }

  static Widget bgContainer({double? height, double? width, double? radius, required Widget child}) {
    return Container(
      height: height ?? 45,
      width: width ?? 45,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        borderRadius: BorderRadius.circular(radius ?? 10.0),
        border: Border.all(width: .5, color: AppTheme.primaryPeach.withValues(alpha: .2)),
      ),
      child: child,
    );
  }
}
