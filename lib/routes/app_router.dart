import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/intro_video_screen.dart';
import '../screens/survey_screen.dart';
import '../screens/placement_test_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/quizzes_screen.dart';
import '../screens/workshops_screen.dart';
import '../screens/podcasts_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/welcome_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome',
    routes: [
      // Welcome/Splash screen
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Main app shell with nested routes
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return child;
        },
        routes: [
          // Home screen
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: [
              // All section screens as sub-routes of home
              GoRoute(
                path: 'intro-video',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const IntroVideoScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'survey',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const SurveyScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'placement-test',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const PlacementTestScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'lessons',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const LessonsScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'quizzes',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const QuizzesScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'workshops',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const WorkshopsScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'podcasts',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const PodcastsScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
              GoRoute(
                path: 'chat',
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ChatScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops! Page not found.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
