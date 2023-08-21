part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState(this.uid);
  final String? uid;

  @override
  List<Object?> get props => [uid];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial() : super(null);

  @override
  List<Object?> get props => [];
}


class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(uid): super(uid);

  @override
  List<Object?> get props => [uid];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  const AuthenticationFailure(this.error) : super(null);

  @override
  List<Object?> get props => [error];
}