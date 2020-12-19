import 'package:digitalcard/apps/landingPage.dart';
import 'package:digitalcard/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(
      String email, String password, String name);
  // Future<User> signInWithGoogle();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await usersRef.document(authResult.user.uid).setData({
      "uid": authResult.user.uid,
      "username": name,
      "email": authResult.user.email,
      "photoUrl": '',
      "isPremium": true,
      "level": "user",
      "referId": '',
      'refernum': 0,
      "timestamp": timestamp,
    });

    return _userFromFirebase(authResult.user);
  }

  // @override
  // Future<User> signInWithGoogle() async {
  //   final googleSignIn = GoogleSignIn();
  //   final googleAccount = await googleSignIn.signIn();
  //   if (googleAccount != null) {
  //     final googleAuth = await googleAccount.authentication;
  //     if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //       final authResult = await _firebaseAuth.signInWithCredential(
  //         GoogleAuthProvider.getCredential(
  //           idToken: googleAuth.idToken,
  //           accessToken: googleAuth.accessToken,
  //         ),
  //       );
  //       return _userFromFirebase(authResult.user);
  //     } else {
  //       throw PlatformException(
  //         code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
  //         message: "Missing googleAuth Token",
  //       );
  //     }
  //   } else {
  //     throw PlatformException(
  //       code: 'ERROR_ABORTED_BY_USER',
  //       message: "Sign IN Aborted By User",
  //     );
  //   }
  // }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
