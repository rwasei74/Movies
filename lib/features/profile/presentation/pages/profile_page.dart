import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/data/repositories/firebase_auth_repository.dart';
import '../../../home/domain/entities/movie.dart';
import '../../../home/presentation/pages/movie_details_page.dart';
import '../../../home/presentation/widgets/movie_poster_grid.dart';
import '../../../history/data/repositories/hive_watch_history_repository.dart';
import '../../../history/domain/repositories/watch_history_repository.dart';
import '../../../watchlist/data/repositories/firestore_watchlist_repository.dart';
import 'update_profile_page.dart';

const _yellow = Color(0xFFFFC400);
const _panel = Color(0xFF292B2A);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _history = false;
  late final _user = FirebaseAuth.instance.currentUser;
  late final Stream<List<Movie>>? _watchlist = _user == null
      ? null
      : FirestoreWatchlistRepository(
          FirebaseFirestore.instance,
        ).watchMovies(_user.uid);
  late final WatchHistoryRepository? _historyRepository =
      Hive.isBoxOpen('movie_cache')
      ? HiveWatchHistoryRepository(Hive.box('movie_cache'))
      : null;
  List<Movie> _historyMovies = const [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyMovies = _historyRepository?.getHistory() ?? const [];
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Movie>>(
    stream: _watchlist,
    builder: (context, snapshot) => Padding(
      padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFFE95F4A),
            child: Text('🧑🏻', style: TextStyle(fontSize: 35)),
          ),
          const SizedBox(height: 8),
          Text(
            _user?.displayName ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Counter(
                value: snapshot.data?.length.toString() ?? '—',
                label: 'Wish List',
              ),
              const SizedBox(width: 30),
              _Counter(
                value: _historyMovies.length.toString(),
                label: 'History',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const UpdateProfilePage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _yellow,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              SizedBox(
                width: 52,
                height: 35,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuthRepository(
                      FirebaseAuth.instance,
                    ).signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginPage(),
                        ),
                        (_) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF02736),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Exit', style: TextStyle(fontSize: 9)),
                      SizedBox(width: 2),
                      Icon(Icons.exit_to_app_rounded, size: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _ProfileTab(
                  icon: Icons.view_list_rounded,
                  label: 'Watch List',
                  active: !_history,
                  onTap: () => setState(() => _history = false),
                ),
              ),
              Expanded(
                child: _ProfileTab(
                  icon: Icons.folder_rounded,
                  label: 'History',
                  active: _history,
                  onTap: () => setState(() {
                    _loadHistory();
                    _history = true;
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Expanded(
            child: _history
                ? _historyMovies.isEmpty
                      ? const Center(
                          child: Text(
                            'No watched movies yet.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : MoviePosterGrid(
                          padding: const EdgeInsets.fromLTRB(4, 7, 4, 0),
                          movies: _historyMovies,
                          onMovieTap: (movie) => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => MovieDetailsPage(movie: movie),
                            ),
                          ),
                        )
                : snapshot.hasError
                ? const Center(
                    child: Text(
                      'Could not load your watch list.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : !snapshot.hasData
                ? const Center(child: CircularProgressIndicator(color: _yellow))
                : snapshot.data!.isEmpty
                ? const Center(
                    child: Icon(
                      Icons.local_movies_rounded,
                      color: _yellow,
                      size: 57,
                    ),
                  )
                : MoviePosterGrid(
                    padding: const EdgeInsets.fromLTRB(4, 7, 4, 0),
                    movies: snapshot.data,
                    onMovieTap: (movie) => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MovieDetailsPage(movie: movie),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}

class _Counter extends StatelessWidget {
  const _Counter({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 3),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 9)),
    ],
  );
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      height: 39,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: active ? _yellow : _panel, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? _yellow : Colors.white, size: 16),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFFCCCCCC),
              fontSize: 8,
            ),
          ),
        ],
      ),
    ),
  );
}
