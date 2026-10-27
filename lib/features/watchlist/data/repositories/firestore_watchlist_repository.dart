import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';

class FirestoreWatchlistRepository implements WatchlistRepository {
  FirestoreWatchlistRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firestore.collection('users').doc(userId).collection('watchlist');

  @override
  Stream<List<Movie>> watchMovies(String userId) =>
      _collection(userId).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          return Movie(
            id: doc.id,
            title: data['title'] as String? ?? '',
            posterPath: data['posterPath'] as String?,
            backgroundPath: data['backgroundPath'] as String?,
            year: (data['year'] as num?)?.toInt(),
            rating: (data['rating'] as num?)?.toDouble(),
            runtime: (data['runtime'] as num?)?.toInt(),
            summary: data['summary'] as String?,
            genres: (data['genres'] as List<dynamic>? ?? const [])
                .whereType<String>()
                .toList(),
            torrents: (data['torrents'] as List<dynamic>? ?? const [])
                .whereType<Map<String, dynamic>>()
                .map(
                  (item) => MovieTorrent(
                    hash: item['hash'] as String? ?? '',
                    quality: item['quality'] as String? ?? '',
                    size: item['size'] as String?,
                    seeds: (item['seeds'] as num?)?.toInt(),
                  ),
                )
                .where((torrent) => torrent.hash.isNotEmpty)
                .toList(),
          );
        }).toList(),
      );

  @override
  Future<void> add(String userId, Movie movie) =>
      _collection(userId).doc(movie.id).set({
        'title': movie.title,
        'posterPath': movie.posterPath,
        'backgroundPath': movie.backgroundPath,
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
      });

  @override
  Future<void> remove(String userId, String movieId) =>
      _collection(userId).doc(movieId).delete();
}
