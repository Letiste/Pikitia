import 'package:flutter/material.dart';
import 'package:pikitia/screens/home_screen.dart';

void main() {
  runApp(const Pikitia());
}

class Pikitia extends StatelessWidget {
  const Pikitia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pikitia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
