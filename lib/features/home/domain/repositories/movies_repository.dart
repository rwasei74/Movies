import '../entities/movie.dart';

abstract interface class MoviesRepository {
  Future<List<Movie>> getFeaturedMovies();
  Future<List<Movie>> getMovies({String? query, String? genre});
  List<Movie>? getLastSearchResults();
}
