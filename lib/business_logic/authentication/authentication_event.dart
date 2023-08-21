part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  final String uid;
  const AuthenticationLoginRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
