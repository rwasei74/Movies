import 'package:flutter/material.dart';

import '../viewmodels/movies_factory.dart';
import '../widgets/movies_results.dart';

const _yellow = Color(0xFFFFC400);

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final _viewModel = createMoviesViewModel();
  String _genre = 'Action';
  @override
  void initState() {
    super.initState();
    _viewModel.load(genre: _genre);
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 48,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 4),
          scrollDirection: Axis.horizontal,
          children: ['Action', 'Adventure', 'Animation', 'Biography', 'Comedy']
              .map(
                (genre) => _Genre(
                  label: genre,
                  selected: _genre == genre,
                  onTap: () {
                    setState(() => _genre = genre);
                    _viewModel.load(genre: genre);
                  },
                ),
              )
              .toList(),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MoviesResults(
            viewModel: _viewModel,
            retry: () => _viewModel.load(genre: _genre),
          ),
        ),
      ),
    ],
  );
}

class _Genre extends StatelessWidget {
  const _Genre({
    required this.label,
    this.selected = false,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 28),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        foregroundColor: selected ? Colors.black : _yellow,
        backgroundColor: selected ? _yellow : Colors.transparent,
        side: const BorderSide(color: _yellow),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    ),
  );
}
