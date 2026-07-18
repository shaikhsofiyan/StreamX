import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/providers/content_provider.dart';
import '../../../shared/widgets/content_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/content_row.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

  Future<void> _refreshData() async {
    // Invalidate the providers to fetch fresh data from API
    ref.invalidate(featuredContentProvider);
    ref.invalidate(trendingContentProvider);
    ref.invalidate(allContentProvider);
  }

  @override
  Widget build(BuildContext context) {
    final featuredAsyncValue = ref.watch(featuredContentProvider);
    final trendingAsyncValue = ref.watch(trendingContentProvider);
    final allAsyncValue = ref.watch(allContentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.brand,
        backgroundColor: AppColors.surfaceElevated,
        onRefresh: _refreshData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 0.0,
              toolbarHeight: kToolbarHeight + 40,
              backgroundColor: _scrollOffset > 50 
                  ? AppColors.background.withValues(alpha: (_scrollOffset / 350).clamp(0, 1).toDouble()) 
                  : Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
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
                  // Hero Banner Area (Async)
                  featuredAsyncValue.when(
                    data: (featuredList) {
                      if (featuredList.isEmpty) return const SizedBox.shrink();
                      return Transform.translate(
                        offset: Offset(0, -(kToolbarHeight + 40 + MediaQuery.paddingOf(context).top)),
                        child: HeroBanner(featuredContent: featuredList),
                      );
                    },
                    loading: () => _buildHeroShimmer(),
                    error: (err, stack) => _buildErrorState('Failed to load featured banner'),
                  ),
                  
                  // Content Rows Area (Async)
                  Transform.translate(
                    offset: Offset(0, -(kToolbarHeight + 40 + MediaQuery.paddingOf(context).top)),
                    child: Column(
                      children: [
                        trendingAsyncValue.when(
                          data: (trendingList) => ContentRow(
                            title: 'Trending Now',
                            items: trendingList,
                            cardType: CardType.portrait,
                          ),
                          loading: () => _buildRowShimmer(160, 110),
                          error: (err, stack) => _buildErrorState('Failed to load trending content'),
                        ),
                        
                        allAsyncValue.when(
                          data: (allList) => ContentRow(
                            title: 'Explore Movies & Series',
                            items: allList,
                            cardType: CardType.portrait,
                          ),
                          loading: () => _buildRowShimmer(160, 110),
                          error: (err, stack) => _buildErrorState('Failed to load explore content'),
                        ),
                        
                        // Fake wide rows for Continue Watching UI polish
                        trendingAsyncValue.when(
                          data: (list) {
                            if (list.length < 2) return const SizedBox.shrink();
                            return ContentRow(
                              title: 'Continue Watching for You',
                              items: list.take(2).toList(),
                              cardType: CardType.wide,
                              showProgressBar: true,
                            );
                          },
                          loading: () => _buildRowShimmer(120, 220),
                          error: (err, stack) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildHeroShimmer() {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Transform.translate(
        offset: Offset(0, -(kToolbarHeight + 40 + MediaQuery.paddingOf(context).top)),
        child: Container(
          height: screenHeight * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRowShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.sm),
            child: Container(
              width: 150,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
          SizedBox(
            height: height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
              itemCount: 4,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 36),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
