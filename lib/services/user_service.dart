import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

enum RegistrationError { emailAlreadyInUse, invalidEmail, weakPassword, genericError }

class UserService {
  UserService() {
    _auth = firebase_auth.FirebaseAuth.instance;
  }

  late firebase_auth.FirebaseAuth _auth;

  Stream<firebase_auth.User?> watchUser() {
    return _auth.authStateChanges();
  }

  Future<RegistrationError?> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return RegistrationError.emailAlreadyInUse;
        case 'invalid-email':
          return RegistrationError.invalidEmail;
        case 'weak_password':
          return RegistrationError.weakPassword;
        default:
          return RegistrationError.genericError;
      }
    } catch (e) {
      return RegistrationError.genericError;
    }
  }
}
