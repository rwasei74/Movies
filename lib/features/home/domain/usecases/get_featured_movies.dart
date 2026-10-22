import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetFeaturedMovies {
  const GetFeaturedMovies(this._repository);
  final MoviesRepository _repository;
  Future<List<Movie>> call() => _repository.getFeaturedMovies();
}
