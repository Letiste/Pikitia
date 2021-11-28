import 'package:flutter/material.dart';
import 'package:pikitia/models/pikit.dart';
import 'package:pikitia/screens/pikit_screen.dart';

class PikitPreview extends StatelessWidget {
  const PikitPreview({required this.pikit, required this.height, required this.width, Key? key}) : super(key: key);

  final Pikit pikit;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PikitScreen(pikit: pikit),
        ),
      ),
      child: Stack(
        children: [
          ClipPath(
            clipper: SignForm(),
            child: Container(
              color: Colors.blue,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                child: Hero(
                  tag: pikit,
                  child: Image.network(
                    pikit.pikitImage.htmlUrlPreview,
                    fit: BoxFit.scaleDown,
                    height: height,
                    width: width,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignForm extends CustomClipper<Path> {
  SignForm();

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 8);
    path.lineTo(size.width * .4, size.height - 8);
    path.lineTo(size.width * .5, size.height); 
    path.lineTo(size.width * .6, size.height - 8);
    path.lineTo(size.width, size.height - 8);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}
