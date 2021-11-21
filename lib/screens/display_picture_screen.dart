import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/piki_service.dart';

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

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
                IconButton(
                  color: Colors.white,
                  iconSize: 36.0,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  onPressed: () =>
                      locator<PikiService>().createPiki(imagePath).then((_) => Navigator.of(context).pop()),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Image.file(File(imagePath), fit: BoxFit.contain),
    );
  }
}
