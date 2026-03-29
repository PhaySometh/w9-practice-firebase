import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https('w9-database-47252-default-rtdb.asia-southeast1.firebasedatabase.app', '/songs.json');

  // W10-02 - In-memory cache
  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    // 1 - Return cache if available (and not force-refreshing)
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 2 - Decode and store in cache
      Map<String, dynamic> songJson = json.decode(response.body);
      _cachedSongs = songJson.entries
        .map((entry) => SongDto.fromJson(entry.key, entry.value))
        .toList();
      return _cachedSongs!;
    } else {
      // 3 - Throw exception if any issue
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<void> updateLikes(String id, int likes) async {
    final uri = Uri.https(
      'w9-database-47252-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$id.json',
    );
    await http.patch(uri, body: json.encode({'likes': likes}));
  }
}
