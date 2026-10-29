import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppBannerType {
  error,
  success,
  info,
}

/// Alert Notification Banner matching design mockup specifications
class AppBanner extends StatelessWidget {
  final String message;
  final AppBannerType type;
  final VoidCallback? onClose;

  const AppBanner({
    Key? key,
    required this.message,
    this.type = AppBannerType.error,
    this.onClose,
  }) : super(key: key);

  const AppBanner.error({
    Key? key,
    required this.message,
    this.onClose,
  })  : type = AppBannerType.error,
        super(key: key);

  const AppBanner.success({
    Key? key,
    required this.message,
    this.onClose,
  })  : type = AppBannerType.success,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case AppBannerType.error:
        bgColor = AppColors.alertErrorBg;
        borderColor = AppColors.alertErrorBorder;
        textColor = AppColors.alertErrorText;
        iconColor = AppColors.alertErrorIcon;
        iconData = Icons.error_outline_rounded;
        break;
      case AppBannerType.success:
        bgColor = AppColors.alertSuccessBg;
        borderColor = AppColors.alertSuccessBorder;
        textColor = AppColors.alertSuccessText;
        iconColor = AppColors.alertSuccessIcon;
        iconData = Icons.check_circle_outline_rounded;
        break;
      case AppBannerType.info:
        bgColor = const Color(0xFFF0F9FF);
        borderColor = const Color(0xFFBAE6FD);
        textColor = const Color(0xFF0369A1);
        iconColor = const Color(0xFF0284C7);
        iconData = Icons.info_outline_rounded;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.5, right: 10),
            child: Icon(
              iconData,
              size: 18,
              color: iconColor,
            ),
          ),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bannerText.copyWith(color: textColor),
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
