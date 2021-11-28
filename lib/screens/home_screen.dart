import 'package:flutter/material.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/widgets/pikits_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: "photo",
        backgroundColor: Colors.white,
        child: const Icon(Icons.camera_alt, size: 36.0, color: Colors.black,),
        onPressed: () => locator<RoutesService>().goToCamera()
      ),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 3.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                iconSize: 36.0,
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {},
              ),
              IconButton(
                iconSize: 36.0,
                icon: const Icon(Icons.photo_size_select_actual_rounded),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: const PhotosMap(),
    );
  }
}
