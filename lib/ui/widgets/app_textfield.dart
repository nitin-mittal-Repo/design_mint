
import 'package:design_mint/ui/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import '../../core/init/app_provider.dart';
import '../utils/app_theme.dart';

class AppTextField extends ConsumerStatefulWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final int? maxLines;
  final int? minLines;
  final double? borderRadius;
  final TextAlign? textAlign;
  final EdgeInsets? scrollPadding;
  final int? maxLength;
  final double paddingV;
  final double paddingH;

  const AppTextField({
    super.key,
    this.onTap,
    this.hintText,
    this.maxLines,
    this.minLines,
    this.hintStyle = const TextStyle(fontSize: 14, color: Color(0x8BFFD3AC), fontFamily: 'regular'),
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.readOnly = false,
    this.textInputStyle = const TextStyle(fontSize: 14, color: AppTheme.primaryPeach, fontFamily: 'regular'),
    this.onFieldSubmitted,
    this.inputFormatters,
    this.borderColor,
    this.borderRadius,
    this.textAlign,
    this.scrollPadding,
    this.maxLength,
    this.paddingV = 0,
    this.paddingH = 0,
  });

  @override
  // 👇 Public state so GlobalKey can access it
  ConsumerState<AppTextField> createState() => AppTextFieldState();
}

class AppTextFieldState extends ConsumerState<AppTextField> {
  String? errorText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      validate(widget.controller?.text);
    }
  }

  @override
  void dispose() {
    // ✅ only dispose if we created it internally
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  // ✅ Returns bool so button can check validity
  bool validate([String? value]) {
    if (widget.validator != null) {
      final result = widget.validator!(value ?? widget.controller?.text);
      if (mounted) {
        setState(() => errorText = result);
      }
      return result == null || result.isEmpty;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.maxLines == null) ?  45 : null,
      padding: EdgeInsets.symmetric(vertical: widget.paddingV, horizontal: widget.paddingH),
      child: TextFormField(
        maxLength: widget.maxLength,
        scrollPadding: widget.scrollPadding ?? EdgeInsets.zero,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines ?? 1,
        textAlign: widget.textAlign ?? TextAlign.start,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: AppTheme.primaryPeach,
        onFieldSubmitted: widget.onFieldSubmitted,
        textAlignVertical: TextAlignVertical.center,
        onTap: widget.onTap,
        focusNode: _focusNode,
        // ✅ always use merged _focusNode
        controller: widget.controller,
        obscureText: widget.obscureText,
        onChanged: (value) {
          validate(value);
          widget.onChanged?.call(value);
        },
        keyboardType: widget.keyboardType,
        validator: (value) {
          final result = widget.validator?.call(value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => errorText = result);
            }
          });
          return result;
        },
        readOnly: widget.readOnly,
        style: widget.textInputStyle,
        inputFormatters: widget.inputFormatters ?? [],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          // fillColor: AppTheme.darkGray,
          fillColor:  Colors.transparent,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.suffixIcon != null) widget.suffixIcon!,

               if (errorText != null && errorText!.isNotEmpty)
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: ref.tr(errorText ?? ''),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0,0,10,0),
                      child: SvgPicture.asset(AppAssets.iconInfo, color: AppTheme.red)),
                ),
            ],
          ),
          prefixIcon: widget.prefixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.grey.withValues(alpha: 0.4), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.grey.withValues(alpha: 0.4), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
            borderSide: BorderSide(
              color: AppTheme.lightGray, // ✅ highlight on focus
              width: 0.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
            borderSide: BorderSide(color: AppTheme.primaryPeach, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
            borderSide: BorderSide(color: AppTheme.primaryPeach, width: 1.0),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(10.0),
          hintText: ref.tr(widget.hintText ?? ""),
          hintStyle: widget.hintStyle ,
          errorStyle: const TextStyle(color: AppTheme.darkGray, fontFamily: "medium", fontSize: 0),
        ),
      ),
    );
  }
}