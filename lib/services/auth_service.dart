// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._internal();

  static final _loginController = AuthService._internal();
  static AuthService get instance => _loginController;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  /// Returns the current [User] if they are currently signed-in, or null if not.
  bool loginStatus() {
    return _firebaseAuth.currentUser != null;
  }

  /// Return null when login successed.
  /// If login failed, return content of error
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.code;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.code;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.code;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  bool updateEmail(String email) {
    if (loginStatus()) {
      _firebaseAuth.currentUser?.updateEmail(
        email,
      );
      return true;
    } else {
      return false;
    }
  }

  Future<String?> updatePassword(String newPassword) async {
    if (loginStatus()) {
      try {
        await _firebaseAuth.currentUser?.updatePassword(
          newPassword,
        );

        return null;
      } on FirebaseAuthException catch (e) {
        print(e);
        return e.code;
      } catch (e) {
        print(e);
        return e.toString();
      }
    } else {
      return 'notLoggedIn';
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
