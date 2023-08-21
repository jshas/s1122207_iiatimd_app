import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smallstep/data/models/user.dart';
import 'package:smallstep/data/services/authentication_service.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({required this.firebaseAuth});


  AuthenticationService service = AuthenticationService();
  final FirebaseAuth firebaseAuth;

  Stream<UserModel> userStream() {
    return service.authStateChanges();
  }



  @override
  Future<UserCredential?> signUp(UserModel user) {
    try {
      return service.signUp(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(UserModel user) {
    try {
      return service.signIn(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signInAnonymously() async {
    try {
      if (kDebugMode) {
        print("Signed in with temporary account.");
      }
      UserCredential user = await firebaseAuth.signInAnonymously();
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          if (kDebugMode) {
            ("Anonymous auth hasn't been enabled for this project.");
          }
          break;
        default:
          if (kDebugMode) {
            print("Unknown error.");
          }
      }
    }
    return null;
  }

  @override
  Future<void> signOut() {
    return service.signOut();
  }

  @override
  void dispose() {
    service.dispose();
  }

  @override
  Future<User> getCurrentUser() async {
    User? authUser = service.auth.currentUser;
    if (authUser != null) {
      return authUser;
    } else {
      return Future.error("User not found.");
    }
  }
}


abstract class AuthenticationRepository {
  Future<User?> getCurrentUser();

  Future<UserCredential?> signUp(UserModel user);

  Future<UserCredential?> signIn(UserModel user);

  Future<UserCredential?> signInAnonymously();

  Future<void> signOut();

  void dispose() {}
}
