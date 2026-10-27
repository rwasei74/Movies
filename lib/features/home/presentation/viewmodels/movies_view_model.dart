import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies.dart';

class MoviesState {
  const MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.hasError = false,
  });
  final List<Movie> movies;
  final bool isLoading;
  final bool hasError;
}

class MoviesViewModel extends Cubit<MoviesState> {
  MoviesViewModel(this._getMovies, {this.onDispose})
    : super(const MoviesState());
  final GetMovies _getMovies;
  final VoidCallback? onDispose;
  List<Movie> get movies => state.movies;
  bool get isLoading => state.isLoading;
  bool get hasError => state.hasError;
  int _requestId = 0;

  Future<void> load({String? query, String? genre}) async {
    final request = ++_requestId;
    emit(MoviesState(movies: state.movies, isLoading: true));
    try {
      final result = await _getMovies(query: query, genre: genre);
      if (isClosed || request != _requestId) return;
      emit(MoviesState(movies: result));
    } catch (_) {
      if (isClosed || request != _requestId) return;
      emit(const MoviesState(hasError: true));
    } finally {
      if (!isClosed && request == _requestId && state.isLoading) {
        emit(MoviesState(movies: state.movies, hasError: state.hasError));
      }
    }
  }

  void loadLastSearch() {
    emit(MoviesState(movies: _getMovies.lastSearchResults() ?? const []));
  }

  @override
  Future<void> close() {
    onDispose?.call();
    return super.close();
  }
}
