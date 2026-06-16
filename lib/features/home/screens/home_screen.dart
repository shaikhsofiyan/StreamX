import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/mock_data.dart';
import '../../../shared/widgets/content_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/content_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 0.0, // No expanded area, purely pinned with dynamic bg
            toolbarHeight: kToolbarHeight + 40, // Height for logo + chips
            backgroundColor: _scrollOffset > 50 
                ? AppColors.background.withOpacity((_scrollOffset / 350).clamp(0, 1).toDouble()) 
                : Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STREAMX',
                  style: AppTypography.display.copyWith(color: AppColors.brand, fontSize: 28),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
                      onPressed: () {},
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=100&auto=format&fit=crop'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: SizedBox(
                  height: 32,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Movies'),
                      _buildFilterChip('Series'),
                      _buildFilterChip('Anime'),
                      _buildFilterChip('Documentaries'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Translate the HeroBanner up so it goes behind the transparent AppBar
                Transform.translate(
                  offset: Offset(0, -(kToolbarHeight + 40 + MediaQuery.paddingOf(context).top)),
                  child: HeroBanner(featuredContent: MockData.featuredContent),
                ),
                // Adjust spacing back
                Transform.translate(
                  offset: Offset(0, -(kToolbarHeight + 40 + MediaQuery.paddingOf(context).top)),
                  child: Column(
                    children: [
                      ContentRow(
                        title: 'Continue Watching for You',
                        items: MockData.continueWatching,
                        cardType: CardType.wide,
                        showProgressBar: true,
                      ),
                      ContentRow(
                        title: 'Trending Now',
                        items: MockData.trendingNow,
                        cardType: CardType.portrait,
                      ),
                      ContentRow(
                        title: 'New Releases',
                        items: MockData.trendingNow.reversed.toList(),
                        cardType: CardType.portrait,
                      ),
                    ],
                  ),
                ),
                // Add some padding at the bottom for safety
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
