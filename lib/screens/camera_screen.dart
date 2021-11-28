import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pikitia/screens/display_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera(selectedCamera);
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    _cameraController = CameraController(widget.cameras[cameraIndex], ResolutionPreset.veryHigh, enableAudio: false);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SizedBox.expand(child: CameraPreview(_cameraController)),
              Align(
                alignment: const Alignment(0, 0.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: widget.cameras.length > 1
                      ? [
                          const Spacer(),
                          Expanded(child: cameraButton()),
                          Expanded(child: flipCamera()),
                        ]
                      : [
                          Expanded(child: cameraButton()),
                        ],
                ),
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget cameraButton() {
    return FloatingActionButton(
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
    );
  }

  Widget flipCamera() {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {
        setState(() {
          selectedCamera = selectedCamera == 0 ? 1 : 0;
          _initializeCamera(selectedCamera);
        });
      },
      child: const Icon(
        Icons.flip_camera_android,
        color: Colors.black,
      ),
    );
  }
}
