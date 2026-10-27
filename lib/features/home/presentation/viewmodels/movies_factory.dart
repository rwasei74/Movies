import 'package:http/http.dart' as http;
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../data/datasources/movies_local_data_source.dart';
import '../../data/datasources/movies_remote_data_source.dart';
import '../../data/repositories/movies_repository_impl.dart';
import '../../domain/usecases/get_movies.dart';
import 'movies_view_model.dart';

MoviesViewModel createMoviesViewModel() {
  final client = http.Client();
  return MoviesViewModel(
    GetMovies(
      MoviesRepositoryImpl(
        YtsMoviesRemoteDataSource(client),
        localDataSource: Hive.isBoxOpen('movie_cache')
            ? HiveMoviesLocalDataSource(Hive.box('movie_cache'))
            : null,
      ),
    ),
    onDispose: client.close,
  );
}
