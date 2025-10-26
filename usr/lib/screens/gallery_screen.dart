import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/album_grid.dart';
import '../widgets/media_grid.dart';
import '../screens/album_screen.dart';
import '../screens/media_viewer_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _recentMedia = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
    _loadRecentMedia();
  }

  Future<void> _loadAlbums() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.common,
      );
      setState(() {
        _albums = albums;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecentMedia() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.common,
      );
      if (albums.isNotEmpty) {
        final recent = await albums.first.getAssetListPaged(page: 0, size: 50);
        setState(() {
          _recentMedia = recent;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: [
                MediaGrid(media: _recentMedia),
                AlbumGrid(albums: _albums),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Recentes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Álbuns',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}