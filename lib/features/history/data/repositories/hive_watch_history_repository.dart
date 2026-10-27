import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../home/data/models/movie_model.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/repositories/watch_history_repository.dart';

class HiveWatchHistoryRepository implements WatchHistoryRepository {
  HiveWatchHistoryRepository(this._box);
  final Box<dynamic> _box;
  static const _key = 'watch_history_v1';
  static const _limit = 50;

  @override
  List<Movie> getHistory() {
    final value = _box.get(_key);
    if (value is! List) return const [];
    try {
      return value.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        map['torrents'] = (map['torrents'] as List? ?? const [])
            .map((torrent) => Map<String, dynamic>.from(torrent as Map))
            .toList();
        return MovieModel.fromJson(map);
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> add(Movie movie) {
    final history = getHistory().where((item) => item.id != movie.id).toList();
    history.insert(0, movie);
    return _box.put(_key, history.take(_limit).map(_encode).toList());
  }

  Map<String, dynamic> _encode(Movie movie) => {
    'id': movie.id,
    'title': movie.title,
    'medium_cover_image': movie.posterPath,
    'background_image_original': movie.backgroundPath,
    'year': movie.year,
    'rating': movie.rating,
    'runtime': movie.runtime,
    'summary': movie.summary,
    'genres': movie.genres,
    'torrents': movie.torrents
        .map(
          (torrent) => {
            'hash': torrent.hash,
            'quality': torrent.quality,
            'size': torrent.size,
            'seeds': torrent.seeds,
          },
        )
        .toList(),
  };
}
