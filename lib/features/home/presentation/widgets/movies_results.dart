import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/movie_details_page.dart';
import '../viewmodels/movies_view_model.dart';
import 'movie_poster_grid.dart';

class MoviesResults extends StatelessWidget {
  const MoviesResults({
    super.key,
    required this.viewModel,
    required this.retry,
  });
  final MoviesViewModel viewModel;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MoviesViewModel, MoviesState>(
        bloc: viewModel,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC400)),
            );
          }
          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Could not load movies. Check your connection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(onPressed: retry, child: const Text('Try again')),
                ],
              ),
            );
          }
          if (state.movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies found.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return MoviePosterGrid(
            movies: state.movies,
            onMovieTap: (movie) => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MovieDetailsPage(movie: movie),
              ),
            ),
          );
        },
      );
}
