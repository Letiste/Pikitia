import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/services/user_service.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_hasError)
              const Text(
                'Sorry, an error occured while creating your account.',
                style: TextStyle(color: Colors.red),
              ),
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context),
                    ]),
                  ),
                  FormBuilderTextField(
                      name: 'password',
                      decoration: InputDecoration(labelText: 'Password'),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 6),
                      ])),
                ],
              ),
            ),
            TextButton(
              onPressed: () => locator<RoutesService>().goToLogin(),
              child: const Text('Already have an account?'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text("Register"),
                    onPressed: _handleRegister,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    _formKey.currentState!.save();
    var newHasError = false;
    if (_formKey.currentState!.validate()) {
      var email = _formKey.currentState!.value["email"];
      var password = _formKey.currentState!.value["password"];
      var error = await locator<UserService>().registerUser(email, password);
      if (error != null) {
        switch (error) {
          case RegistrationError.emailAlreadyInUse:
            _formKey.currentState?.invalidateField(name: 'email', errorText: 'Email already taken.');
            break;
          case RegistrationError.invalidEmail:
            _formKey.currentState?.invalidateField(name: 'email', errorText: 'Invalid email.');
            break;
          case RegistrationError.weakPassword:
            _formKey.currentState?.invalidateField(name: 'password', errorText: 'Password too weak.');
            break;
          default:
            newHasError = true;
        }
      }
      setState(() => _hasError = newHasError);
    }
  }
}
