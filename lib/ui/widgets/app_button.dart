import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';

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
  final AlignmentDirectional? textAlignment;
  final String? leftIcon;
  final String? rightIcon;

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
    this.textAlignment = AlignmentDirectional.center,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
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
          alignment: textAlignment,
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 10.sp)),
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
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10.sp,
                children: [
                  if (leftIcon != null) 
                    Flexible(child: SvgPicture.asset(leftIcon!, color: AppTheme.primaryPeach)),

                  AppTextView(
                    heading: ref.tr(title),
                    fontSize: fontSize ?? 16,
                    textColor: filledColor ? (textColor ?? AppTheme.white) : (textColor ?? AppTheme.lightGray),
                    fontWeight: FontWeight.w800,
                  ),

                  if (rightIcon != null)
                    Flexible(child: SvgPicture.asset(rightIcon!, color: AppTheme.primaryPeach)),
                ],
              ),
      ),
    );
  }
}
