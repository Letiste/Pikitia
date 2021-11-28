import 'package:flutter/material.dart';
import 'package:pikitia/models/pikit.dart';
import 'package:pikitia/services/pikit_service.dart';

import '../locator.dart';

class UserPikitsScreen extends StatelessWidget {
  UserPikitsScreen({Key? key}) : super(key: key) {
    _pikitsFuture = locator<PikitService>().getUserPikits();
  }

  late final Future<List<Pikit>> _pikitsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pikit>>(
      future: _pikitsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var pikits = snapshot.data!;
          return GridView.count(
            crossAxisCount: 2,
            children: pikits.map((pikit) => Image.network(pikit.pikitImage.htmlUrl)).toList(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
