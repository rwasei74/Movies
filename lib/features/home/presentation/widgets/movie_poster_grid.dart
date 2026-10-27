import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';

const catalogPosters = [
  'assets/images/467ec0bd3c2e949be39e10168ae20d3a4c9ffad7.jpg',
  'assets/images/62a91993882ebf7b39030a68c87492f1e5e33643 (1).jpg',
  'assets/images/62f0c6c02841c54f59afbbac6b00172109786308.jpg',
  'assets/images/85593b85e656364c771cd28e82a4747f0311ae29 (1).jpg',
  'assets/images/a8c73981364e3d0cf59c2d39a783a625ed5aa2b9.jpg',
];

class MoviePosterGrid extends StatelessWidget {
  const MoviePosterGrid({
    super.key,
    this.padding = const EdgeInsets.all(0),
    this.movies,
    this.onMovieTap,
  });
  final EdgeInsets padding;
  final List<Movie>? movies;
  final ValueChanged<Movie>? onMovieTap;

  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: padding,
    itemCount: movies?.length ?? 15,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 9,
      childAspectRatio: .63,
    ),
    itemBuilder: (_, index) => GestureDetector(
      onTap: movies == null || onMovieTap == null
          ? null
          : () => onMovieTap!(movies![index]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MovieArtwork(
              path: movies == null
                  ? catalogPosters[index % catalogPosters.length]
                  : movies![index].posterPath,
            ),
            Positioned(
              top: 5,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xD9262928),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movies == null
                          ? '7.7'
                          : (movies![index].rating?.toStringAsFixed(1) ?? '—'),
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    ),
                    const SizedBox(width: 1),
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFC400),
                      size: 11,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class MovieArtwork extends StatelessWidget {
  const MovieArtwork({super.key, required this.path});
  final String? path;
  @override
  Widget build(BuildContext context) {
    final value = path;
    if (value == null || value.isEmpty) {
      return const ColoredBox(
        color: Color(0xFF292B2A),
        child: Center(child: Icon(Icons.movie_outlined, color: Colors.white54)),
      );
    }
    if (!value.startsWith('http')) return Image.asset(value, fit: BoxFit.cover);
    return Image.network(
      value,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const ColoredBox(
        color: Color(0xFF292B2A),
        child: Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.white54),
        ),
      ),
    );
  }
}
