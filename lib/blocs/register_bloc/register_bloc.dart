import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/register_bloc/register_event.dart';
import 'package:notas_app/blocs/register_bloc/register_state.dart';
import 'package:notas_app/repositories/auth_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc(this._authRepository) : super(const RegisterState()) {
    on<RegisterEmailChanged>(_onRegisterEmailChanged);
    on<RegisterPasswordChanged>(_onRegisterPasswordChanged);
    on<RegisterSumbmitted>(_onRegisterSubmitted);
  }

  void _onRegisterEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = event.email.trim();
    String? emailError;
    if (email.isEmpty) {
      bool validEmail = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(email);
      emailError = validEmail ? null : emailError = "Formato de email iválido";
    }

    final isFormValid =
        (email.isNotEmpty &&
            state.password.isNotEmpty &&
            emailError == null &&
            state.passwordError == null);
    ;

    emit(
      state.copyWith(
        email: email,
        emailError: emailError,
        isFormValid: isFormValid,
        errorMessage: null,
      ),
    );
  }

  void _onRegisterPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = event.password;
    String? passwordError;

    if (password.isNotEmpty && password.length < 6) {
      passwordError = "La contraseña debe tener al menos 6 caracteres";
    }

    final isFormValid =
        (state.email.isNotEmpty &&
            password.isNotEmpty &&
            state.emailError == null &&
            passwordError == null);

    emit(
      state.copyWith(
        password: password,
        passwordError: passwordError,
        isFormValid: isFormValid,
        errorMessage: null,
      ),
    );
  }

  // --- SIGN UP ---
  Future<void> _onRegisterSubmitted(
    RegisterSumbmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, isRegistered: null),
    );

    try {
      // 1) Registramos el usuario
      final user = await _authRepository.signUp(state.email, state.password);
      if (user != null) {
        // 2) Cerrar sesión inmediatamente para evitar auto-login
        await _authRepository.signOut();

        // 3) Notificamos que el registro fue exitoso
        emit(state.copyWith(isLoading: false, isRegistered: true));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "No se pudo registrar el usuario",
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message ?? "Error desconocido al registrar",
        ),
      );
    }
  }
}
