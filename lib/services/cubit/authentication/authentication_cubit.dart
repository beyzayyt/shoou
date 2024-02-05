import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/cubit/authentication/authentication_state.dart';
import 'package:show_you/services/authentication_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(SignUpInitial());

  final AuthService authService = AuthService();

  Future<void> signUpUser(String email, String password) async {
    emit(SignUpInitial());
    try {
      emit(SignUpCompliting());
      var userResult = await authService.signUp(email, password);

      if (userResult.id.isNotEmpty) {
        emit(SignUpCompleted(userResult));
      } else {
        emit(SignUpFailed(userResult.errorMessage));
      }
    } catch (e) {
      emit(SignUpFailed('Create user failed'));
    }
  }

  Future<void> signInUser(String email, String password) async {
    emit(SignInInitial());
    try {
      emit(SignInCompliting());
      var userResult = await authService.signIn(email, password);

      if (userResult.id.isNotEmpty) {
        emit(SignInCompleted(userResult.id));
      } else {
        emit(SignInFailed(userResult.errorMessage));
      }
    } catch (e) {
      emit(SignInFailed('Sign in user failed'));
    }
  }
}
