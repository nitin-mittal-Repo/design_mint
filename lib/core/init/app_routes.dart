import 'package:design_mint/ui/screens/create_post/create_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../ui/screens/detail/detail_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/login/login_screen.dart';
import '../../ui/screens/login/register_screen.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

const String splashScreen = "/splashScreen";
const String registerScreen = "/registerScreen";
const String loginScreen = "/loginScreen";
const String homeScreen = "/home";
const String createPostScreen = "/createPostScreen";
const String detailScreen = "/detail";
const String onboardingScreen = "/onboardingScreen";

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: onboardingScreen,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: splashScreen,
        name: splashScreen,
        pageBuilder: (context, state) => customTransitionPage(
          key: state.pageKey,
          child: SplashScreen(nextScreen: const HomePlaceholder()),
        ),
      ),

      GoRoute(
        path: loginScreen,
        name: loginScreen,
        pageBuilder: (context, state) => customTransitionPage(key: state.pageKey, child: LoginScreen()),
      ),

      GoRoute(
        path: registerScreen,
        name: registerScreen,
        pageBuilder: (context, state) => customTransitionPage(key: state.pageKey, child: RegisterScreen()),
      ),

      GoRoute(
        path: homeScreen,
        name: homeScreen,
        pageBuilder: (context, state) => customTransitionPage(key: state.pageKey, child: HomeScreen()),
      ),
      GoRoute(
        path: createPostScreen,
        name: createPostScreen,
        pageBuilder: (context, state) => customTransitionPage(key: state.pageKey, child: CreatePostScreen()),
      ),
      GoRoute(
        path: detailScreen,
        name: detailScreen,
        pageBuilder: (context, state) => customTransitionPage(key: state.pageKey, child: DetailScreen()),
      ),
      GoRoute(
        path: onboardingScreen,
        name: onboardingScreen,
        pageBuilder: (context, state) => customTransitionPage(key: state.pageKey, child: OnboardingScreen()),
      ),
    ],
  );
});

CustomTransitionPage<void> customTransitionPage({required ValueKey<String> key, required Widget child}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondary, child) {
      return ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
