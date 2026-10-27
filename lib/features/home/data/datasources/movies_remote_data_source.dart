import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

abstract interface class MoviesRemoteDataSource {
  Future<List<MovieModel>> getFeaturedMovies();
  Future<List<MovieModel>> getMovies({String? query, String? genre});
}

class YtsMoviesRemoteDataSource implements MoviesRemoteDataSource {
  YtsMoviesRemoteDataSource(
    this._client, {
    this.baseUrl = 'https://yts.gg/api/v2',
  });
  final http.Client _client;
  final String baseUrl;

  @override
  Future<List<MovieModel>> getFeaturedMovies() => getMovies();

  @override
  Future<List<MovieModel>> getMovies({String? query, String? genre}) async {
    final params = <String, String>{
      'limit': '30',
      if (query != null && query.trim().isNotEmpty) 'query_term': query.trim(),
      if (genre != null && genre.isNotEmpty) 'genre': genre,
    };
    final uri = Uri.parse(
      '$baseUrl/list_movies.json',
    ).replace(queryParameters: params);
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('Movie service returned HTTP ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['status'] != 'ok') {
      throw Exception('Movie service returned an error');
    }
    final data = body['data'] as Map<String, dynamic>;
    final movies = data['movies'] as List<dynamic>? ?? [];
    return movies
        .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
