import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_practice_firebase/model/comments/comment.dart';
import 'package:week9_practice_firebase/model/songs/song.dart';
import 'package:week9_practice_firebase/ui/screens/artist_detail/view_model/artist_detail_view_model.dart';
import 'package:week9_practice_firebase/ui/widgets/comment/comment_tile.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/song/song_tile.dart';
import '../../../../model/songs/song_detail.dart';
import '../../../../model/artists/artist.dart';

class ArtistDetailContent extends StatefulWidget {
  const ArtistDetailContent({super.key});

  @override
  State<ArtistDetailContent> createState() => _ArtistDetailContentState();
}

class _ArtistDetailContentState extends State<ArtistDetailContent> {
  final TextEditingController _commentController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment(ArtistDetailViewModel mv) async {
    final text = _commentController.text.trim();

    if (text.isEmpty) {
      setState(() => _errorMessage = 'Comment cannot be empty.');
      return;
    }

    try {
      setState(() => _errorMessage = null);
      await mv.addComment(text);
      _commentController.clear();
    } catch (e) {
      setState(() => _errorMessage = 'Failed to post comment. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ArtistDetailViewModel mv = context.watch<ArtistDetailViewModel>();
    final Artist artist = mv.artist;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(artist.name, style: AppTextStyles.heading),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      bottomSheet: _buildCommentForm(mv),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artist header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    onBackgroundImageError: (_, __) {},
                    backgroundImage: NetworkImage(artist.imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(artist.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(artist.genre, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),

            // Songs section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Songs', style: AppTextStyles.heading),
            ),
            _buildSongsSection(mv, artist),

            // Comments section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Comments', style: AppTextStyles.heading),
            ),
            _buildCommentsSection(mv),
          ],
        ),
      ),
    );
  }

  Widget _buildSongsSection(ArtistDetailViewModel mv, Artist artist) {
    final AsyncValue<List<Song>> songsValue = mv.songsValue;

    switch (songsValue.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
          child: Text('Error loading songs', style: TextStyle(color: Colors.red)),
        );
      case AsyncValueState.success:
        final songs = songsValue.data!;
        if (songs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No songs found for this artist.', style: TextStyle(color: Colors.grey)),
          );
        }
        return Column(
          children: songs.map((song) {
            final detail = SongDetail(song: song, artist: artist);
            return SongTile(
              songDetail: detail,
              isPlaying: false,
              isPaused: false,
              onTap: () {},
              onLike: () {},
            );
          }).toList(),
        );
    }
  }

  Widget _buildCommentsSection(ArtistDetailViewModel mv) {
    final AsyncValue<List<Comment>> commentsValue = mv.commentsValue;

    switch (commentsValue.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
          child: Text('Error loading comments', style: TextStyle(color: Colors.red)),
        );
      case AsyncValueState.success:
        final comments = commentsValue.data!;
        if (comments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No comments yet. Be the first!', style: TextStyle(color: Colors.grey)),
          );
        }
        return Column(
          children: comments.map((c) => CommentTile(comment: c)).toList(),
        );
    }
  }

  Widget _buildCommentForm(ArtistDetailViewModel mv) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _submitComment(mv),
                child: const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
