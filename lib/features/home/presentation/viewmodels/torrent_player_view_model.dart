import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../data/playback/torrent_service.dart';
import '../../domain/entities/movie.dart';

class TorrentPlayerState {
  const TorrentPlayerState({
    this.player,
    this.error,
    this.status = 'Finding torrent peers…',
  });

  final VideoPlayerController? player;
  final String? error;
  final String status;
}

class TorrentPlayerViewModel extends Cubit<TorrentPlayerState> {
  TorrentPlayerViewModel(this.torrent) : super(const TorrentPlayerState());

  final MovieTorrent torrent;
  TorrentPlaybackSession? _session;

  Future<void> start() async {
    try {
      final session = await startTorrent(torrent.magnet.toString());
      if (isClosed) {
        await session.stop();
        return;
      }
      _session = session;
      final url = await session.waitForVideo();
      if (isClosed) return;
      emit(const TorrentPlayerState(status: 'Buffering video…'));
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      emit(TorrentPlayerState(player: controller, status: state.status));
      await controller.initialize().timeout(const Duration(seconds: 90));
      if (isClosed) return;
      await controller.play();
      if (!isClosed) {
        emit(TorrentPlayerState(player: controller, status: state.status));
      }
    } catch (_) {
      if (isClosed) return;
      final session = _session;
      _session = null;
      if (session != null) await session.stop();
      if (isClosed) return;
      emit(
        const TorrentPlayerState(
          error:
              'Unable to play this torrent. It may have no peers or use an unsupported video format.',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    final controller = state.player;
    if (controller != null) unawaited(controller.dispose());
    final session = _session;
    if (session != null) unawaited(session.stop());
    return super.close();
  }
}
