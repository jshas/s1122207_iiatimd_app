import 'package:firebase_auth/firebase_auth.dart';
import 'package:smallstep/data/models/user.dart';
import 'package:smallstep/data/services/authentication_service.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({required this.firebaseAuth});

  static UserModel _userFromFirebaseUser(User? user) {
    return UserModel(uid: user!.uid);
  }

  AuthenticationService service = AuthenticationService();
  final FirebaseAuth firebaseAuth;

  Stream<UserModel> getCurrentUser() {
    return service.retrieveCurrentUser();
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
      print("Signed in with temporary account.");
      return await firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    return null;
  }

    @override
    Future<void> signOut() {
      return service.signOut();
    }
  }

abstract class AuthenticationRepository {
  Stream<UserModel> getCurrentUser();

  Future<UserCredential?> signUp(UserModel user);

  Future<UserCredential?> signIn(UserModel user);

  Future<UserCredential?> signInAnonymously();

  Future<void> signOut();
}
