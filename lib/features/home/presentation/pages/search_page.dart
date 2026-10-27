import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodels/movies_factory.dart';
import '../viewmodels/movies_view_model.dart';
import '../widgets/movies_results.dart';

const _panel = Color(0xFF292B2A);
const _yellow = Color(0xFFFFC400);

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _hasText = false;
  String _query = '';
  Timer? _debounce;
  final _viewModel = createMoviesViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadLastSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _viewModel.close();
    super.dispose();
  }

  void _search(String value) {
    _debounce?.cancel();
    setState(() {
      _query = value.trim();
      _hasText = _query.isNotEmpty;
    });
    if (_hasText) {
      _debounce = Timer(
        const Duration(milliseconds: 450),
        () => _viewModel.load(query: _query),
      );
    } else {
      _viewModel.loadLastSearch();
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
    child: Column(
      children: [
        TextField(
          onChanged: _search,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(color: Colors.white, fontSize: 12),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.white),
            filled: true,
            fillColor: _panel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Expanded(
          child: _hasText
              ? MoviesResults(
                  viewModel: _viewModel,
                  retry: () => _viewModel.load(query: _query),
                )
              : _LastSearchResults(viewModel: _viewModel),
        ),
      ],
    ),
  );
}

class _LastSearchResults extends StatelessWidget {
  const _LastSearchResults({required this.viewModel});
  final MoviesViewModel viewModel;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MoviesViewModel, MoviesState>(
        bloc: viewModel,
        builder: (context, state) => state.movies.isEmpty
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_movies_rounded, color: _yellow, size: 65),
                    Icon(Icons.fastfood_rounded, color: _yellow, size: 37),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Last Results',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: MoviesResults(
                      viewModel: viewModel,
                      retry: viewModel.loadLastSearch,
                    ),
                  ),
                ],
              ),
      );
}
