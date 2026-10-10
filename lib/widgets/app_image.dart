import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final WidgetBuilder? errorBuilder;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget defaultError(BuildContext context) => Container(
      width: width,
      height: height,
      color: AppColors.primaryLight,
      child: const Center(
        child: Icon(
          Icons.home_work_rounded,
          color: AppColors.primary,
          size: 36,
        ),
      ),
    );

    String cleanUrl = imageUrl.trim();
    if (cleanUrl.contains('Santi.png')) {
      cleanUrl = cleanUrl.replaceAll('Santi.png', 'Shanti.png');
    }

    if (cleanUrl.isEmpty) {
      return defaultError(context);
    }

    final bool isNetwork =
        cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('AppImage network load failed for "$cleanUrl": $error');
          return errorBuilder != null
              ? errorBuilder!(context)
              : defaultError(context);
        },
      );
    } else {
      return Image.asset(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('AppImage asset load failed for "$cleanUrl": $error');
          return errorBuilder != null
              ? errorBuilder!(context)
              : defaultError(context);
        },
      );
    }
  }
}
