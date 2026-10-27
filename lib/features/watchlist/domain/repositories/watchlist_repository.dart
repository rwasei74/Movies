import '../../../home/domain/entities/movie.dart';

abstract interface class WatchlistRepository {
  Stream<List<Movie>> watchMovies(String userId);
  Future<void> add(String userId, Movie movie);
  Future<void> remove(String userId, String movieId);
}
