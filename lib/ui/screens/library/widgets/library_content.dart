import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_practice_firebase/model/songs/song_detail.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    LibraryViewModel mv = context.watch<LibraryViewModel>();

    AsyncValue<List<SongDetail>> asyncValue = mv.songDetailsValue;

    Widget content;
    switch (asyncValue.state) {
      
      case AsyncValueState.loading:
        content = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(child: Text('error = ${asyncValue.error!}', style: TextStyle(color: Colors.red),));

      case AsyncValueState.success:
        List<SongDetail> detail = asyncValue.data!;
        // W10-02 - RefreshIndicator forces cache clear and re-fetch
        content = RefreshIndicator(
          onRefresh: () async => mv.fetchSong(forceFetch: true),
          child: ListView.builder(
            itemCount: detail.length,
            itemBuilder: (context, index) => SongTile(
              songDetail: detail[index],
              isPlaying: mv.isSongPlaying(detail[index].song),
              isPaused: mv.isSongPaused(detail[index].song),
              onTap: () {
                if (mv.isSongPlaying(detail[index].song)) {
                  mv.stop(detail[index].song);
                } else {
                  mv.start(detail[index].song);
                }
              },
              onLike: () {
                mv.likeSong(detail[index]);
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
          Text("Library", style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}
