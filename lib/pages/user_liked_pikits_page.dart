import 'package:flutter/material.dart';
import 'package:pikitia/screens/user_liked_pikits_screen.dart';

class UserLikedPikitsPage extends Page {
  const UserLikedPikitsPage() : super(key: const ValueKey('UserLikedPikitsPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => UserLikedPikitsScreen());
  }
}
