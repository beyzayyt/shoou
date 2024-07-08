import 'package:show_you/data/models/user_model.dart';

class AuthState {
  AuthState();
}

class SignUpInitial extends AuthState {}

class SignUpCompliting extends AuthState {}

class SignUpCompleted extends AuthState {
  final UserModel user;
  SignUpCompleted(this.user);

  List<Object> get props => [user];
}

class SignUpFailed extends AuthState {
  final String errorMessage;
  SignUpFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}

class SignInInitial extends AuthState {}

class SignInCompliting extends AuthState {}

class SignInCompleted extends AuthState {
  final String user;
  SignInCompleted(this.user);

  List<Object> get props => [user];
}

class SignInFailed extends AuthState {
  final String errorMessage;
  SignInFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}

class SignOutInitial extends AuthState {}

class SignOutCompliting extends AuthState {}

class SignOutCompleted extends AuthState {
  final bool isSignOut;
  SignOutCompleted(this.isSignOut);

  List<Object> get props => [isSignOut];
}

class SignOutFailed extends AuthState {
  final String errorMessage;
  SignOutFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}

class ResetPasswordInitial extends AuthState {}

class ResetPasswordCompliting extends AuthState {}

class ResetPasswordCompleted extends AuthState {
  final bool isResetPAssword;
  ResetPasswordCompleted(this.isResetPAssword);

  List<Object> get props => [isResetPAssword];
}

class ResetPasswordFailed extends AuthState {
  final String errorMessage;
  ResetPasswordFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}
