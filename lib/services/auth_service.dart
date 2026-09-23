import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream listening to real-time auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current logged in user
  User? get currentUser => _auth.currentUser;

  // Sign Up with Email & Password
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // Sign In with Email & Password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}