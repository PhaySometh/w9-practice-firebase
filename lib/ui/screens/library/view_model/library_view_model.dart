import 'package:flutter/material.dart';
import 'package:week9_practice_firebase/data/services/music_service.dart';
import 'package:week9_practice_firebase/model/songs/song_detail.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final MusicService musicService;
  final PlayerState playerState;

  AsyncValue<List<SongDetail>> songDetailsValue = AsyncValue.loading();

  LibraryViewModel({required this.musicService, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songDetailsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<SongDetail> songDetail = await musicService.fetchSongDetails();
      songDetailsValue = AsyncValue.success(songDetail);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songDetailsValue = AsyncValue.error(e);
    }
    notifyListeners();

  }

  bool isSongPlaying(Song song) => playerState.isPlaying && playerState.currentSong?.id == song.id;

  bool isSongPaused(Song song) => !playerState.isPlaying && playerState.currentSong?.id == song.id;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();

  void likeSong(SongDetail detail) async {
    final newLikes = detail.song.likes + 1;
    final updatedSong = detail.song.copyWith(likes: newLikes);
    final updatedDetail = SongDetail(song: updatedSong, artist: detail.artist);

    final currentList = List<SongDetail>.from(songDetailsValue.data ?? []);
    final index = currentList.indexWhere((d) => d.song.id == detail.song.id);
    if (index != -1) {
      currentList[index] = updatedDetail;
      songDetailsValue = AsyncValue.success(currentList);
      notifyListeners();
    }

    await musicService.updateLikes(detail.song.id, newLikes);
  }
}
