import '../../../home/domain/entities/movie.dart';

abstract interface class WatchHistoryRepository {
  List<Movie> getHistory();
  Future<void> add(Movie movie);
}
