import 'package:flutter/material.dart';
import 'package:week9_practice_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week9_practice_firebase/model/artists/artist.dart';
import 'package:week9_practice_firebase/model/comments/comment.dart';
import 'package:week9_practice_firebase/model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
  }) {
    _init();
  }

  void _init() {
    fetchData();
  }

  void fetchData() async {
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final songs = await artistRepository.fetchSongsByArtist(artist.id);
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();

    try {
      final comments = await artistRepository.fetchCommentsByArtist(artist.id);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> addComment(String text) async {
    if (text.trim().isEmpty) return;

    try {
      final newComment = await artistRepository.postComment(artist.id, text);

      final currentComments = List<Comment>.from(commentsValue.data ?? []);
      currentComments.add(newComment);
      commentsValue = AsyncValue.success(currentComments);
      notifyListeners();
    } catch (e) {
      // Keep existing comments, surface error to UI
      rethrow;
    }
  }
}
