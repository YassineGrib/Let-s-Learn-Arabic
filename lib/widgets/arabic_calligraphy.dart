import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_theme.dart';

class ArabicCalligraphy extends StatelessWidget {
  final double size;
  final Color? color;
  final bool animate;
  final String? text;
  final TextStyle? textStyle;

  const ArabicCalligraphy({
    super.key,
    this.size = 100,
    this.color,
    this.animate = true,
    this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Decorative background
        Container(
          width: size * 1.2,
          height: size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (color ?? AppTheme.primaryColor).withAlpha(20),
          ),
        )
        .animate(autoPlay: animate)
        .scaleXY(
          begin: 0.9,
          end: 1.1,
          duration: 3.seconds,
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(
          begin: 1.1,
          end: 0.9,
          duration: 3.seconds,
          curve: Curves.easeInOut,
        ),

        // Inner circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (color ?? AppTheme.primaryColor).withAlpha(40),
          ),
        )
        .animate(autoPlay: animate)
        .scaleXY(
          begin: 1.1,
          end: 0.9,
          duration: 3.seconds,
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(
          begin: 0.9,
          end: 1.1,
          duration: 3.seconds,
          curve: Curves.easeInOut,
        ),

        // Arabic text or symbol
        if (text != null)
          Text(
            text!,
            style: textStyle ?? TextStyle(
              // fontFamily: 'Amiri',
              fontSize: size * 0.5,
              color: color ?? AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          )
          .animate(autoPlay: animate)
          .fadeIn(
            duration: 1.seconds,
            curve: Curves.easeIn,
          )
          .then()
          .rotate(
            begin: -0.05,
            end: 0.05,
            duration: 4.seconds,
            curve: Curves.easeInOut,
          )
          .then()
          .rotate(
            begin: 0.05,
            end: -0.05,
            duration: 4.seconds,
            curve: Curves.easeInOut,
          ),
      ],
    );
  }
}

class ArabicPatternDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const ArabicPatternDivider({
    super.key,
    this.height = 30,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? AppTheme.primaryColor;

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(
            color: actualColor.withAlpha(100),
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: height * 0.8,
                color: actualColor,
              ),
              SizedBox(width: height * 0.3),
              Icon(
                Icons.circle,
                size: height * 0.4,
                color: actualColor,
              ),
              SizedBox(width: height * 0.3),
              Icon(
                Icons.star,
                size: height * 0.8,
                color: actualColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArabicDecorationHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? color;

  const ArabicDecorationHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? AppTheme.primaryColor;

    return Column(
      children: [
        // Decorative pattern
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: actualColor.withAlpha(20),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: actualColor,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 2,
                  color: actualColor.withAlpha(100),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.star,
                  size: 16,
                  color: actualColor,
                ),
              ],
            ),
          ),
        ),

        // Title
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              // fontFamily: 'Tajawal',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: actualColor,
            ),
          ),
        ),

        // Subtitle if provided
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              subtitle!,
              style: TextStyle(
                // fontFamily: 'Tajawal',
                fontSize: 16,
                color: AppTheme.isDarkMode
                    ? Colors.white70
                    : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // Bottom decoration
        ArabicPatternDivider(color: actualColor),
      ],
    );
  }
}
