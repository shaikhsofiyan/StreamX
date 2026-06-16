import 'package:flutter/material.dart';
import '../../../shared/models/content.dart';
import '../../../shared/widgets/content_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../../core/theme/app_spacing.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<Content> items;
  final CardType cardType;
  final bool showProgressBar;

  const ContentRow({
    super.key,
    required this.title,
    required this.items,
    this.cardType = CardType.portrait,
    this.showProgressBar = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final double height = cardType == CardType.portrait ? 165.0 : 124.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: () {},
        ),
        SizedBox(
          height: height,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ContentCard(
                content: items[index],
                cardType: cardType,
                showProgressBar: showProgressBar,
                progress: showProgressBar ? 0.6 : 0.0, // Mock progress
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
