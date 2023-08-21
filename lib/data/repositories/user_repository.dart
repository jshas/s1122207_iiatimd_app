import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<bool> isAuthenticated();
  Future<void> authenticate();
  Future<User> getUser();
  Future<String> getUserId();
}

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  FirebaseUserRepository({required FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> authenticate() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        FirebaseAuth.instance.signInAnonymously();
      }
    });
  }

  @override
  Future<String> getUserId() async {
    final currentUser = _firebaseAuth.currentUser;
    return Future.value(currentUser!.uid);
  }

  @override
  Future<User> getUser() async {
    final currentUser = _firebaseAuth.currentUser;
    return Future.value(currentUser!);
  }

  @override
  Future<bool> isAuthenticated() {
    final credentials = _firebaseAuth.currentUser;
    return Future.value(credentials != null);
  }

  Future<User> updatedUserCollection(){
    final currentUser = _firebaseAuth.currentUser;
    return Future.value(currentUser!);
  }

}