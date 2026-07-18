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

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      releaseYear: json['release_year'] as int?,
      durationMins: json['duration_mins'] as int?,
      ageRating: json['age_rating'] as String?,
      imdbScore: json['imdb_score'] != null 
          ? (json['imdb_score'] as num).toDouble() 
          : null,
      genres: List<String>.from(json['genres'] ?? []),
      thumbnailUrl: json['thumbnail_url'] as String? ?? 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=500',
      backdropUrl: json['backdrop_url'] as String?,
      logoUrl: json['logo_url'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      isPremium: json['is_premium'] as bool? ?? false,
    );
  }
}
