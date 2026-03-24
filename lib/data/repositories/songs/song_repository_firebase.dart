import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https('w9-database-47252-default-rtdb.asia-southeast1.firebasedatabase.app', '/songs.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);
      return songJson.entries
        .map((entry) => SongDto.fromJson(entry.key, entry.value))
        .toList();
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
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
