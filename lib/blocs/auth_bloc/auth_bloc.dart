import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_event.dart';
import 'package:notas_app/blocs/auth_bloc/auth_state.dart';
import 'package:notas_app/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    //on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  //esto para obtener el usuario actual públicamente
  User? get currentUser => _authRepository.currentUser;

  void _onEmailChanged(EmailChanged event, Emitter<AuthState> emit) {
    final email = event.email.trim();
    String? emailError;

    if (email.isNotEmpty) {
      bool validEmail = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(email);
      emailError = validEmail ? null : "Formato de email iválido";
    }

    final isFormValid = (email.isNotEmpty && state.password.isNotEmpty);

    emit(
      state.copyWith(
        email: email,
        emailError: emailError,
        isFormValid: isFormValid,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<AuthState> emit) {
    final password = event.password;
    String? passwordError;

    if (password.isNotEmpty && password.length < 6) {
      passwordError = "La contraseña debe tener al menos 6 caracteres";
    }

    final isFormValid = (state.email.isNotEmpty && password.isNotEmpty);

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
  /*Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        lastAction: AuthAction.signUp,
      ),
    );
    try {
      final user = await _authRepository.signUp(event.email, event.password);
      if (user != null) {
        // Se registró
        //await _authRepository.signOut();
        emit(state.copyWith(isLoading: false, user: null));
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
  }*/

  // --- SIGN IN ---
  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        lastAction: AuthAction.signIn,
      ),
    );
    try {
      final user = await _authRepository.signIn(event.email, event.password);
      if (user != null) {
        emit(state.copyWith(isLoading: false, user: user));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "No se pudo iniciar sesión",
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message ?? "Error desconocido al iniciar sesión",
        ),
      );
    }
  }

  // --- SIGN OUT ---
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    // Borramos user para indicar que no hay sesión
    emit(
      state.copyWith(
        user: null,
        errorMessage: null,
        lastAction: AuthAction.signOut,
      ),
    );
  }
}
