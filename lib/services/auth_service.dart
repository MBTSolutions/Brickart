import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A bridget for interaction with authentication services.
class AuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  AuthService({GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth})
      : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Returns current authenticated user on Firebase.
  User get currentUser => _firebaseAuth.currentUser;

  /// Returns a `Stream` of authentication status on Firebase Auth.
  Stream<User> get authStatus => _firebaseAuth.authStateChanges();

  /// Signs in user with Google account.
  Future<dynamic> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await _firebaseAuth.signInWithCredential(credential);

      return authResult;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Signs in user with email and password.
  Future<dynamic> signInWithEmail(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  /// Creates new user with email and password.
  Future<dynamic> createUser(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
