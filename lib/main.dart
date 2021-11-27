import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
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
        localizationsDelegates: const [FormBuilderLocalizations.delegate],
        home: Router(
          routerDelegate: PikitiaRouterDelegate(),
          backButtonDispatcher: RootBackButtonDispatcher(),
        ));
  }
}
