import '../models/movie_model.dart';

abstract interface class MoviesRemoteDataSource {
  Future<List<MovieModel>> getFeaturedMovies();
}
