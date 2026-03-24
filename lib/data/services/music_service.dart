import 'package:week9_practice_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week9_practice_firebase/data/repositories/songs/song_repository.dart';
import 'package:week9_practice_firebase/model/artists/artist.dart';
import 'package:week9_practice_firebase/model/songs/song.dart';
import 'package:week9_practice_firebase/model/songs/song_detail.dart';

class MusicService {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  MusicService({required this.songRepository, required this.artistRepository});

  Future<List<SongDetail>> fetchSongDetails() async {
    final List<Song> songs = await songRepository.fetchSongs();
    final List<Artist> artists = await artistRepository.fetchArtists();

    return songs.map((song) {
      final artist = artists.firstWhere((a) => a.id == song.artistId);
      return SongDetail(song: song, artist: artist);
    }).toList();
  }

  Future<void> updateLikes(String id, int likes) async {
    await songRepository.updateLikes(id, likes);
  }
}
