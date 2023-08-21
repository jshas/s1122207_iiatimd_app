import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repositories/authentication_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepositoryImpl _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(const AuthenticationInitial()) {
    on<AuthenticationStarted>(_onAuthStarted);
    on<AuthenticationLoginRequested>(_onLoginRequested);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
  }


  Future<void> _onAuthStarted(AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    UserCredential? user;
    user = await _authenticationRepository.signInAnonymously();
    if (user != null) {
      emit(AuthenticationSuccess(user.user!.uid));
    } else {
      emit(const AuthenticationFailure("User not found."));
    }
  }

  Future<void> _onLoginRequested(AuthenticationLoginRequested event, Emitter<AuthenticationState> emit) async {
    if(_authenticationRepository.firebaseAuth.currentUser != null) {
      emit(AuthenticationSuccess(_authenticationRepository.firebaseAuth.currentUser!.uid));
    }
    _authenticationRepository.signInAnonymously().then((UserCredential? user) {
      if (user != null) {
        emit(AuthenticationSuccess(user.user!.uid));
      } else {
        emit(const AuthenticationFailure("User not found."));
      }
    });
  }

  Future<void> _onLogoutRequested(AuthenticationLogoutRequested event, Emitter<AuthenticationState> emit) async {
    await _authenticationRepository.signOut();
  }

  Future<FutureOr<void>> signInAnonymously(AuthenticationLogoutRequested event, Emitter<AuthenticationState> emit) async {
    try {
      await _authenticationRepository.signInAnonymously();
      emit (AuthenticationSuccess(_authenticationRepository.getCurrentUser().toString()));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationFailure(e.message.toString()));
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }


}

