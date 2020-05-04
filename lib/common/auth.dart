import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth._();
  static final Auth instance = Auth._();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  Stream<FirebaseUser> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged;

  Future<AuthResult> signInAnonymously() => _firebaseAuth.signInAnonymously();

  Future<AuthCredential> getGoogleSignInCredential() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    return GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<AuthResult> signinWithGoogle() async {
    final credential = await getGoogleSignInCredential();
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<AuthResult> linkWithGoogleSignIn() async {
    final credential = await getGoogleSignInCredential();
    final user = await _firebaseAuth.currentUser();
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
