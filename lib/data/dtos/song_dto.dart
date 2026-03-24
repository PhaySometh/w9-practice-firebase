import '../../model/songs/song.dart';

class SongDto {
  static const String title = 'title';
  static const String artists = 'artistId';
  static const String imageUrl = 'imageUrl';
  static const String duration = 'duration';   // in ms
  static const String likes = 'likes';

  static Song fromJson(String id, Map<String, dynamic> json) {
    assert(json[title] is String);
    assert(json[artists] is String);
    assert(json[imageUrl] is String);
    assert(json[duration] is int);

    return Song(
      id: id,
      title: json[title],
      artistId: json[artists],
      imageUrl: json[imageUrl],
      duration: Duration(milliseconds: json[duration]),
      likes: json[likes] ?? 0,
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      title: song.title,
      artists: song.artistId,
      imageUrl: song.imageUrl,
      duration: song.duration.inMilliseconds,
    };
  }
}
