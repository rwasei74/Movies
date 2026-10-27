import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_data_source.dart';
import '../datasources/movies_local_data_source.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  const MoviesRepositoryImpl(this._remoteDataSource, {this.localDataSource});
  final MoviesRemoteDataSource _remoteDataSource;
  final MoviesLocalDataSource? localDataSource;
  @override
  Future<List<Movie>> getFeaturedMovies() => getMovies();

  @override
  Future<List<Movie>> getMovies({String? query, String? genre}) async {
    final featured =
        (query == null || query.trim().isEmpty) &&
        (genre == null || genre.isEmpty);
    final normalizedQuery = query?.trim();
    final cache = localDataSource;
    try {
      final movies = await _remoteDataSource.getMovies(
        query: query,
        genre: genre,
      );
      if (featured && cache != null) {
        try {
          await cache.saveFeatured(movies);
        } catch (_) {
          /* The network result remains usable. */
        }
      }
      if (!featured &&
          normalizedQuery != null &&
          normalizedQuery.isNotEmpty &&
          cache != null) {
        try {
          await cache.saveSearchResults(normalizedQuery, movies);
        } catch (_) {
          /* The network result remains usable. */
        }
      }
      return movies;
    } catch (_) {
      if (featured && cache != null) {
        try {
          final cached = cache.readFeatured();
          if (cached != null) return cached;
        } catch (_) {
          /* Report the original network failure. */
        }
      }
      if (!featured &&
          normalizedQuery != null &&
          normalizedQuery.isNotEmpty &&
          cache != null) {
        try {
          final cached = cache.readSearchResults(normalizedQuery);
          if (cached != null) return cached;
        } catch (_) {
          /* Report the original network failure. */
        }
      }
      rethrow;
    }
  }

  @override
  List<Movie>? getLastSearchResults() =>
      localDataSource?.readLastSearchResults();
}
