import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';




class  AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = FirestoreService();

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email & Password Sign Up
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserType userType,
  }) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      await _firestoreService.createUser(
        UserModel(
          id: result.user!.uid,
          email: email,
          name: name,
          userType: userType,
          createdAt: DateTime.now(),
        ),
      );

      return result;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Email & Password Sign In
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google sign in aborted';

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore, if not create profile
      final userExists = await _firestoreService.userExists(userCredential.user!.uid);
      if (!userExists) {
        await _firestoreService.createUser(
          UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName ?? 'User',
            userType: UserType.client, // Default to client for Google sign in
            createdAt: DateTime.now(),
            photoUrl: userCredential.user!.photoURL,
          ),
        );
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;
  //Get user id
 String get userId => _auth.currentUser?.uid ?? '';

  // Error Handler
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'email-already-in-use':
          return 'Email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'weak-password':
          return 'Password is too weak';
        case 'operation-not-allowed':
          return 'Operation not allowed';
        case 'user-disabled':
          return 'User has been disabled';
        default:
          return 'Authentication failed';
      }
    }
    return error.toString();
  }

  Future<UserType> getCurrentUserType() async {
  final user = _auth.currentUser;
  if (user == null) {
    throw 'No user is currently signed in';
  }

  final userDoc = await _firestoreService.getUser(user.uid);
  if (userDoc == null) {
    throw 'User not found in Firestore';
  }

  return userDoc.userType;
}

 Future<void> deleteAccount() async {
  try {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'No user is currently signed in';
    }

    // Delete user data from Firestore
    await _firestoreService.deleteUser(user.uid);

    // Delete user authentication
    await user.delete();
  } catch (e) {
    throw _handleAuthError(e);
  }
}

  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }
}