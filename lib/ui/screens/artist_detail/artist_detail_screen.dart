import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_practice_firebase/data/repositories/artists/artist_repository.dart';
import 'package:week9_practice_firebase/model/artists/artist.dart';
import 'package:week9_practice_firebase/ui/screens/artist_detail/view_model/artist_detail_view_model.dart';
import 'package:week9_practice_firebase/ui/screens/artist_detail/widgets/artist_detail_content.dart';

class ArtistDetailScreen extends StatelessWidget {
  const ArtistDetailScreen({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistDetailViewModel(
        artistRepository: context.read<ArtistRepository>(),
        artist: artist,
      ),
      child: const ArtistDetailContent(),
    );
  }
}
