import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:week9_practice_firebase/data/dtos/artist_dto.dart';
import 'package:week9_practice_firebase/data/dtos/comment_dto.dart';
import 'package:week9_practice_firebase/data/dtos/song_dto.dart';
import 'package:week9_practice_firebase/data/repositories/artists/artist_repository.dart';

import '../../../model/artists/artist.dart';
import '../../../model/comments/comment.dart';
import '../../../model/songs/song.dart';

class AritistRepositoryFirebase extends ArtistRepository {
  final Uri artistsUri = Uri.https('w9-database-47252-default-rtdb.asia-southeast1.firebasedatabase.app', '/artists.json');

  // W10-02 - In-memory cache
  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    // 1 - Return cache if available (and not force-refreshing)
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 2 - Decode and store in cache
      Map<String, dynamic> artistJson = json.decode(response.body);
      _cachedArtists = artistJson.entries
        .map((entry) => ArtistDto.fromJson(entry.key, entry.value))
        .toList();
      return _cachedArtists!;
    } else {
      // 3 - Throw exception if any issue
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {}

  // W10-03 - Fetch songs filtered by artistId (fetch all, filter client-side)
  @override
  Future<List<Song>> fetchSongsByArtist(String artistId) async {
    final uri = Uri.https(
      'w9-database-47252-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs.json',
    );

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) return [];
      final Map<String, dynamic> songsJson = decoded;
      return songsJson.entries
          .map((entry) => SongDto.fromJson(entry.key, entry.value))
          .where((song) => song.artistId == artistId)
          .toList();
    } else {
      throw Exception('Failed to load songs for artist $artistId');
    }
  }

  // W10-03 - Fetch comments for a specific artist (fetch all, filter client-side)
  @override
  Future<List<Comment>> fetchCommentsByArtist(String artistId) async {
    final uri = Uri.https(
      'w9-database-47252-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments.json',
    );

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) return [];
      final Map<String, dynamic> commentsJson = decoded;
      return commentsJson.entries
          .map((entry) => CommentDto.fromJson(entry.key, entry.value))
          .where((comment) => comment.artistId == artistId)
          .toList();
    } else {
      throw Exception('Failed to load comments for artist $artistId');
    }
  }

  // W10-03 - POST a new comment for an artist
  @override
  Future<Comment> postComment(String artistId, String text) async {
    final uri = Uri.https(
      'w9-database-47252-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/comments.json',
    );

    final comment = Comment(id: '', artistId: artistId, text: text);
    final http.Response response = await http.post(
      uri,
      body: json.encode(CommentDto.toJson(comment)),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      final String newId = responseJson['name'];
      return Comment(id: newId, artistId: artistId, text: text);
    } else {
      throw Exception('Failed to post comment');
    }
  }
}
