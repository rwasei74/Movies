import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetMovies {
  const GetMovies(this.repository);
  final MoviesRepository repository;
  Future<List<Movie>> call({String? query, String? genre}) =>
      repository.getMovies(query: query, genre: genre);
  List<Movie>? lastSearchResults() => repository.getLastSearchResults();
}
