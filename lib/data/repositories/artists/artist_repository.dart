import '../../../model/artists/artist.dart';
import '../../../model/comments/comment.dart';
import '../../../model/songs/song.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});

  Future<Artist?> fetchArtistById(String id);

  // W10-03
  Future<List<Song>> fetchSongsByArtist(String artistId);

  Future<List<Comment>> fetchCommentsByArtist(String artistId);

  Future<Comment> postComment(String artistId, String text);
}
