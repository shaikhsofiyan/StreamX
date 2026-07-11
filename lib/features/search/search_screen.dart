import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/mock_data.dart';
import '../../shared/models/content.dart';
import '../../shared/widgets/content_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  
  // Static predefined genre colors based on SKILL.md
  final List<Map<String, dynamic>> _genres = [
    {'name': 'Action', 'colors': [const Color(0xFFB22222), const Color(0xFFFF4500)]},
    {'name': 'Comedy', 'colors': [const Color(0xFFDAA520), const Color(0xFFFFD700)]},
    {'name': 'Horror', 'colors': [const Color(0xFF1A1A2E), const Color(0xFF16213E)]},
    {'name': 'Romance', 'colors': [const Color(0xFFC71585), const Color(0xFFFF69B4)]},
    {'name': 'Sci-Fi', 'colors': [const Color(0xFF0F3460), const Color(0xFF533483)]},
    {'name': 'Documentary', 'colors': [const Color(0xFF1B4332), const Color(0xFF40916C)]},
    {'name': 'Animation', 'colors': [const Color(0xFFF77F00), const Color(0xFFFCBF49)]},
    {'name': 'Thriller', 'colors': [const Color(0xFF212529), const Color(0xFF495057)]},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter mock data for search results
    final List<Content> searchResults = _query.isEmpty
        ? []
        : [...MockData.trendingNow, ...MockData.featuredContent]
            .where((content) => content.title.toLowerCase().contains(_query))
            .toSet()
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Search Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                controller: _searchController,
                style: AppTypography.body.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  hintText: 'Search for a movie, show, genre, etc.',
                  hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : const Icon(Icons.mic, color: AppColors.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            
            Expanded(
              child: _query.isEmpty ? _buildEmptyState() : _buildResultsState(searchResults),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          const Text('Top Searches', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Just showing 5 for top searches
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final content = MockData.trendingNow[index];
              return InkWell(
                onTap: () => context.push('/detail/${content.id}'),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.md),
                          bottomLeft: Radius.circular(AppRadius.md),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: content.backdropUrl ?? content.thumbnailUrl,
                          width: 120,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          content.title,
                          style: AppTypography.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Icon(Icons.play_circle_outline, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          const Text('Browse by Genre', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.md),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: _genres.length,
            itemBuilder: (context, index) {
              final genre = _genres[index];
              final colors = genre['colors'] as List<Color>;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  genre['name'],
                  style: AppTypography.label.copyWith(
                    shadows: [
                      const BoxShadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildResultsState(List<Content> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              "No results for '$_query'",
              style: AppTypography.h2,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              "Try: Action, Drama, 2024...",
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Results for '$_query'", style: AppTypography.h2),
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
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ContentCard(
                content: results[index],
                cardType: CardType.portrait,
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
