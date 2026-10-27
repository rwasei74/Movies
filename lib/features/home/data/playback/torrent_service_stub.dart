class TorrentPlaybackSession {
  Future<void> stop() async {}
  Future<String> waitForVideo() async =>
      throw UnsupportedError('Torrent playback is only available on Android.');
}

Future<TorrentPlaybackSession> startTorrent(String magnet) async =>
    throw UnsupportedError('Torrent playback is only available on Android.');
