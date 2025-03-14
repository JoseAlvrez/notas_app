import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String email;
  final String password;

  final String? emailError;
  final String? passwordError;

  final bool isFormValid;
  final bool isLoading;
  final bool isRegistered;
  // ^ Indica si el registro se completó con éxito (para cerrar el diálogo, etc.) // ^ Indica si el registro se completó con éxito (para cerrar el diálogo, etc.)

  final String? errorMessage;

  const RegisterState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isFormValid = false,
    this.isLoading = false,
    this.isRegistered = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isFormValid,
    bool? isLoading,
    bool? isRegistered,
    String? errorMessage,
  }) => RegisterState(
    email: email ?? this.email,
    password: password ?? this.password,
    emailError: emailError,
    passwordError: passwordError,
    isFormValid: isFormValid ?? this.isFormValid,
    isLoading: isLoading ?? this.isLoading,
    isRegistered: isRegistered ?? this.isRegistered,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    email,
    password,
    emailError,
    passwordError,
    isFormValid,
    isLoading,
    isRegistered,
    errorMessage,
  ];
}
