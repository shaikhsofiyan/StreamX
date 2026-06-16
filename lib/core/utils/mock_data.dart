import '../../shared/models/content.dart';

class MockData {
  static final List<Content> featuredContent = [
    Content(
      id: 'f1',
      title: 'INTERSTELLAR',
      description: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      type: 'movie',
      releaseYear: 2014,
      durationMins: 169,
      ageRating: 'U/A 13+',
      imdbScore: 8.7,
      genres: ['Sci-Fi', 'Adventure', 'Drama'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=600&auto=format&fit=crop', // 2:3 placeholder
      backdropUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=1200&auto=format&fit=crop', // 16:9 placeholder
      isFeatured: true,
    ),
    Content(
      id: 'f2',
      title: 'STRANGER THINGS',
      description: 'When a young boy disappears, his mother, a police chief and his friends must confront terrifying supernatural forces.',
      type: 'series',
      releaseYear: 2016,
      ageRating: 'U/A 16+',
      imdbScore: 8.7,
      genres: ['Sci-Fi', 'Horror', 'Drama'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1621644754890-a231f868d407?q=80&w=600&auto=format&fit=crop',
      backdropUrl: 'https://images.unsplash.com/photo-1618666012174-83b441c0bc76?q=80&w=1200&auto=format&fit=crop',
      isFeatured: true,
    ),
    Content(
      id: 'f3',
      title: 'THE DARK KNIGHT',
      description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability.',
      type: 'movie',
      releaseYear: 2008,
      durationMins: 152,
      ageRating: 'U/A 16+',
      imdbScore: 9.0,
      genres: ['Action', 'Crime', 'Drama'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?q=80&w=600&auto=format&fit=crop',
      backdropUrl: 'https://images.unsplash.com/photo-1478479405421-ce83c92fb3ba?q=80&w=1200&auto=format&fit=crop',
      isFeatured: true,
    ),
  ];

  static final List<Content> trendingNow = [
    Content(
      id: 't1',
      title: 'Dune',
      type: 'movie',
      genres: ['Sci-Fi', 'Action'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1542442828-287217bfb09f?q=80&w=400&auto=format&fit=crop',
    ),
    Content(
      id: 't2',
      title: 'Inception',
      type: 'movie',
      genres: ['Action', 'Sci-Fi'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1582214400551-0bf8e390c50f?q=80&w=400&auto=format&fit=crop',
    ),
    Content(
      id: 't3',
      title: 'Breaking Bad',
      type: 'series',
      genres: ['Crime', 'Drama'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1560088032-1b1e6ce6eb52?q=80&w=400&auto=format&fit=crop',
    ),
    Content(
      id: 't4',
      title: 'The Matrix',
      type: 'movie',
      genres: ['Sci-Fi', 'Action'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?q=80&w=400&auto=format&fit=crop',
    ),
    Content(
      id: 't5',
      title: 'Cyberpunk',
      type: 'series',
      genres: ['Sci-Fi', 'Anime'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1605806616949-1e87b487bc2a?q=80&w=400&auto=format&fit=crop',
    ),
  ];

  static final List<Content> continueWatching = [
    Content(
      id: 'c1',
      title: 'Stranger Things',
      type: 'series',
      genres: ['Sci-Fi'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1621644754890-a231f868d407?q=80&w=600&auto=format&fit=crop',
      backdropUrl: 'https://images.unsplash.com/photo-1618666012174-83b441c0bc76?q=80&w=800&auto=format&fit=crop',
    ),
    Content(
      id: 'c2',
      title: 'Interstellar',
      type: 'movie',
      genres: ['Sci-Fi'],
      thumbnailUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=600&auto=format&fit=crop',
      backdropUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=800&auto=format&fit=crop',
    ),
  ];
}
