import 'package:flutter/material.dart';
import 'package:pikitia/models/pikit.dart';
import 'package:pikitia/services/pikit_service.dart';

import '../locator.dart';

class PikitScreen extends StatefulWidget {
  const PikitScreen({required this.pikit, Key? key}) : super(key: key);

  final Pikit pikit;

  @override
  State<PikitScreen> createState() => _PikitScreenState();
}

class _PikitScreenState extends State<PikitScreen> {
  bool? _isLiked;
  late PikitService _pikitService;
  void _setIsLiked(bool isLiked) {
    setState(() {
      _isLiked = isLiked;
    });
  }

  @override
  void initState() {
    _pikitService = locator<PikitService>();
    _pikitService.isPikitLikedByUser(widget.pikit).then(_setIsLiked);
    super.initState();
  }

  void _handleLike() {
    if (_isLiked == null) return;
    if (_isLiked!) {
      _pikitService.unlikePikit(widget.pikit);
    } else {
      _pikitService.likePikit(widget.pikit);
    }
    _setIsLiked(!_isLiked!);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Center(
            child: Hero(
              tag: widget.pikit,
              child: Image.network(widget.pikit.pikitImage.htmlUrl),
            ),
          ),
          if (_isLiked != null)
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: _handleLike,
                child: _isLiked!
                    ? const Icon(
                        Icons.favorite,
                        size: 36,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_outline,
                        size: 36,
                        color: Colors.red,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
