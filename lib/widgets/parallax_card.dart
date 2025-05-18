import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_theme.dart';

class ParallaxCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;
  final String? backgroundImageUrl;
  final String? arabicTitle;

  const ParallaxCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.backgroundImageUrl,
    this.arabicTitle,
  });

  @override
  State<ParallaxCard> createState() => _ParallaxCardState();
}

class _ParallaxCardState extends State<ParallaxCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _offset = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });

    if (isHovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Calculate the offset based on the card size and pointer position
    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final position = details.localPosition;

    // Convert to values between -1 and 1
    final dx = (position.dx / size.width) * 2 - 1;
    final dy = (position.dy / size.height) * 2 - 1;

    setState(() {
      _offset = Offset(dx, dy);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _offset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.isDarkMode;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Calculate rotation based on hover and pan
            final hoverRotateX = -_offset.dy * 0.05;
            final hoverRotateY = _offset.dx * 0.05;

            return Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(hoverRotateX)
                ..rotateY(hoverRotateY)
                ..translate(0.0, _controller.value * -4.0, 0.0),
              child: child,
            );
          },
          child: Card(
            elevation: _isHovering ? 8 : 4,
            shadowColor: widget.color.withAlpha(100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: _isHovering
                  ? BorderSide(color: widget.color.withAlpha(100), width: 2)
                  : BorderSide.none,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Background image with parallax effect
                  if (widget.backgroundImageUrl != null)
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            _offset.dx * 10,
                            _offset.dy * 10,
                          ),
                          child: child,
                        );
                      },
                      child: Opacity(
                        opacity: 0.1,
                        child: Image.network(
                          widget.backgroundImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withAlpha(isDarkMode ? 40 : 20),
                          widget.color.withAlpha(isDarkMode ? 15 : 5),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with animated container
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                -_offset.dx * 8,
                                -_offset.dy * 8,
                              ),
                              child: child,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.color.withAlpha(_isHovering ? 50 : 25),
                              shape: BoxShape.circle,
                              boxShadow: _isHovering
                                  ? [
                                      BoxShadow(
                                        color: widget.color.withAlpha(100),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              widget.icon,
                              size: 40,
                              color: widget.color,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title with animated position
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                -_offset.dx * 5,
                                -_offset.dy * 5,
                              ),
                              child: child,
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (widget.arabicTitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.arabicTitle!,
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),

                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Shine effect on hover
                  if (_isHovering)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              _controller.value * 200 - 100,
                              0,
                            ),
                            child: child,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: const [0.0, 0.3, 0.6, 1.0],
                              colors: [
                                Colors.white.withAlpha(0),
                                Colors.white.withAlpha(0),
                                Colors.white.withAlpha(30),
                                Colors.white.withAlpha(0),
                              ],
                            ),
                          ),
                        ),
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
