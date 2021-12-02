import 'package:flutter/material.dart';
import 'package:pikitia/models/pikit.dart';
import 'package:pikitia/services/pikit_service.dart';

import '../locator.dart';

class UserPikitsScreen extends StatelessWidget {
  UserPikitsScreen({Key? key}) : super(key: key) {
    _pikitsStream = locator<PikitService>().getUserPikits();
  }

  late final Stream<List<Pikit>> _pikitsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pikit>>(
      stream: _pikitsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var pikits = snapshot.data!;
          return GridView.count(
            crossAxisCount: 2,
            children: pikits.map((pikit) => pikitImagePreview(context, pikit)).toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget pikitImagePreview(BuildContext context, Pikit pikit) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => pikitImage(context, pikit))),
      child: Image.network(pikit.pikitImage.htmlUrl),
    );
  }

  Widget pikitImage(BuildContext context, Pikit pikit) {
    return Stack(
      children: [
        Center(child: Image.network(pikit.pikitImage.htmlUrl)),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30, right: 30),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text("Warning"),
                    content: const Text("Are you sure you want to delete this Pikit?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => locator<PikitService>().deletePikit(pikit).then((_) {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pop();
                          }),
                          child: const Text('Delete Pikit', style: TextStyle(color: Colors.red),)),
                    ],
                  );
                },
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 36,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
