import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../utils/app_theme.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showPercentage;
  final bool isCircular;

  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.color,
    this.icon,
    this.onTap,
    this.showPercentage = true,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppTheme.primaryColor;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isCircular
              ? _buildCircularProgress(cardColor, context)
              : _buildLinearProgress(cardColor, context),
        ),
      ),
    );
  }

  Widget _buildCircularProgress(Color cardColor, BuildContext context) {
    // Pre-calculate percentage to avoid multiple calculations
    final int percentValue = (progress * 100).toInt();
    final bool isCompleted = progress >= 1.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 45.0, // Slightly smaller for better performance
          lineWidth: 8.0, // Slightly thinner for better performance
          percent: progress.clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: cardColor,
                  size: 22, // Slightly smaller for better performance
                ),
              if (showPercentage)
                Text(
                  '$percentValue%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Slightly smaller for better performance
                    color: cardColor,
                  ),
                ),
            ],
          ),
          progressColor: cardColor,
          backgroundColor: cardColor.withAlpha(51),
          animation: false, // Disable animation for better performance
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 12), // Slightly smaller spacing
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14, // Slightly smaller for better performance
          ),
          textAlign: TextAlign.center,
          maxLines: 2, // Limit text lines for better performance
          overflow: TextOverflow.ellipsis,
        ),
        if (isCompleted)
          Padding(
            padding: const EdgeInsets.only(top: 6.0), // Slightly smaller spacing
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Use minimum space needed
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 14, // Slightly smaller for better performance
                ),
                const SizedBox(width: 4),
                const Text(
                  'Completed',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontSize: 12, // Slightly smaller for better performance
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLinearProgress(Color cardColor, BuildContext context) {
    // Pre-calculate percentage to avoid multiple calculations
    final int percentValue = (progress * 100).toInt();
    final bool isCompleted = progress >= 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: cardColor,
                size: 20, // Slightly smaller for better performance
              ),
              const SizedBox(width: 6), // Slightly smaller spacing
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // Slightly smaller for better performance
                ),
                maxLines: 1, // Limit text lines for better performance
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showPercentage)
              Text(
                '$percentValue%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Slightly smaller for better performance
                  color: cardColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8), // Slightly smaller spacing
        LinearPercentIndicator(
          lineHeight: 8.0, // Slightly smaller for better performance
          percent: progress.clamp(0.0, 1.0),
          progressColor: cardColor,
          backgroundColor: cardColor.withAlpha(51),
          animation: false, // Disable animation for better performance
          barRadius: const Radius.circular(4), // Slightly smaller for better performance
          padding: EdgeInsets.zero,
        ),
        if (isCompleted)
          Padding(
            padding: const EdgeInsets.only(top: 6.0), // Slightly smaller spacing
            child: Row(
              mainAxisSize: MainAxisSize.min, // Use minimum space needed
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 14, // Slightly smaller for better performance
                ),
                const SizedBox(width: 4),
                const Text(
                  'Completed',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontSize: 12, // Slightly smaller for better performance
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class SectionProgressGrid extends StatelessWidget {
  final Map<String, double> progressData;
  final Function(String) onSectionTap;

  const SectionProgressGrid({
    super.key,
    required this.progressData,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    // Define sections data to avoid repetitive code
    final sections = [
      {
        'title': 'Introductory Video',
        'key': 'intro-video',
        'icon': Icons.play_circle_filled,
        'color': AppTheme.introVideoColor,
      },
      {
        'title': 'User Survey',
        'key': 'survey',
        'icon': Icons.assignment,
        'color': AppTheme.surveyColor,
      },
      {
        'title': 'Placement Test',
        'key': 'placement-test',
        'icon': Icons.quiz,
        'color': AppTheme.placementTestColor,
      },
      {
        'title': 'Lessons',
        'key': 'lessons',
        'icon': Icons.book,
        'color': AppTheme.lessonsColor,
      },
      {
        'title': 'Quizzes',
        'key': 'quizzes',
        'icon': Icons.check_circle,
        'color': AppTheme.quizzesColor,
      },
      {
        'title': 'Workshops',
        'key': 'workshops',
        'icon': Icons.groups,
        'color': AppTheme.workshopsColor,
      },
      {
        'title': 'Podcasts',
        'key': 'podcasts',
        'icon': Icons.headphones,
        'color': AppTheme.podcastsColor,
      },
      {
        'title': 'Chat Space',
        'key': 'chat',
        'icon': Icons.chat,
        'color': AppTheme.chatColor,
      },
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85, // Adjust for better card proportions
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final key = section['key'] as String;
        final title = section['title'] as String;
        final icon = section['icon'] as IconData;
        final color = section['color'] as Color;

        return _buildSectionCard(
          context,
          title,
          progressData[key] ?? 0.0,
          icon,
          color,
          () => onSectionTap(key),
        );
      },
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    double progress,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ProgressCard(
      title: title,
      progress: progress,
      icon: icon,
      color: color,
      onTap: onTap,
      isCircular: true,
    );
  }
}
