import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool showLabel;
  final double size;
  
  const ThemeToggleButton({
    super.key, 
    this.showLabel = false,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        themeProvider.toggleTheme();
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isDark 
              ? AppTheme.darkSurfaceColor.withAlpha(150) 
              : Colors.white.withAlpha(150),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(isDark),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                isDark ? 'Light Mode' : 'Dark Mode',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildIcon(bool isDark) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Sun
          Opacity(
            opacity: isDark ? 0.0 : 1.0,
            child: Icon(
              Icons.wb_sunny_rounded,
              color: Colors.amber,
              size: size,
            )
            .animate(target: isDark ? 0 : 1)
            .scaleXY(
              begin: 0.5,
              end: 1.0,
              duration: 300.ms,
              curve: Curves.easeOutBack,
            )
            .rotate(
              begin: -0.5,
              end: 0,
              duration: 300.ms,
            ),
          ),
          
          // Moon
          Opacity(
            opacity: isDark ? 1.0 : 0.0,
            child: Icon(
              Icons.nightlight_round,
              color: Colors.indigo[200],
              size: size,
            )
            .animate(target: isDark ? 1 : 0)
            .scaleXY(
              begin: 0.5,
              end: 1.0,
              duration: 300.ms,
              curve: Curves.easeOutBack,
            )
            .rotate(
              begin: 0.5,
              end: 0,
              duration: 300.ms,
            ),
          ),
        ],
      ),
    );
  }
}
