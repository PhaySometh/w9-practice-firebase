import 'package:flutter/material.dart';
import 'package:week9_practice_firebase/model/songs/song_detail.dart';

import '../../../model/songs/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songDetail,
    required this.isPlaying,
    required this.isPaused,
    required this.onTap,
    required this.onLike,
  });

  final SongDetail songDetail;
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onTap;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(songDetail.song.title),
          subtitle: Text(
            '${songDetail.song.duration.inMinutes} mins  ${songDetail.song.likes} likes  ${songDetail.artist.name} – ${songDetail.artist.genre}',
          ),
          leading: CircleAvatar(
            onBackgroundImageError: (_, __) {},
            backgroundImage: NetworkImage(songDetail.song.imageUrl),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPlaying)
                Text('Playing', style: TextStyle(color: Colors.amber, fontSize: 12))
              else if (isPaused)
                Text('Paused', style: TextStyle(color: Colors.grey, fontSize: 12)),
              IconButton(
                onPressed: onLike,
                icon: Icon(Icons.favorite, color: Colors.blue[200]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
