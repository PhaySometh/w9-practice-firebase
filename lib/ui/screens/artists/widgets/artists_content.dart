import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_practice_firebase/model/artists/artist.dart';
import 'package:week9_practice_firebase/ui/screens/artist_detail/artist_detail_screen.dart';
import 'package:week9_practice_firebase/ui/screens/artists/view_model/artists_view_model.dart';
import 'package:week9_practice_firebase/ui/screens/artists/widgets/artists_tile.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';

class ArtistsContent extends StatelessWidget {
  const ArtistsContent({super.key});

  @override
  Widget build(BuildContext context) {
    ArtistsViewModel mv = context.watch<ArtistsViewModel>();

    AsyncValue<List<Artist>> asyncValue = mv.artistsValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'error = ${asyncValue.error!}',
            style: TextStyle(color: Colors.red),
          ),
        );

      case AsyncValueState.success:
        List<Artist> artists = asyncValue.data!;
        // W10-02 - RefreshIndicator forces cache clear and re-fetch
        content = RefreshIndicator(
          onRefresh: () async => mv.fetchArtists(forceFetch: true),
          child: ListView.builder(
            itemCount: artists.length,
            itemBuilder: (context, index) => ArtistsTile(
              artist: artists[index],
              onTap: () {
                // W10-03 - Navigate to artist detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArtistDetailScreen(artist: artists[index]),
                  ),
                );
              },
            ),
          ),
        );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Artists", style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}
