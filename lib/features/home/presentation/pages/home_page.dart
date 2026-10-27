import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'browse_page.dart';
import 'movie_details_page.dart';
import 'search_page.dart';
import '../viewmodels/movies_factory.dart';
import '../viewmodels/movies_view_model.dart';
import '../widgets/movie_poster_grid.dart';

const _bg = Color(0xFF101111);
const _panel = Color(0xFF292B2A);
const _yellow = Color(0xFFFFC400);

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  final _viewModel = createMoviesViewModel();
  @override
  void initState() {
    super.initState();
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  void _open(Movie movie) => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => MovieDetailsPage(movie: movie)),
  );

  @override
  Widget build(BuildContext context) {
    final screens = [
      BlocBuilder<MoviesViewModel, MoviesState>(
        bloc: _viewModel,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _yellow),
            );
          }
          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Could not load movies. Check your connection.',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () => _viewModel.load(),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }
          if (state.movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return _HomeContent(
            open: _open,
            movies: state.movies,
            onBrowse: () => setState(() => _tab = 2),
          );
        },
      ),
      const SearchPage(),
      const BrowsePage(),
      const ProfilePage(),
    ];
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: IndexedStack(index: _tab, children: screens),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 57,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          decoration: BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Nav(
                icon: Icons.home_rounded,
                active: _tab == 0,
                tap: () => setState(() => _tab = 0),
              ),
              _Nav(
                icon: Icons.search_rounded,
                active: _tab == 1,
                tap: () => setState(() => _tab = 1),
              ),
              _Nav(
                icon: Icons.grid_view_rounded,
                active: _tab == 2,
                tap: () => setState(() => _tab = 2),
              ),
              _Nav(
                icon: Icons.account_circle_rounded,
                active: _tab == 3,
                tap: () => setState(() => _tab = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.open,
    required this.movies,
    required this.onBrowse,
  });
  final ValueChanged<Movie> open;
  final List<Movie> movies;
  final VoidCallback onBrowse;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 390,
          child: Stack(
            children: [
              Positioned.fill(
                child: MovieArtwork(
                  path: movies[0].backgroundPath ?? movies[0].posterPath,
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x11000000), _bg],
                      stops: [.45, 1],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 18,
                left: 0,
                right: 0,
                child: Text(
                  'Available Now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'cursive',
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length < 3 ? movies.length : 3,
                    separatorBuilder: (_, _) => const SizedBox(width: 13),
                    itemBuilder: (_, index) => _Poster(
                      movie: movies[index],
                      large: index == 1,
                      open: open,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(13, 0, 13, 4),
          child: Text(
            'Watch New',
            style: TextStyle(
              color: Colors.white,
              fontSize: 39,
              fontWeight: FontWeight.w700,
              fontFamily: 'cursive',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: [
              const Text(
                'Latest Movies',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Spacer(),
              TextButton(
                onPressed: onBrowse,
                child: const Text(
                  'See More ›',
                  style: TextStyle(color: _yellow, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, index) =>
                _Poster(movie: movies[index], large: false, open: open),
          ),
        ),
      ],
    ),
  );
}

class _Poster extends StatelessWidget {
  const _Poster({required this.movie, required this.large, required this.open});
  final Movie movie;
  final bool large;
  final ValueChanged<Movie> open;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => open(movie),
    child: SizedBox(
      width: large ? 169 : 103,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MovieArtwork(path: movie.posterPath),
            Positioned(top: 8, left: 7, child: _Rating(rating: movie.rating)),
          ],
        ),
      ),
    ),
  );
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating});
  final double? rating;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xE6262928),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rating?.toStringAsFixed(1) ?? '—',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.star_rounded, color: _yellow, size: 14),
      ],
    ),
  );
}

class _Nav extends StatelessWidget {
  const _Nav({required this.icon, required this.active, required this.tap});
  final IconData icon;
  final bool active;
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: tap,
    icon: Icon(icon, color: active ? _yellow : Colors.white, size: 23),
  );
}
