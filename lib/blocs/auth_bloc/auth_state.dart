import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthAction { none, signIn, signUp }

class AuthState extends Equatable {
  final bool isLoading;
  final User? user; // Si user != null => autenticado
  final String? errorMessage;

  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isFormValid;
  final AuthAction lastAction;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isFormValid = false,
    this.lastAction = AuthAction.none,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? errorMessage,
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isFormValid,
    AuthAction? lastAction,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user,
      errorMessage: errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isFormValid: isFormValid ?? this.isFormValid,
      lastAction: lastAction ?? this.lastAction,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    user,
    errorMessage,
    email,
    password,
    emailError,
    passwordError,
    isFormValid,
    lastAction,
  ];
}
