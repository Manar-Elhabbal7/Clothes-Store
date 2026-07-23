import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/cache/cache_helper.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  String? userName;

  AuthCubit() : super(AuthInitial()) {
    userName = CacheHelper.getUserName();
  }

  void login(String name, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    userName = name.trim().isNotEmpty ? name.trim() : 'User';
    await CacheHelper.saveUser(name: userName!);
    emit(AuthSuccess());
  }

  void signup(String email, String password, String confirmPassword) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    final emailPrefix = email.split('@').first;
    userName = emailPrefix.trim().isNotEmpty ? emailPrefix.trim() : 'User';
    await CacheHelper.saveUser(name: userName!);
    emit(AuthSuccess());
  }
}
