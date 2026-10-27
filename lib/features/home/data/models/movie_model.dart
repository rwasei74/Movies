import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    super.posterPath,
    super.backgroundPath,
    super.year,
    super.rating,
    super.runtime,
    super.summary,
    super.genres,
    super.torrents,
  });
  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'].toString(),
    title: json['title'] as String,
    posterPath: json['medium_cover_image'] as String?,
    backgroundPath: json['background_image_original'] as String?,
    year: (json['year'] as num?)?.toInt(),
    rating: (json['rating'] as num?)?.toDouble(),
    runtime: (json['runtime'] as num?)?.toInt(),
    summary: json['summary'] as String?,
    genres:
        (json['genres'] as List<dynamic>?)?.whereType<String>().toList() ??
        const [],
    torrents: (json['torrents'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .where(
          (item) => RegExp(
            r'^[a-fA-F0-9]{40}$',
          ).hasMatch(item['hash'] as String? ?? ''),
        )
        .map(
          (item) => MovieTorrent(
            hash: item['hash'] as String,
            quality: item['quality'] as String? ?? 'Unknown',
            size: item['size'] as String?,
            seeds: (item['seeds'] as num?)?.toInt(),
          ),
        )
        .toList(),
  );
}
