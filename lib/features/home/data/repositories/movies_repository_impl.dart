import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_data_source.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  const MoviesRepositoryImpl(this._remoteDataSource);
  final MoviesRemoteDataSource _remoteDataSource;
  @override
  Future<List<Movie>> getFeaturedMovies() =>
      _remoteDataSource.getFeaturedMovies();
}
