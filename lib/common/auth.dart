import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth._();
  static final Auth instance = Auth._();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  Stream<User> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInAnonymously() => _firebaseAuth.signInAnonymously();

  Future<AuthCredential> getGoogleSignInCredential() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<UserCredential> signinWithGoogle() async {
    final credential = await getGoogleSignInCredential();
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> linkWithGoogleSignIn() async {
    final credential = await getGoogleSignInCredential();
    final user = _firebaseAuth.currentUser;
    try {
      final result = await user.linkWithCredential(credential);
      return result;
    } catch (ex) {
      // Exception is thrown when credential is already linked, so delete this anonymous user
      await user.delete();
      return _firebaseAuth.signInWithCredential(credential);
    }
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    if (await _googleSignIn.isSignedIn()) _googleSignIn.signOut();
  }
}
