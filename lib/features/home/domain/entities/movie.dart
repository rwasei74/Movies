class Movie {
  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backgroundPath,
    this.year,
    this.rating,
    this.runtime,
    this.summary,
    this.genres = const [],
    this.torrents = const [],
  });
  final String id;
  final String title;
  final String? posterPath;
  final String? backgroundPath;
  final int? year;
  final double? rating;
  final int? runtime;
  final String? summary;
  final List<String> genres;
  final List<MovieTorrent> torrents;
}

class MovieTorrent {
  const MovieTorrent({
    required this.hash,
    required this.quality,
    this.size,
    this.seeds,
  });
  final String hash;
  final String quality;
  final String? size;
  final int? seeds;

  Uri get magnet =>
      Uri(scheme: 'magnet', queryParameters: {'xt': 'urn:btih:$hash'});
}
