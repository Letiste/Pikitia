import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pikitia/screens/camera_screen.dart';

class CameraPage extends Page {
  CameraPage() : super(key: const ValueKey('CameraPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) {
        return FutureBuilder<List<CameraDescription>>(
          future: availableCameras(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CameraScreen(camera: snapshot.data!.first);
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
