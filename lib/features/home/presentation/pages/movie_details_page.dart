import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../watchlist/data/repositories/firestore_watchlist_repository.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_poster_grid.dart';
import 'torrent_player_page.dart';

const _bg = Color(0xFF101111);
const _yellow = Color(0xFFFFC400);
const _panel = Color(0xFF292B2A);

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key, required this.movie});
  final Movie movie;

  Future<void> _watch(BuildContext context) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Torrent playback is currently available on Android only.',
          ),
        ),
      );
      return;
    }
    if (movie.torrents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No torrent is available for this movie.'),
        ),
      );
      return;
    }
    final selected = await showModalBottomSheet<MovieTorrent>(
      context: context,
      backgroundColor: _panel,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Choose quality',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Torrent playback can download the full file, use significant data and storage, and upload parts to other peers. Downloaded data may remain on your device. Only play content you are permitted to use.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: movie.torrents
                    .map(
                      (torrent) => ListTile(
                        title: Text(
                          torrent.quality,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          [
                            if (torrent.size != null) torrent.size!,
                            if (torrent.seeds != null) '${torrent.seeds} seeds',
                          ].join(' · '),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.play_arrow_rounded,
                          color: _yellow,
                        ),
                        onTap: () => Navigator.pop(context, torrent),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || selected == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TorrentPlayerPage(movie: movie, torrent: selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 437,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MovieArtwork(path: movie.backgroundPath ?? movie.posterPath),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x22000000), _bg],
                      stops: [.2, 1],
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _WatchlistButton(movie: movie),
                  ),
                ),
                Center(
                  child: IconButton(
                    onPressed: () => _watch(context),
                    iconSize: 64,
                    icon: const Icon(
                      Icons.play_circle_fill_rounded,
                      color: _yellow,
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  right: 25,
                  bottom: 9,
                  child: Column(
                    children: [
                      Text(
                        movie.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.year?.toString() ?? '—',
                        style: const TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 25),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () => _watch(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF02727),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'Watch',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      icon: Icons.movie_rounded,
                      value: movie.genres.isEmpty ? '—' : movie.genres.first,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _Stat(
                      icon: Icons.access_time_filled_rounded,
                      value: movie.runtime == null
                          ? '—'
                          : '${movie.runtime} min',
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _Stat(
                      icon: Icons.star_rounded,
                      value: movie.rating?.toStringAsFixed(1) ?? '—',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Synopsis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                movie.summary?.isNotEmpty == true
                    ? movie.summary!
                    : 'No synopsis available.',
                style: const TextStyle(color: Colors.white70, height: 1.5),
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

class _WatchlistButton extends StatefulWidget {
  const _WatchlistButton({required this.movie});
  final Movie movie;
  @override
  State<_WatchlistButton> createState() => _WatchlistButtonState();
}

class _WatchlistButtonState extends State<_WatchlistButton> {
  late final _repository = FirestoreWatchlistRepository(
    FirebaseFirestore.instance,
  );
  late final _uid = FirebaseAuth.instance.currentUser?.uid;
  late final _movies = _uid == null ? null : _repository.watchMovies(_uid);
  bool _busy = false;
  @override
  Widget build(BuildContext context) => StreamBuilder<List<Movie>>(
    stream: _movies,
    builder: (context, snapshot) {
      final saved = snapshot.data?.any((m) => m.id == widget.movie.id) ?? false;
      return IconButton(
        tooltip: saved ? 'Remove from watch list' : 'Add to watch list',
        icon: Icon(
          saved ? Icons.bookmark : Icons.bookmark_border,
          color: saved ? _yellow : Colors.white,
        ),
        onPressed:
            _busy || _uid == null || snapshot.hasError || !snapshot.hasData
            ? null
            : () async {
                setState(() => _busy = true);
                try {
                  if (saved) {
                    await _repository.remove(_uid, widget.movie.id);
                  } else {
                    await _repository.add(_uid, widget.movie);
                  }
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not update your watch list. Check your connection.',
                        ),
                      ),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
      );
    },
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value});
  final IconData icon;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    height: 31,
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: _yellow, size: 19),
        const SizedBox(width: 7),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
