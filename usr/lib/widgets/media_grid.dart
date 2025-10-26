import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../widgets/media_grid_item.dart';
import '../screens/media_viewer_screen.dart';

class MediaGrid extends StatelessWidget {
  final List<AssetEntity> media;

  const MediaGrid({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: media.length,
      itemBuilder: (context, index) {
        final asset = media[index];
        return MediaGridItem(
          asset: asset,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaViewerScreen(
                  media: media,
                  initialIndex: index,
                ),
              ),
            );
          },
        );
      },
    );
  }
}