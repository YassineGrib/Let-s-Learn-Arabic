import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_theme.dart';

class SkeletonLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.isDarkMode;
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;
  final bool hasIcon;
  final bool hasTitle;
  final bool hasSubtitle;

  const SkeletonCard({
    super.key,
    this.height = 120,
    this.margin,
    this.hasIcon = true,
    this.hasTitle = true,
    this.hasSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppTheme.isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasIcon)
            SkeletonLoading(
              width: 60,
              height: 60,
              borderRadius: 30,
              margin: const EdgeInsets.only(bottom: 16),
            ),
          if (hasTitle)
            SkeletonLoading(
              width: 100,
              height: 16,
              margin: const EdgeInsets.only(bottom: 8),
            ),
          if (hasSubtitle)
            SkeletonLoading(
              width: 80,
              height: 12,
            ),
        ],
      ),
    );
  }
}

class SkeletonGridView extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;

  const SkeletonGridView({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 8,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const SkeletonCard();
      },
    );
  }
}

class SkeletonListView extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final bool hasAvatar;
  final bool hasSubtitle;

  const SkeletonListView({
    super.key,
    this.itemCount = 10,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.all(16.0),
    this.hasAvatar = true,
    this.hasSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: itemHeight,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (hasAvatar) ...[
                SkeletonLoading(
                  width: 48,
                  height: 48,
                  borderRadius: 24,
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonLoading(
                      width: double.infinity,
                      height: 16,
                      margin: const EdgeInsets.only(bottom: 8),
                    ),
                    if (hasSubtitle)
                      SkeletonLoading(
                        width: 120,
                        height: 12,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
