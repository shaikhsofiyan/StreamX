class Content {
  final String id;
  final String title;
  final String? description;
  final String type; // 'movie' or 'series'
  final int? releaseYear;
  final int? durationMins;
  final String? ageRating;
  final double? imdbScore;
  final List<String> genres;
  final String thumbnailUrl;
  final String? backdropUrl;
  final String? logoUrl;
  final bool isFeatured;
  final bool isPremium;

  Content({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.releaseYear,
    this.durationMins,
    this.ageRating,
    this.imdbScore,
    required this.genres,
    required this.thumbnailUrl,
    this.backdropUrl,
    this.logoUrl,
    this.isFeatured = false,
    this.isPremium = false,
  });
}
