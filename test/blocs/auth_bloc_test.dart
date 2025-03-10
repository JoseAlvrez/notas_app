import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_event.dart';
import 'package:notas_app/blocs/auth_bloc/auth_state.dart';
import 'package:notas_app/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockFirebaseAuthException extends Mock implements FirebaseAuthException {
  @override
  final String? message;
  MockFirebaseAuthException(this.message);
}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    authBloc = AuthBloc(mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  test('el estado inicial debe ser AuthInitial', () {
    expect(authBloc.state, isA<AuthInitial>());
  });

  //test cuando el resgistro(creacion) de usuario es existoso
  group('SignUpRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] cuando el registro se realiza correctamente',
      build: () {
        when(
          () => mockAuthRepository.signUp('test@email.com', 'password'),
        ).thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpRequested('test@email.com', 'password')),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    //test cuando el registro falla
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] cuando el registro falla',
      build: () {
        when(
          () => mockAuthRepository.signUp('test@email.com', 'password'),
        ).thenThrow(MockFirebaseAuthException('Error de registro'));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpRequested('test@email.com', 'password')),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  //test cuando el usuario inicio de sesion con exito
  group('SignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] si el registro se realiza correctamente',
      build: () {
        when(
          () => mockAuthRepository.signIn('test@email.com', 'password'),
        ).thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInRequested('test@email.com', 'password')),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    //test cuando falla el inicio de sesion
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] cuando falla el inicio de sesión',
      build: () {
        when(
          () => mockAuthRepository.signIn('test@email.com', 'password'),
        ).thenThrow(MockFirebaseAuthException('Error al iniciar sesión'));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInRequested('test@email.com', 'password')),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  // test de cierre de sesion
  group('SignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] si se cierra sesión correctamente',
      build: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });

  group('currentUser', () {
    test('devuelve el usuario actual del repositorio', () {
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      expect(authBloc.currentUser, mockUser);
    });
  });
}
