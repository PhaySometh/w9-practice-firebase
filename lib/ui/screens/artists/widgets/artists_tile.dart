import 'package:flutter/material.dart';
import 'package:week9_practice_firebase/model/artists/artist.dart';

class ArtistsTile extends StatelessWidget {
  const ArtistsTile({
    super.key,
    required this.artist,
    required this.onTap,
  });

  final Artist artist;
  final VoidCallback onTap;

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
          title: Text(artist.name),
          subtitle: Text(artist.genre),
          leading: CircleAvatar(
            onBackgroundImageError: (_, __) {},
            backgroundImage: NetworkImage(artist.imageUrl),
          ),
        ),
      ),
    );
  }
}
