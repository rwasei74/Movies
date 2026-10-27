import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/movie_model.dart';
import '../../domain/entities/movie.dart';

abstract interface class MoviesLocalDataSource {
  Future<void> saveFeatured(List<Movie> movies);
  List<Movie>? readFeatured();
  Future<void> saveSearchResults(String query, List<Movie> movies);
  List<Movie>? readLastSearchResults();
  List<Movie>? readSearchResults(String query);
}

class HiveMoviesLocalDataSource implements MoviesLocalDataSource {
  HiveMoviesLocalDataSource(this._box);
  final Box<dynamic> _box;
  static const _key = 'featured_movies_v1';
  static const _lastSearchKey = 'last_search_v1';

  @override
  Future<void> saveFeatured(List<Movie> movies) => _box.put(
    _key,
    movies
        .map(
          (movie) => {
            'id': movie.id,
            'title': movie.title,
            'medium_cover_image': movie.posterPath,
            'background_image_original': movie.backgroundPath,
            'year': movie.year,
            'rating': movie.rating,
            'runtime': movie.runtime,
            'summary': movie.summary,
            'genres': movie.genres,
            'torrents': movie.torrents
                .map(
                  (t) => {
                    'hash': t.hash,
                    'quality': t.quality,
                    'size': t.size,
                    'seeds': t.seeds,
                  },
                )
                .toList(),
          },
        )
        .toList(),
  );

  @override
  List<Movie>? readFeatured() {
    return _readMovies(_box.get(_key));
  }

  @override
  Future<void> saveSearchResults(String query, List<Movie> movies) => _box.put(
    _lastSearchKey,
    {'query': query, 'movies': _encodeMovies(movies)},
  );

  @override
  List<Movie>? readLastSearchResults() {
    final value = _box.get(_lastSearchKey);
    return value is Map ? _readMovies(value['movies']) : null;
  }

  @override
  List<Movie>? readSearchResults(String query) {
    final value = _box.get(_lastSearchKey);
    if (value is! Map || value['query'] != query) return null;
    return _readMovies(value['movies']);
  }

  List<Movie>? _readMovies(dynamic value) {
    if (value is! List) return null;
    try {
      return value.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        map['torrents'] = (map['torrents'] as List? ?? const [])
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
        return MovieModel.fromJson(map);
      }).toList();
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> _encodeMovies(List<Movie> movies) => movies
      .map(
        (movie) => {
          'id': movie.id,
          'title': movie.title,
          'medium_cover_image': movie.posterPath,
          'background_image_original': movie.backgroundPath,
          'year': movie.year,
          'rating': movie.rating,
          'runtime': movie.runtime,
          'summary': movie.summary,
          'genres': movie.genres,
          'torrents': movie.torrents
              .map(
                (t) => {
                  'hash': t.hash,
                  'quality': t.quality,
                  'size': t.size,
                  'seeds': t.seeds,
                },
              )
              .toList(),
        },
      )
      .toList();
}
