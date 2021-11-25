import 'package:flutter/material.dart';

class PikiPreview extends StatelessWidget {
  const PikiPreview({required this.htmlUrl, Key? key}) : super(key: key);

  final String htmlUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Hero(tag: htmlUrl, child: Image.network(htmlUrl)))),
      child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(2.0),
          child: Hero(
            tag: htmlUrl,
            child: Image.network(htmlUrl),
          )),
    );
  }
}
