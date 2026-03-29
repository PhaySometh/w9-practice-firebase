import '../../model/comments/comment.dart';

class CommentDto {
  static const String artistId = 'artistId';
  static const String text = 'text';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    assert(json[artistId] is String);
    assert(json[text] is String);

    return Comment(
      id: id,
      artistId: json[artistId],
      text: json[text],
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      artistId: comment.artistId,
      text: comment.text,
    };
  }
}
