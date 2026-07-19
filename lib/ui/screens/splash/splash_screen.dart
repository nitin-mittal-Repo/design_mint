import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------
/// APP COLORS — matches your existing palette
/// ---------------------------------------------------------------------
class AppColors {
  static const Color primaryPeach = Color(0xFFFFD3AC);
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkGray = Color(0xFF2D2D30);
  static const Color lightGray = Color(0xFF9E9E9E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color red = Color(0xFFEE4B2B);
}

/// ---------------------------------------------------------------------
/// SPLASH SCREEN — simple fade + scale
/// Usage: set as your `home` in MaterialApp, and it will auto-navigate
/// to `nextScreen` once the animation + hold time finishes.
/// ---------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final Duration holdDuration; // time to stay after animation completes

  const SplashScreen({
    super.key,
    required this.nextScreen,
    this.holdDuration = const Duration(milliseconds: 900),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Logo: gentle fade in while growing from 0.8x to 1.0x
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Text fades in slightly after the logo starts appearing
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(widget.holdDuration, _goNext);
      }
    });
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, anim, __) => widget.nextScreen,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: _DMLogoPainter(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _textOpacity,
              child: Column(
                children: [
                  const Text(
                    'DM',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'YOUR TAGLINE HERE',
                    style: TextStyle(
                      color: AppColors.lightGray,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// LOGO PAINTER
/// Draws a simplified "D" (offWhite) + "M / checkmark" (peach gradient)
/// mark inspired by your uploaded logo, entirely in vector paths so it
/// scales crisply at any size.
/// ---------------------------------------------------------------------
class _DMLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ---------------- D shape ----------------
    final dPaint = Paint()
      ..color = AppColors.offWhite
      ..style = PaintingStyle.fill;

    final dPath = Path();
    final stroke = w * 0.20;
    final left = w * 0.10;
    final top = h * 0.14;
    final bottom = h * 0.62;
    final right = w * 0.62;

    dPath.moveTo(left, top);
    dPath.lineTo(left + stroke, top);
    dPath.lineTo(right - stroke * 0.5, top);
    dPath.quadraticBezierTo(
      w * 0.86, top, w * 0.86, (top + bottom) / 2,
    );
    dPath.quadraticBezierTo(
      w * 0.86, bottom, right - stroke * 0.5, bottom,
    );
    dPath.lineTo(left + stroke, bottom);
    dPath.lineTo(left + stroke, top + stroke);
    dPath.lineTo(right - stroke * 0.9, top + stroke);
    dPath.quadraticBezierTo(
      w * 0.68, top + stroke, w * 0.68, (top + bottom) / 2,
    );
    dPath.quadraticBezierTo(
      w * 0.68, bottom - stroke, right - stroke * 0.9, bottom - stroke,
    );
    dPath.lineTo(left + stroke, bottom - stroke);
    dPath.lineTo(left + stroke, bottom);
    dPath.lineTo(left, bottom);
    dPath.close();

    canvas.drawPath(dPath, dPaint);

    // ---------------- M / checkmark shape ----------------
    final mRect = Rect.fromLTWH(w * 0.28, h * 0.30, w * 0.62, h * 0.56);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.primaryPeach, AppColors.red.withOpacity(0.75)],
    );
    final mPaint = Paint()
      ..shader = gradient.createShader(mRect)
      ..style = PaintingStyle.fill;

    final mStroke = w * 0.16;
    final mPath = Path();
    final mLeft = w * 0.30;
    final mTop = h * 0.34;
    final mBottom = h * 0.86;
    final mRight = w * 0.90;
    final midX = (mLeft + mRight) / 2;
    final midY = h * 0.62;

    mPath.moveTo(mLeft, mBottom);
    mPath.lineTo(mLeft, mTop);
    mPath.lineTo(midX, midY);
    mPath.lineTo(mRight, mTop);
    mPath.lineTo(mRight, mBottom);
    mPath.lineTo(mRight - mStroke, mBottom);
    mPath.lineTo(mRight - mStroke, mTop + mStroke * 1.1);
    mPath.lineTo(midX, midY + mStroke * 0.75);
    mPath.lineTo(mLeft + mStroke, mTop + mStroke * 1.1);
    mPath.lineTo(mLeft + mStroke, mBottom);
    mPath.close();

    canvas.drawPath(mPath, mPaint);
  }

  @override
  bool shouldRepaint(covariant _DMLogoPainter oldDelegate) => false;
}

/// ---------------------------------------------------------------------
/// EXAMPLE ENTRY POINT (remove/replace with your own app setup)
/// ---------------------------------------------------------------------
class SplashDemoApp extends StatelessWidget {
  const SplashDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.darkBackground,
        useMaterial3: true,
      ),
      home: SplashScreen(
        nextScreen: const HomePlaceholder(),
      ),
    );
  }
}




class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: AppColors.white, fontSize: 20),
        ),
      ),
    );
  }
}