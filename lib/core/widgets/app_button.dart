import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// MindEase Primary Action Button with Right Arrow
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showArrow;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final TextStyle? textStyle;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.showArrow = true,
    this.icon,
    this.width,
    this.height = AppSpacing.buttonHeight,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.textOnPrimary;
    final effectiveTextStyle = textStyle ?? AppTypography.buttonLarge;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.roundedPill,
        boxShadow: onPressed == null || isLoading ? null : AppShadows.button,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          disabledBackgroundColor: effectiveBgColor.withOpacity(0.6),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedPill,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      style: effectiveTextStyle.copyWith(
                        color: effectiveTextColor,
                        fontSize: fontSize ?? effectiveTextStyle.fontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showArrow) ...[
                    const SizedBox(width: 8),
                    Icon(
                      icon ?? Icons.arrow_forward_rounded,
                      size: 18,
                      color: effectiveTextColor,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
