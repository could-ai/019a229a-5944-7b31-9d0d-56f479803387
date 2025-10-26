import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../screens/album_screen.dart';

class AlbumGrid extends StatelessWidget {
  final List<AssetPathEntity> albums;

  const AlbumGrid({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumScreen(album: album),
              ),
            );
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder, size: 48),
                const SizedBox(height: 8),
                Text(
                  album.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                FutureBuilder<int>(
                  future: album.assetCountAsync,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('${snapshot.data} itens');
                    }
                    return const Text('');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}