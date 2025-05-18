import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GamificationService {
  static const String _pointsKey = 'user_points';
  static const String _achievementsKey = 'user_achievements';
  static const String _progressKey = 'user_progress';
  static const String _streakKey = 'user_streak';
  static const String _lastActivityKey = 'last_activity_date';

  // Points system
  static Future<int> getPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pointsKey) ?? 0;
  }

  static Future<void> addPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPoints = prefs.getInt(_pointsKey) ?? 0;
    await prefs.setInt(_pointsKey, currentPoints + points);
    
    // Update streak
    await _updateStreak();
  }

  // Achievements system
  static Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getStringList(_achievementsKey) ?? [];
    
    return achievementsJson
        .map((json) => Achievement.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> unlockAchievement(Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    final achievements = await getAchievements();
    
    // Check if achievement already exists
    if (achievements.any((a) => a.id == achievement.id)) {
      return;
    }
    
    // Add new achievement
    achievements.add(achievement);
    
    // Save achievements
    final achievementsJson = achievements
        .map((achievement) => jsonEncode(achievement.toJson()))
        .toList();
    
    await prefs.setStringList(_achievementsKey, achievementsJson);
  }

  // Progress tracking
  static Future<Map<String, double>> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);
    
    if (progressJson == null) {
      return {};
    }
    
    final Map<String, dynamic> decoded = jsonDecode(progressJson);
    return decoded.map((key, value) => MapEntry(key, value.toDouble()));
  }

  static Future<void> updateProgress(String section, double progress) async {
    final prefs = await SharedPreferences.getInstance();
    final currentProgress = await getProgress();
    
    // Update progress for the section
    currentProgress[section] = progress;
    
    // Save progress
    await prefs.setString(_progressKey, jsonEncode(currentProgress));
    
    // Check for achievements based on progress
    await _checkProgressAchievements(section, progress);
    
    // Update streak
    await _updateStreak();
  }

  // Streak system
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivityStr = prefs.getString(_lastActivityKey);
    final currentDate = DateTime.now();
    final today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    
    if (lastActivityStr != null) {
      final lastActivity = DateTime.parse(lastActivityStr);
      final lastActivityDate = DateTime(lastActivity.year, lastActivity.month, lastActivity.day);
      
      final difference = today.difference(lastActivityDate).inDays;
      
      if (difference == 1) {
        // Consecutive day, increase streak
        final currentStreak = prefs.getInt(_streakKey) ?? 0;
        await prefs.setInt(_streakKey, currentStreak + 1);
        
        // Check for streak achievements
        await _checkStreakAchievements(currentStreak + 1);
      } else if (difference > 1) {
        // Streak broken
        await prefs.setInt(_streakKey, 1);
      }
    } else {
      // First activity
      await prefs.setInt(_streakKey, 1);
    }
    
    // Update last activity date
    await prefs.setString(_lastActivityKey, today.toIso8601String());
  }

  // Achievement checks
  static Future<void> _checkProgressAchievements(String section, double progress) async {
    if (progress >= 1.0) {
      // Section completed
      await unlockAchievement(
        Achievement(
          id: 'complete_$section',
          title: 'Completed $section',
          description: 'You have completed the $section section!',
          iconData: 'check_circle',
        ),
      );
      
      // Check if all sections are completed
      final allProgress = await getProgress();
      final completedSections = allProgress.entries
          .where((entry) => entry.value >= 1.0)
          .length;
      
      if (completedSections >= 3) {
        await unlockAchievement(
          Achievement(
            id: 'complete_3_sections',
            title: 'Triple Threat',
            description: 'Complete 3 different sections',
            iconData: 'stars',
          ),
        );
      }
      
      if (completedSections >= 8) {
        await unlockAchievement(
          Achievement(
            id: 'complete_all_sections',
            title: 'Master of Arabic',
            description: 'Complete all sections in the app',
            iconData: 'emoji_events',
          ),
        );
      }
    }
  }

  static Future<void> _checkStreakAchievements(int streak) async {
    if (streak >= 3) {
      await unlockAchievement(
        Achievement(
          id: 'streak_3',
          title: '3-Day Streak',
          description: 'Use the app for 3 days in a row',
          iconData: 'local_fire_department',
        ),
      );
    }
    
    if (streak >= 7) {
      await unlockAchievement(
        Achievement(
          id: 'streak_7',
          title: 'Weekly Warrior',
          description: 'Use the app for 7 days in a row',
          iconData: 'local_fire_department',
        ),
      );
    }
    
    if (streak >= 30) {
      await unlockAchievement(
        Achievement(
          id: 'streak_30',
          title: 'Monthly Master',
          description: 'Use the app for 30 days in a row',
          iconData: 'local_fire_department',
        ),
      );
    }
  }

  // Reset all gamification data (for testing)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pointsKey);
    await prefs.remove(_achievementsKey);
    await prefs.remove(_progressKey);
    await prefs.remove(_streakKey);
    await prefs.remove(_lastActivityKey);
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconData;
  final DateTime unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    DateTime? unlockedAt,
  }) : unlockedAt = unlockedAt ?? DateTime.now();

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconData: json['iconData'],
      unlockedAt: DateTime.parse(json['unlockedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconData': iconData,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }
}
