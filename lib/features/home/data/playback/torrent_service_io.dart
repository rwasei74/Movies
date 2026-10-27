import 'dart:io';
import 'package:flutter_go_torrent_streamer/flutter_go_torrent_streamer.dart';
import 'package:path_provider/path_provider.dart';

class TorrentPlaybackSession {
  TorrentPlaybackSession(this._session);
  final TorrentStreamSession _session;
  bool _stopped = false;

  Future<String> waitForVideo() async {
    final deadline = DateTime.now().add(const Duration(seconds: 75));
    while (!_stopped && DateTime.now().isBefore(deadline)) {
      final status = await _session.getStatus();
      final state = status['state'] as String?;
      if (state == 'Error') throw Exception('Could not find torrent peers.');
      if (state == 'Ready' || state == 'Downloading') {
        final files = await _session.getFiles();
        final videos =
            files
                .where(
                  (file) => RegExp(
                    r'\.(mp4|mkv|webm|m4v|avi|mov)$',
                    caseSensitive: false,
                  ).hasMatch(file.name),
                )
                .toList()
              ..sort((a, b) => b.size.compareTo(a.size));
        if (videos.isEmpty) {
          throw Exception('No playable video was found in this torrent.');
        }
        await _session.selectFile(videos.first.index);
        return _session.streamUrl;
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    throw Exception(
      _stopped
          ? 'Playback stopped.'
          : 'Timed out waiting for torrent metadata.',
    );
  }

  Future<void> stop() async {
    if (_stopped) return;
    _stopped = true;
    await _session.stop();
  }
}

Future<TorrentPlaybackSession> startTorrent(String magnet) async {
  if (!Platform.isAndroid) {
    throw UnsupportedError('Torrent playback is only available on Android.');
  }
  final cache = await getTemporaryDirectory();
  final directory = await Directory(
    '${cache.path}/movie_torrent_cache',
  ).create(recursive: true);
  final session = await FlutterTorrentStreamer().startStream(
    magnet,
    directory.path,
  );
  return TorrentPlaybackSession(session);
}
