import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_theme.dart';
import '../utils/animations.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isOutlined;
  final bool useHapticFeedback;
  final bool showShadow;
  final BorderRadius? borderRadius;

  const AnimatedButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.isOutlined = false,
    this.useHapticFeedback = true,
    this.showShadow = true,
    this.borderRadius,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.useHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = widget.backgroundColor ??
        (widget.isOutlined ? Colors.transparent : AppTheme.primaryColor);

    final Color textColor = widget.textColor ??
        (widget.isOutlined ? AppTheme.primaryColor : Colors.white);

    final BorderRadius borderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: borderRadius,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              border: widget.isOutlined
                  ? Border.all(color: AppTheme.primaryColor, width: 2)
                  : null,
              boxShadow: widget.showShadow && !widget.isOutlined
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withAlpha(76),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: textColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool useHapticFeedback;
  final String? tooltip;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.useHapticFeedback = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? AppTheme.primaryColor;
    final Color iColor = iconColor ?? Colors.white;

    Widget button = InkWell(
      onTap: () {
        if (useHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        onPressed();
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: iColor,
            size: size / 2,
          ),
        ),
      ),
    ).animate()
      .scaleXY(
        duration: 200.ms,
        begin: 1.0,
        end: 0.95,
        curve: Curves.easeInOut,
      )
      .then()
      .scaleXY(
        duration: 200.ms,
        begin: 0.95,
        end: 1.0,
        curve: Curves.easeInOut,
      );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double? width;
  final double height;
  final IconData? icon;
  final bool useHapticFeedback;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.width,
    this.height = 50,
    this.icon,
    this.useHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [
      AppTheme.primaryColor,
      AppTheme.primaryLightColor,
    ];

    return InkWell(
      onTap: () {
        if (useHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        onPressed();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors.first.withAlpha(76),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .scaleXY(
        duration: 200.ms,
        begin: 1.0,
        end: 0.95,
        curve: Curves.easeInOut,
      )
      .then()
      .scaleXY(
        duration: 200.ms,
        begin: 0.95,
        end: 1.0,
        curve: Curves.easeInOut,
      );
  }
}
