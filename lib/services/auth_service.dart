import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // 1. Instance of Firebase SDK
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 2. Auth State Stream: Listens in real time to whether a user is logged in or out
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 3. Current User Getter: Quick access to the logged-in user's details (UID, email)
  User? get currentUser => _auth.currentUser;

  // 4. Sign Up Method
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 5. Sign In Method
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 6. Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Helper method to convert cryptic Firebase error codes into readable messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return e.message ?? 'An unknown authentication error occurred.';
    }
  }
}