import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth errors (e.g., weak password, email already in use)
      throw _getErrorMessage(e.code);
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Helper method to convert FirebaseAuth error codes to user-friendly messages
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'invalid-email':
        return 'The email is invalid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}