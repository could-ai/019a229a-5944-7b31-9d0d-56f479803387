import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../widgets/media_grid.dart';

class AlbumScreen extends StatefulWidget {
  final AssetPathEntity album;

  const AlbumScreen({super.key, required this.album});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<AssetEntity> _media = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    final media = await widget.album.getAssetListPaged(page: 0, size: 100);
    setState(() {
      _media = media;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.name),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : MediaGrid(media: _media),
    );
  }
}