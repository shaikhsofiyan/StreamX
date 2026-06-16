import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/models/content.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class HeroBanner extends StatefulWidget {
  final List<Content> featuredContent;

  const HeroBanner({super.key, required this.featuredContent});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && widget.featuredContent.isNotEmpty) {
        int nextPage = _currentPage + 1;
        if (nextPage >= widget.featuredContent.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredContent.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onPanDown: (_) => _timer?.cancel(),
      onPanCancel: _startAutoScroll,
      onPanEnd: (_) => _startAutoScroll(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: widget.featuredContent.length,
              itemBuilder: (context, index) {
                final content = widget.featuredContent[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: content.backdropUrl ?? content.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: AppColors.shimmerBase),
                      errorWidget: (context, url, error) => Container(color: AppColors.surfaceElevated),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.background.withOpacity(1.0),
                            AppColors.background.withOpacity(0.6),
                            AppColors.background.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: AppSpacing.xxl,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            content.title,
                            style: AppTypography.display,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: content.genres.map((genre) {
                              final isLast = content.genres.last == genre;
                              return Row(
                                children: [
                                  Text(
                                    genre,
                                    style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
                                  ),
                                  if (!isLast)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                                      child: Icon(Icons.circle, size: 4, color: AppColors.brand),
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add, color: AppColors.textPrimary),
                                label: const Text('My List', style: TextStyle(color: AppColors.textPrimary)),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              ElevatedButton.icon(
                                onPressed: () => context.push('/player/${content.id}'),
                                icon: const Icon(Icons.play_arrow, color: Colors.black),
                                label: const Text('Play', style: TextStyle(color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              OutlinedButton.icon(
                                onPressed: () => context.push('/detail/${content.id}'),
                                icon: const Icon(Icons.info_outline, color: AppColors.textPrimary),
                                label: const Text('Info', style: TextStyle(color: AppColors.textPrimary)),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: AppSpacing.sm,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.featuredContent.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? AppColors.brand : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
