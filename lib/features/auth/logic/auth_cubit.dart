import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/cache/cache_helper.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  String? userName;

  AuthCubit() : super(AuthInitial()) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userName = currentUser.displayName ?? currentUser.email?.split('@').first ?? 'User';
    } else {
      userName = CacheHelper.getUserName();
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        userName = user.displayName ?? user.email?.split('@').first ?? 'User';
        await CacheHelper.saveUser(name: userName!);
        emit(AuthSuccess());
      } else {
        emit(AuthError("Login failed. User is null."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "An error occurred during login."));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signup(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        // Update the display name in Firebase Auth
        await user.updateDisplayName(name.trim());
        await user.reload();
        
        // Refresh reference to the updated user
        final updatedUser = FirebaseAuth.instance.currentUser;
        userName = updatedUser?.displayName ?? name.trim();
        
        await CacheHelper.saveUser(name: userName!);
        emit(AuthSuccess());
      } else {
        emit(AuthError("Signup failed. User is null."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "An error occurred during signup."));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await CacheHelper.clearUser();
      userName = null;
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError("Failed to logout: $e"));
    }
  }
}
