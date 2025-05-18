import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../utils/app_theme.dart';
import '../widgets/progress_card.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/parallax_card.dart';
import '../widgets/skeleton_loading.dart';
import '../widgets/arabic_calligraphy.dart';
import '../services/gamification_service.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  Achievement? _newAchievement;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Check for new achievements after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _checkForNewAchievements();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkForNewAchievements() {
    // This would normally check for new achievements from the backend
    // For demo purposes, we'll simulate a new achievement
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.achievements.isEmpty) {
      // Simulate a new achievement
      final achievement = Achievement(
        id: 'welcome',
        title: 'Welcome!',
        description: 'Start your Arabic learning journey',
        iconData: 'emoji_events',
      );

      setState(() {
        _newAchievement = achievement;
      });

      // Show confetti
      _confettiController.play();

      // Add the achievement
      GamificationService.unlockAchievement(achievement);
    }
  }

  void _dismissAchievement() {
    setState(() {
      _newAchievement = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _buildMainContent(),

          // Achievement popup if needed
          if (_newAchievement != null)
            AchievementPopup(
              achievement: _newAchievement!,
              onDismiss: _dismissAchievement,
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          backgroundColor: AppTheme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Let\'s Learn Arabic',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryDarkColor,
                      ],
                    ),
                  ),
                ),

                // Pattern overlay
                Opacity(
                  opacity: 0.1,
                  child: Image.network(
                    'https://i.imgur.com/JcYYC2i.png', // Arabic pattern placeholder
                    fit: BoxFit.cover,
                  ),
                ),

                // User stats
                Positioned(
                  bottom: 60,
                  left: 16,
                  right: 16,
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            Icons.emoji_events,
                            '${appState.points}',
                            'Points',
                          ),
                          _buildStatItem(
                            Icons.local_fire_department,
                            '${appState.streak}',
                            'Day Streak',
                          ),
                          _buildStatItem(
                            Icons.star,
                            '${appState.achievements.length}',
                            'Achievements',
                          ),
                        ],
                      ).animate().fadeIn(duration: 500.ms);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ThemeToggleButton(),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Show notifications
                HapticFeedback.lightImpact();
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                // Show profile
                HapticFeedback.lightImpact();
              },
            ),
          ],
        ),

        // Welcome message
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Let\'s Learn Arabic!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutQuad,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start your journey to learn Arabic with our interactive lessons and activities.',
                  style: TextStyle(fontSize: 16),
                ).animate().fadeIn(
                  delay: 200.ms,
                  duration: 400.ms,
                ).slideY(
                  begin: 0.2,
                  end: 0,
                  delay: 200.ms,
                  duration: 400.ms,
                  curve: Curves.easeOutQuad,
                ),
              ],
            ),
          ),
        ),

        // Tab bar
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Learn'),
                Tab(text: 'Progress'),
                Tab(text: 'Achievements'),
              ],
            ),
          ),
          pinned: true,
        ),

        // Tab content
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLearnTab(),
              _buildProgressTab(),
              _buildAchievementsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLearnTab() {
    final features = [
      {
        'title': 'Introductory Video',
        'icon': Icons.play_circle_filled,
        'color': AppTheme.introVideoColor,
        'route': '/intro-video',
        'subtitle': 'Start here',
        'backgroundUrl': 'https://i.imgur.com/JcYYC2i.png',
        'arabicTitle': 'فيديو تمهيدي',
      },
      {
        'title': 'User Survey',
        'icon': Icons.assignment,
        'color': AppTheme.surveyColor,
        'route': '/survey',
        'subtitle': 'Tell us about yourself',
        'arabicTitle': 'استبيان المستخدم',
      },
      {
        'title': 'Placement Test',
        'icon': Icons.quiz,
        'color': AppTheme.placementTestColor,
        'route': '/placement-test',
        'subtitle': 'Find your level',
        'arabicTitle': 'اختبار تحديد المستوى',
      },
      {
        'title': 'Lessons',
        'icon': Icons.book,
        'color': AppTheme.lessonsColor,
        'route': '/lessons',
        'subtitle': 'Learn Arabic step by step',
        'backgroundUrl': 'https://i.imgur.com/JcYYC2i.png',
        'arabicTitle': 'الدروس',
      },
      {
        'title': 'Quizzes',
        'icon': Icons.check_circle,
        'color': AppTheme.quizzesColor,
        'route': '/quizzes',
        'subtitle': 'Test your knowledge',
        'arabicTitle': 'الاختبارات',
      },
      {
        'title': 'Workshops',
        'icon': Icons.groups,
        'color': AppTheme.workshopsColor,
        'route': '/workshops',
        'subtitle': 'Interactive learning',
        'arabicTitle': 'ورش العمل',
      },
      {
        'title': 'Podcasts',
        'icon': Icons.headphones,
        'color': AppTheme.podcastsColor,
        'route': '/podcasts',
        'subtitle': 'Listen and learn',
        'backgroundUrl': 'https://i.imgur.com/JcYYC2i.png',
        'arabicTitle': 'البودكاست',
      },
      {
        'title': 'Chat Space',
        'icon': Icons.chat,
        'color': AppTheme.chatColor,
        'route': '/chat',
        'subtitle': 'Practice with others',
        'arabicTitle': 'مساحة الدردشة',
      },
    ];

    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.isLoading) {
          return const SkeletonGridView();
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return ParallaxCard(
                title: feature['title'] as String,
                icon: feature['icon'] as IconData,
                color: feature['color'] as Color,
                subtitle: feature['subtitle'] as String?,
                backgroundImageUrl: feature['backgroundUrl'] as String?,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(feature['route'] as String);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProgressTab() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.isLoading) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoading(
                  width: 200,
                  height: 24,
                  margin: EdgeInsets.only(bottom: 16),
                ),
                Expanded(
                  child: SkeletonGridView(
                    crossAxisCount: 2,
                    itemCount: 8,
                    childAspectRatio: 0.85,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Arabic decoration header
              ArabicDecorationHeader(
                title: 'Your Learning Progress',
                subtitle: 'Track your Arabic learning journey',
                color: AppTheme.primaryColor,
              ).animate().fadeIn(duration: 400.ms).slideY(
                begin: 0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SectionProgressGrid(
                  progressData: appState.progress,
                  onSectionTap: (section) {
                    context.push('/$section');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementsTab() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.isLoading) {
          return const SkeletonListView(
            itemCount: 5,
            hasAvatar: true,
            hasSubtitle: true,
          );
        }

        final achievements = appState.achievements;

        if (achievements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ArabicCalligraphy(
                  size: 100,
                  color: AppTheme.primaryColor,
                  text: 'إنجازات',
                  textStyle: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No achievements yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                const SizedBox(height: 8),
                Text(
                  'Complete activities to earn achievements',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _tabController.animateTo(0); // Switch to Learn tab
                  },
                  child: const Text('Start Learning'),
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: AchievementBadge(
                achievement: achievements[index],
              ).animate().fadeIn(
                delay: (index * 100).ms,
                duration: 400.ms,
              ).slideX(
                begin: 0.1,
                end: 0,
                delay: (index * 100).ms,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ),
            );
          },
        );
      },
    );
  }


}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
