import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

enum CardType { portrait, wide }

class ContentCard extends StatelessWidget {
  final Content content;
  final CardType cardType;
  final bool showProgressBar;
  final double progress; // 0.0 to 1.0

  const ContentCard({
    super.key,
    required this.content,
    this.cardType = CardType.portrait,
    this.showProgressBar = false,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = cardType == CardType.portrait;
    final double width = isPortrait ? 110.0 : 220.0;
    final double height = isPortrait ? 165.0 : 124.0;
    final String imageUrl = isPortrait ? content.thumbnailUrl : (content.backdropUrl ?? content.thumbnailUrl);

    return GestureDetector(
      onTap: () => context.push('/detail/${content.id}'),
      child: Container(
        width: width,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(color: Colors.black),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceElevated,
                child: const Center(child: Icon(Icons.error_outline, color: AppColors.textMuted)),
              ),
            ),
          ),
          if (showProgressBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.lg)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.lg)),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand),
                  ),
                ),
              ),
            ),
          if (!isPortrait && content.durationMins != null)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${content.durationMins! ~/ 60}h ${content.durationMins! % 60}m',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
}
