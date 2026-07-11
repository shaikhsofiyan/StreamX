import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/mock_data.dart';
import '../../shared/widgets/content_card.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  // Mocking the watchlist with some trending items
  final _watchlist = MockData.trendingNow.take(4).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My List', style: AppTypography.h2),
        backgroundColor: Colors.transparent,
        actions: [
          if (_watchlist.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.sort, color: Colors.white),
              onPressed: () {
                // Show sort options bottom sheet
              },
            ),
        ],
      ),
      body: _watchlist.isEmpty ? _buildEmptyState() : _buildPopulatedState(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 80, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.lg),
          const Text('Nothing here yet', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Movies and shows you add to\nyour list will appear here.',
            style: AppTypography.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton(
            onPressed: () => context.go('/home'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.textPrimary),
            ),
            child: const Text('Browse Content'),
          ),
        ],
      ),
    );
  }

  Widget _buildPopulatedState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        itemCount: _watchlist.length,
        itemBuilder: (context, index) {
          final content = _watchlist[index];
          return GestureDetector(
            onLongPress: () {
              // Show remove dialog
            },
            child: ContentCard(
              content: content,
              cardType: CardType.portrait,
            ),
          );
        },
      ),
    );
  }
}
