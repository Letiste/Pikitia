import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pikitia/screens/display_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.veryHigh);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _cameraController.takePicture();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error taking a Pikit :('),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: const Icon(Icons.camera, size: 36, color: Colors.black),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox.expand(child: CameraPreview(_cameraController));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
