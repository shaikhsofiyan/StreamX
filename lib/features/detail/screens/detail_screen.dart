import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/mock_data.dart';
import '../../../shared/models/content.dart';
import '../../../shared/widgets/content_card.dart';

class DetailScreen extends StatefulWidget {
  final String contentId;

  const DetailScreen({super.key, required this.contentId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Content content;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    // Simulate fetching content by ID
    content = MockData.featuredContent.firstWhere(
      (c) => c.id == widget.contentId,
      orElse: () => MockData.trendingNow.firstWhere(
        (c) => c.id == widget.contentId,
        orElse: () => MockData.featuredContent.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.cast, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: content.backdropUrl ?? content.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.background,
                          AppColors.background.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    content.title,
                    style: AppTypography.display.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Metadata Row
                  Row(
                    children: [
                      if (content.imdbScore != null) ...[
                        Text(
                          '${(content.imdbScore! * 10).toInt()}% Match',
                          style: AppTypography.label.copyWith(color: AppColors.success),
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      if (content.releaseYear != null) ...[
                        Text(
                          content.releaseYear.toString(),
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      if (content.ageRating != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            content.ageRating!,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      if (content.durationMins != null)
                        Text(
                          '${content.durationMins! ~/ 60}h ${content.durationMins! % 60}m',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                        ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textMuted),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Text(
                          'HD',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Play Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/player/${content.id}'),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Download Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, color: AppColors.textPrimary),
                      label: const Text('Download'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Description
                  if (content.description != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.description!,
                            style: AppTypography.body.copyWith(height: 1.5),
                            maxLines: _isDescriptionExpanded ? null : 3,
                            overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          ),
                          if (!_isDescriptionExpanded)
                            Text(
                              'More',
                              style: AppTypography.label.copyWith(color: AppColors.textMuted),
                            ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Action Row (My List, Rate, Share)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionItem(Icons.add, 'My List'),
                      _buildActionItem(Icons.thumb_up_alt_outlined, 'Rate'),
                      _buildActionItem(Icons.share, 'Share'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // More Like This
                  Text(
                    'More Like This',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemCount: MockData.trendingNow.length,
                    itemBuilder: (context, index) {
                      return ContentCard(
                        content: MockData.trendingNow[index],
                        cardType: CardType.portrait,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 28),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
