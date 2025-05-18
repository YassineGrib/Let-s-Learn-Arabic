import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppAnimations {
  // Button press animation
  static List<Effect> buttonPressEffects() {
    return [
      ScaleEffect(
        begin: const Offset(1.0, 1.0),
        end: const Offset(0.95, 0.95),
        duration: 100.ms,
      ),
      ScaleEffect(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1.0, 1.0),
        duration: 100.ms,
      ),
    ];
  }

  // Card hover animation
  static List<Effect> cardHoverEffects() {
    return [
      ElevationEffect(
        begin: 4,
        end: 8,
        curve: Curves.easeInOut,
        duration: 200.ms,
      ),
      ScaleEffect(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.03, 1.03),
        curve: Curves.easeInOut,
        duration: 200.ms,
      ),
    ];
  }

  // Fade in animation
  static List<Effect> fadeInEffect({Duration? duration}) {
    return [
      FadeEffect(
        begin: 0.0,
        end: 1.0,
        curve: Curves.easeIn,
        duration: duration ?? 300.ms,
      ),
    ];
  }

  // Slide in from bottom animation
  static List<Effect> slideInFromBottomEffect({Duration? duration}) {
    return [
      SlideEffect(
        begin: const Offset(0.0, 0.2),
        end: const Offset(0.0, 0.0),
        curve: Curves.easeOutQuart,
        duration: duration ?? 400.ms,
      ),
      FadeEffect(
        begin: 0.0,
        end: 1.0,
        curve: Curves.easeIn,
        duration: duration ?? 300.ms,
      ),
    ];
  }

  // Slide in from left animation
  static List<Effect> slideInFromLeftEffect({Duration? duration}) {
    return [
      SlideEffect(
        begin: const Offset(-0.2, 0.0),
        end: const Offset(0.0, 0.0),
        curve: Curves.easeOutQuart,
        duration: duration ?? 400.ms,
      ),
      FadeEffect(
        begin: 0.0,
        end: 1.0,
        curve: Curves.easeIn,
        duration: duration ?? 300.ms,
      ),
    ];
  }

  // Slide in from right animation
  static List<Effect> slideInFromRightEffect({Duration? duration}) {
    return [
      SlideEffect(
        begin: const Offset(0.2, 0.0),
        end: const Offset(0.0, 0.0),
        curve: Curves.easeOutQuart,
        duration: duration ?? 400.ms,
      ),
      FadeEffect(
        begin: 0.0,
        end: 1.0,
        curve: Curves.easeIn,
        duration: duration ?? 300.ms,
      ),
    ];
  }

  // Pulse animation
  static List<Effect> pulseEffect({Duration? duration}) {
    return [
      ScaleEffect(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.05, 1.05),
        curve: Curves.easeInOut,
        duration: (duration ?? 600.ms) ~/ 2,
      ),
      ScaleEffect(
        begin: const Offset(1.05, 1.05),
        end: const Offset(1.0, 1.0),
        curve: Curves.easeInOut,
        duration: (duration ?? 600.ms) ~/ 2,
      ),
    ];
  }

  // Success animation
  static List<Effect> successEffect() {
    return [
      ShakeEffect(
        hz: 4,
        curve: Curves.easeInOut,
        duration: 600.ms,
      ),
      ScaleEffect(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.1, 1.1),
        curve: Curves.easeInOut,
        duration: 300.ms,
      ),
      ScaleEffect(
        begin: const Offset(1.1, 1.1),
        end: const Offset(1.0, 1.0),
        curve: Curves.easeInOut,
        duration: 300.ms,
      ),
    ];
  }

  // Staggered list item animation
  static List<Effect> staggeredListItemEffect(int index) {
    return [
      FadeEffect(
        begin: 0.0,
        end: 1.0,
        delay: (50 * index).ms,
        duration: 300.ms,
        curve: Curves.easeOut,
      ),
      SlideEffect(
        begin: const Offset(0.0, 0.1),
        end: const Offset(0.0, 0.0),
        delay: (50 * index).ms,
        duration: 300.ms,
        curve: Curves.easeOut,
      ),
    ];
  }

  // Shimmer loading animation
  static List<Effect> shimmerEffect() {
    return [
      ShimmerEffect(
        color: Colors.white.withAlpha(204),
        size: 1.0,
        delay: 0.ms,
        duration: 1500.ms,
      ),
    ];
  }

  // Apply staggered animations to a list of widgets
  static List<Widget> applyStaggeredAnimations(List<Widget> children) {
    return List.generate(
      children.length,
      (index) => children[index]
          .animate()
          .fadeIn(
            delay: (50 * index).ms,
            duration: 300.ms,
            curve: Curves.easeOut,
          )
          .slideY(
            begin: 0.1,
            end: 0.0,
            delay: (50 * index).ms,
            duration: 300.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}
