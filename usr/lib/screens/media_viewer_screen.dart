import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import '../widgets/video_player_widget.dart';

class MediaViewerScreen extends StatefulWidget {
  final List<AssetEntity> media;
  final int initialIndex;

  const MediaViewerScreen({
    super.key,
    required this.media,
    required this.initialIndex,
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.media.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.media.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final asset = widget.media[index];
          return FutureBuilder<Uint8List?>(
            future: asset.type == AssetType.video
                ? asset.thumbnailData
                : asset.originBytes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (asset.type == AssetType.video) {
                  return VideoPlayerWidget(asset: asset);
                } else {
                  return InteractiveViewer(
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.contain,
                    ),
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}