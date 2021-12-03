import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/pikit_service.dart';
import 'package:pikitia/services/routes_service.dart';

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isPikitUploading = false;

  void togglePikitUpload() {
    setState(() {
      _isPikitUploading = !_isPikitUploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: Colors.white,
                  iconSize: 36.0,
                  icon: const Icon(
                    Icons.cancel_outlined,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                _isPikitUploading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        color: Colors.white,
                        iconSize: 36.0,
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        onPressed: () {
                          togglePikitUpload();
                          locator<PikitService>()
                              .createPikit(widget.imagePath)
                              .then((_) => locator<RoutesService>().goToHome());
                        },
                      ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Center(child: Image.file(File(widget.imagePath), fit: BoxFit.contain)),
    );
  }
}
