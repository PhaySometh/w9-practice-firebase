import 'package:flutter/material.dart';
import 'package:week9_practice_firebase/model/comments/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: const Icon(Icons.comment, color: Colors.blueGrey),
          title: Text(comment.text),
        ),
      ),
    );
  }
}
