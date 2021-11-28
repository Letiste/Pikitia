import 'package:flutter/material.dart';
import 'package:pikitia/screens/user_pikits_screen.dart';

class UserPikitsPage extends Page {
  const UserPikitsPage() : super(key: const ValueKey('UserPikitsPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => UserPikitsScreen());
  }
}
