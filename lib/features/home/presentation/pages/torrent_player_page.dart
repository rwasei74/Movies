import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:video_player/video_player.dart';
import '../../../history/data/repositories/hive_watch_history_repository.dart';
import '../../domain/entities/movie.dart';
import '../viewmodels/torrent_player_view_model.dart';

class TorrentPlayerPage extends StatefulWidget {
  const TorrentPlayerPage({
    super.key,
    required this.movie,
    required this.torrent,
  });
  final Movie movie;
  final MovieTorrent torrent;
  @override
  State<TorrentPlayerPage> createState() => _TorrentPlayerPageState();
}

class _TorrentPlayerPageState extends State<TorrentPlayerPage> {
  late final TorrentPlayerViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = TorrentPlayerViewModel(widget.torrent)..start();
    if (Hive.isBoxOpen('movie_cache')) {
      unawaited(
        HiveWatchHistoryRepository(Hive.box('movie_cache')).add(widget.movie),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_viewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF101111),
    appBar: AppBar(
      backgroundColor: const Color(0xFF101111),
      foregroundColor: Colors.white,
      title: Text(widget.movie.title),
    ),
    body: Center(
      child: BlocBuilder<TorrentPlayerViewModel, TorrentPlayerState>(
        bloc: _viewModel,
        builder: (context, state) {
          if (state.error != null) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          final player = state.player;
          if (player == null || !player.value.isInitialized) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFFFFC400)),
                const SizedBox(height: 16),
                Text(state.status, style: const TextStyle(color: Colors.white)),
              ],
            );
          }
          return ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: player,
            builder: (context, value, _) => value.hasError
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Video playback failed. The format may not be supported on this device.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: value.aspectRatio,
                        child: VideoPlayer(player),
                      ),
                      VideoProgressIndicator(
                        player,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Color(0xFFFFC400),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            value.isPlaying ? player.pause() : player.play(),
                        icon: Icon(
                          value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    ),
  );
}
