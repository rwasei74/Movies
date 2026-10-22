import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({required super.id, required super.title, super.posterPath});
  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'].toString(),
    title: json['title'] as String,
    posterPath: json['poster_path'] as String?,
  );
}
