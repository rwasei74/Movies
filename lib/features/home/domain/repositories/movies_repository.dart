import '../entities/movie.dart';

abstract interface class MoviesRepository {
  Future<List<Movie>> getFeaturedMovies();
}
