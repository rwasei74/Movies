import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/home/data/datasources/movies_local_data_source.dart';
import 'package:movies_app/features/home/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/features/home/data/models/movie_model.dart';
import 'package:movies_app/features/home/data/repositories/movies_repository_impl.dart';
import 'package:movies_app/features/home/domain/entities/movie.dart';

class FakeRemoteDataSource implements MoviesRemoteDataSource {
  FakeRemoteDataSource({this.movies = const [], this.shouldFail = false});
  final List<MovieModel> movies;
  final bool shouldFail;
  @override
  Future<List<MovieModel>> getFeaturedMovies() => getMovies();
  @override
  Future<List<MovieModel>> getMovies({String? query, String? genre}) async {
    if (shouldFail) throw Exception('offline');
    return movies;
  }
}

class MemoryMoviesCache implements MoviesLocalDataSource {
  List<Movie>? saved;
  @override
  List<Movie>? readFeatured() => saved;
  @override
  Future<void> saveFeatured(List<Movie> movies) async => saved = movies;
  @override
  Future<void> saveSearchResults(String query, List<Movie> movies) async {
    saved = movies;
  }

  @override
  List<Movie>? readLastSearchResults() => saved;
  @override
  List<Movie>? readSearchResults(String query) => saved;
}

void main() {
  test(
    'saves the featured catalogue locally after a successful request',
    () async {
      final cache = MemoryMoviesCache();
      final movie = MovieModel(id: '1', title: 'Saved movie');
      final repository = MoviesRepositoryImpl(
        FakeRemoteDataSource(movies: [movie]),
        localDataSource: cache,
      );

      expect(await repository.getMovies(), [movie]);
      expect(cache.saved, [movie]);
    },
  );

  test(
    'uses cached featured movies when the connection is unavailable',
    () async {
      final cached = MovieModel(id: '2', title: 'Offline movie');
      final cache = MemoryMoviesCache()..saved = [cached];
      final repository = MoviesRepositoryImpl(
        FakeRemoteDataSource(shouldFail: true),
        localDataSource: cache,
      );

      expect(await repository.getMovies(), [cached]);
    },
  );

  test('keeps the most recent search results locally', () async {
    final cache = MemoryMoviesCache();
    final movie = MovieModel(id: '3', title: 'Recent result');
    final repository = MoviesRepositoryImpl(
      FakeRemoteDataSource(movies: [movie]),
      localDataSource: cache,
    );

    await repository.getMovies(query: 'recent');
    expect(repository.getLastSearchResults(), [movie]);
  });
}
