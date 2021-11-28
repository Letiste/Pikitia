import 'package:flutter/material.dart';
import 'package:pikitia/models/pikit.dart';

class PikitPreview extends StatelessWidget {
  const PikitPreview({required this.pikitImage, Key? key}) : super(key: key);

  final PikitImage pikitImage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Hero(
            tag: pikitImage,
            child: Image.network(pikitImage.htmlUrl),
          ),
        ),
      ),
      child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(2.0),
          child: Hero(
            tag: pikitImage,
            child: Image.network(pikitImage.htmlUrlPreview),
          )),
    );
  }
}
