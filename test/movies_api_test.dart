import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movies_app/features/home/data/datasources/movies_remote_data_source.dart';
import 'package:movies_app/features/home/data/models/movie_model.dart';

void main() {
  test('extracts valid torrent versions and constructs magnet links', () {
    const hash = '0123456789abcdef0123456789abcdef01234567';
    final movie = MovieModel.fromJson({
      'id': 1,
      'title': 'Example',
      'torrents': [
        {'hash': hash, 'quality': '720p', 'size': '500 MB', 'seeds': 12},
        {'hash': 'invalid', 'quality': '1080p'},
      ],
    });
    expect(movie.torrents, hasLength(1));
    expect(movie.torrents.single.quality, '720p');
    expect(
      movie.torrents.single.magnet.queryParameters['xt'],
      'urn:btih:$hash',
    );
  });
  test(
    'maps YTS movie metadata and sends search and genre parameters',
    () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/v2/list_movies.json');
        expect(request.url.queryParameters['query_term'], 'Doctor Strange');
        expect(request.url.queryParameters['genre'], 'Action');
        return http.Response(
          jsonEncode({
            'status': 'ok',
            'data': {
              'movies': [
                {
                  'id': 12,
                  'title': 'Doctor Strange',
                  'year': 2022,
                  'rating': 7.5,
                  'runtime': 126,
                  'genres': ['Action'],
                  'summary': 'A movie',
                  'medium_cover_image': 'https://example.com/poster.jpg',
                },
              ],
            },
          }),
          200,
        );
      });
      final source = YtsMoviesRemoteDataSource(client);
      final movies = await source.getMovies(
        query: ' Doctor Strange ',
        genre: 'Action',
      );
      expect(movies.single.id, '12');
      expect(movies.single.posterPath, 'https://example.com/poster.jpg');
      expect(movies.single.year, 2022);
      expect(movies.single.rating, 7.5);
      expect(movies.single.runtime, 126);
      expect(movies.single.genres, ['Action']);
      client.close();
    },
  );

  test('returns an empty list when YTS has no matches', () async {
    final client = MockClient(
      (_) async =>
          http.Response('{"status":"ok","data":{"movie_count":0}}', 200),
    );
    expect(
      await YtsMoviesRemoteDataSource(client).getMovies(query: 'none'),
      isEmpty,
    );
    client.close();
  });

  test('reports an HTTP failure', () async {
    final client = MockClient((_) async => http.Response('Unavailable', 503));
    await expectLater(
      YtsMoviesRemoteDataSource(client).getMovies(),
      throwsException,
    );
    client.close();
  });
}
