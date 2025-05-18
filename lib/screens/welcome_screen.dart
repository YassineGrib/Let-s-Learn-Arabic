import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';
import '../widgets/arabic_calligraphy.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showGetStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.forward();

    // Show the "Get Started" button after animations
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showGetStarted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://i.imgur.com/JcYYC2i.png', // Arabic pattern placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Hero section with animations
                Expanded(
                  flex: 3,
                  child: _buildHeroSection(),
                ),

                // Bottom section with button
                Expanded(
                  flex: 2,
                  child: _buildBottomSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo/icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.language,
                size: 80,
                color: AppTheme.primaryColor,
              ),
            ),
          )
          .animate(controller: _controller)
          .scaleXY(
            begin: 0.0,
            end: 1.0,
            duration: 800.ms,
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 40),

          // App name
          Text(
            "Let's Learn Arabic",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
          .animate(controller: _controller)
          .fadeIn(
            delay: 400.ms,
            duration: 800.ms,
          )
          .slideY(
            begin: 0.2,
            end: 0,
            delay: 400.ms,
            duration: 800.ms,
            curve: Curves.easeOutQuad,
          ),

          const SizedBox(height: 16),

          // Tagline
          Text(
            "Start your journey to Arabic fluency",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )
          .animate(controller: _controller)
          .fadeIn(
            delay: 800.ms,
            duration: 800.ms,
          )
          .slideY(
            begin: 0.2,
            end: 0,
            delay: 800.ms,
            duration: 800.ms,
            curve: Curves.easeOutQuad,
          ),

          const SizedBox(height: 40),

          // Animated Arabic letters
          _buildAnimatedArabicLetters(),
        ],
      ),
    );
  }

  Widget _buildAnimatedArabicLetters() {
    final arabicLetters = ['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د'];

    return Column(
      children: [
        // Arabic calligraphy decoration
        Opacity(
          opacity: _controller.value > 0.5 ? 1.0 : 0.0,
          child: ArabicCalligraphy(
            size: 80,
            color: Colors.white,
            text: 'تعلم',
            textStyle: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            animate: _controller.value > 0.5,
          ),
        ),

        const SizedBox(height: 20),

        // Animated letters
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              arabicLetters.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  arabicLetters[index],
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                .animate(controller: _controller)
                .fadeIn(
                  delay: (1200 + (index * 100)).ms,
                  duration: 400.ms,
                )
                .scaleXY(
                  begin: 0.5,
                  end: 1.0,
                  delay: (1200 + (index * 100)).ms,
                  duration: 400.ms,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Features list
          ..._buildFeaturesList(),

          const SizedBox(height: 40),

          // Get Started button
          if (_showGetStarted)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(76),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ابدأ',
                      style: TextStyle(
                        // fontFamily: 'Tajawal',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(
              duration: 600.ms,
            )
            .scaleXY(
              begin: 0.8,
              end: 1.0,
              duration: 600.ms,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildFeaturesList() {
    final features = [
      'Interactive lessons and quizzes',
      'Learn at your own pace',
      'Track your progress',
    ];

    return features.asMap().entries.map((entry) {
      final index = entry.key;
      final feature = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                feature,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
        .animate(controller: _controller)
        .fadeIn(
          delay: (1600 + (index * 200)).ms,
          duration: 400.ms,
        )
        .slideX(
          begin: -0.2,
          end: 0,
          delay: (1600 + (index * 200)).ms,
          duration: 400.ms,
        ),
      );
    }).toList();
  }
}
