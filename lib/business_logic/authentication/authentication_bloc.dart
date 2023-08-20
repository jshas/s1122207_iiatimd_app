import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smallstep/data/models/user.dart';

import '../../data/repositories/authentication_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        UserModel user = await _authenticationRepository
            .getCurrentUser()
            .first;
        if (user.uid != null) {
          emit(AuthenticationSuccess(uid: user.uid));
        } else {
          await _authenticationRepository.signInAnonymously();
          UserModel user =
          await _authenticationRepository
              .getCurrentUser()
              .first;
          if (user.uid != null) {
            emit(AuthenticationSuccess(uid: user.uid));
          } else {
            emit(AuthenticationFailure());
          }
        }
      } else if (event is AuthenticationSignedOut) {
        await _authenticationRepository.signOut();
        emit(AuthenticationFailure());
      }

      Future<UserCredential?> signInAnonymously() async {
        try {
          print("Signed in with temporary account.");
          return await _authenticationRepository.signInAnonymously();
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
      void onChange(Change<AuthenticationState> change) {
        if (kDebugMode) {
          print(change);
        }
        super.onChange(change);
      }
    });
  }
}
