
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/init/app_provider.dart';
import '../utils/app_theme.dart';

class AppTextView extends ConsumerWidget {
  final String heading;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final FontWeight? fontWeight;
  final TextDecoration textDecoration;
  final FontStyle fontStyle;
  final int? maxLines;
  final Color? textColor;
  final double? paddingH;
  final double? paddingV;


  const AppTextView({
    super.key,
    required this.heading,
    required this.fontSize,
    this.textDecoration = TextDecoration.none,
    this.fontFamily = 'regular',
    this.fontStyle = FontStyle.normal,
    this.letterSpacing = 0,
    this.lineHeight = 1.2,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.textOverflow = TextOverflow.visible,
    this.maxLines,
    this.textColor = AppTheme.offWhite,
    this.paddingH, this.paddingV
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingH ?? 0.0, vertical: paddingV ?? 0.0),
      child: Text(
        maxLines: maxLines,
        ref.tr(heading),
        textAlign: textAlign,
        overflow: textOverflow,
        style: GoogleFonts.lilitaOne(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontSize: fontSize,
          fontStyle: fontStyle,
          decoration: textDecoration,
          color: textColor,
          fontWeight:fontWeight ?? FontWeight.w400,
          height: lineHeight,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}