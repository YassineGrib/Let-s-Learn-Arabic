import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'utils/app_theme.dart';
import 'services/gamification_service.dart';
import 'providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  // User progress
  Map<String, double> _progress = {};
  int _points = 0;
  int _streak = 0;
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  // Getters
  Map<String, double> get progress => _progress;
  int get points => _points;
  int get streak => _streak;
  List<Achievement> get achievements => _achievements;
  bool get isLoading => _isLoading;

  // Constructor - Load data from storage
  AppState() {
    _loadData();
  }

  // Load data from storage
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    // Load progress
    _progress = await GamificationService.getProgress();

    // Load points
    _points = await GamificationService.getPoints();

    // Load streak
    _streak = await GamificationService.getStreak();

    // Load achievements
    _achievements = await GamificationService.getAchievements();

    _isLoading = false;
    notifyListeners();
  }

  // Update progress for a section
  Future<void> updateProgress(String section, double progress) async {
    await GamificationService.updateProgress(section, progress);
    _progress[section] = progress;
    notifyListeners();

    // Reload data to get updated achievements, points, etc.
    await _loadData();
  }

  // Add points
  Future<void> addPoints(int points) async {
    await GamificationService.addPoints(points);
    _points += points;
    notifyListeners();

    // Reload data to get updated achievements, streak, etc.
    await _loadData();
  }

  // Reset all data (for testing)
  Future<void> resetAll() async {
    await GamificationService.resetAll();
    await _loadData();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'Let\'s Learn Arabic',
      theme: themeProvider.currentTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
