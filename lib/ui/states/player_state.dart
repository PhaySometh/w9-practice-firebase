import 'package:flutter/widgets.dart';

import '../../model/songs/song.dart';

class PlayerState extends ChangeNotifier {
  Song? _currentSong;
  bool _isPlaying = false;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;

  void start(Song song) {
    _currentSong = song;
    _isPlaying = true;

    notifyListeners();
  }

  void stop() {
    _isPlaying = false;

    notifyListeners();
  }
}
