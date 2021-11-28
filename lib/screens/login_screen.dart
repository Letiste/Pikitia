import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pikitia/components/button_action.seconday.dart';
import 'package:pikitia/components/button_action_primary.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/services/user_service.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _generalError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Log into your account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),),
            const SizedBox(height: 60),
            if (_generalError.isNotEmpty)
              Text(
                _generalError,
                style: const TextStyle(color: Colors.red),
              ),
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context),
                    ]),
                  ),
                  FormBuilderTextField(
                      name: 'password',
                      decoration: const InputDecoration(labelText: 'Password'),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 6),
                      ])),
                ],
              ),
            ),
            ButtonActionSecondary(
              text: 'Not an account yet?',
              handleOnPressed: () => locator<RoutesService>().goToRegister(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: ButtonActionPrimary(text: 'Login', handlePressed: _handleLogin)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    _formKey.currentState!.save();
    var newGeneralError = "";
    if (_formKey.currentState!.validate()) {
      var email = _formKey.currentState!.value["email"];
      var password = _formKey.currentState!.value["password"];
      var error = await locator<UserService>().loginUser(email, password);
      if (error != null) {
        switch (error) {
          case LoginError.invalidCredentials:
            newGeneralError = "Invalid credentials.";
            break;
          case LoginError.invalidEmail:
            _formKey.currentState?.invalidateField(name: 'email', errorText: 'Invalid email.');
            break;
          case LoginError.userDisabled:
            newGeneralError = "Account disabled.";
            break;
          default:
            newGeneralError = "Sorry, an error occured while logging you in.";
        }
      }
      setState(() => _generalError = newGeneralError);
    }
  }
}
