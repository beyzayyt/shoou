
class AuthState {
  AuthState();
}

class SignUpInitial extends AuthState {}

class SignUpCompliting extends AuthState {}

class SignUpCompleted extends AuthState {
  final String user;
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