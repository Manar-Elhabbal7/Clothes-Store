import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  String? userName;

  AuthCubit() : super(AuthInitial());

  void login(String name, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    userName = name.trim().isNotEmpty ? name.trim() : null;
    emit(AuthSuccess());
  }

  void signup(String email, String password, String confirmPassword) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    final emailPrefix = email.split('@').first;
    userName = emailPrefix.trim().isNotEmpty ? emailPrefix.trim() : null;
    emit(AuthSuccess());
  }
}
