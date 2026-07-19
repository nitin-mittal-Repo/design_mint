import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/init/app_provider.dart';
import '../utils/app_theme.dart';
import 'app_textview.dart';

class AppButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final String title;
  final bool isLoading;
  final Color? color; // Optional color parameter
  final double? fontSize; // Optional font size parameter
  final bool filledColor;
  final double? height;
  final double? width;
  final double paddingV;
  final double paddingH;
  final Color? buttonColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.color, // Default is null, meaning it will use the default color
    this.fontSize, // Optional font size parameter
    this.filledColor = true,
    this.height,
    this.width,
    this.paddingV = 0,
    this.paddingH = 0,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      width: isLoading ? 46 : width,
      height: height ?? 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 1, color: AppTheme.primaryPeach.withValues(alpha: .3)),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: filledColor ? Colors.transparent : buttonColor ?? AppTheme.darkGray, // BORDER when not filled
                width: 1.5,
              ),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            filledColor
                ? (color ?? buttonColor ?? AppTheme.darkGray.withValues(alpha: .9)) // filled
                : Colors.transparent, // outlined
          ),
        ),
        onPressed: /*isLoading ? null :*/ onPressed,
        child: isLoading
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : AppTextView(
          heading: ref.tr(title),
          fontSize: fontSize ?? 16,
          textColor: filledColor ? (textColor ?? AppTheme.white) : (textColor ?? AppTheme.lightGray),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
