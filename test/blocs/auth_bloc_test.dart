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

  test('el estado inicial debe ser AuthState con valores por defecto', () {
    expect(authBloc.state.isLoading, false);
    expect(authBloc.state.user, null);
    expect(authBloc.state.errorMessage, null);
  });

  //test cuando el resgistro(creacion) de usuario es existoso
  group('SignUpRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthState con isLoading=true, AuthState con user != null] cuando el registro de usuario se realiza correctamente',
      build: () {
        when(
          () => mockAuthRepository.signUp('jolualca-12@hotmail.com', '123456'),
        ).thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act:
          (bloc) =>
              bloc.add(SignUpRequested('jolualca-12@hotmail.com', '123456')),
      expect:
          () => [
            // 1) Estado de carga
            isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
            // 2) Estado con user != null y isLoading=false
            isA<AuthState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having((s) => s.user, 'user', mockUser),
          ],
    );

    //test cuando el registro falla
    blocTest<AuthBloc, AuthState>(
      'emits [AuthState con isLoading=true, AuthState con errorMessage=...] cuando el registro de usuario falla',
      build: () {
        when(
          () => mockAuthRepository.signUp('jolualca-12@hotmail.com', '123456'),
        ).thenThrow(MockFirebaseAuthException('Error de registro'));
        return authBloc;
      },
      act:
          (bloc) =>
              bloc.add(SignUpRequested('jolualca-12@hotmail.com', '123456')),
      expect:
          () => [
            // Primer estado: isLoading=true, sin errorMessage
            isA<AuthState>()
                .having((s) => s.isLoading, 'isLoading', true)
                .having((s) => s.errorMessage, 'errorMessage', null),

            // Segundo estado: isLoading=false, errorMessage='Error de registro'
            isA<AuthState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  'Error de registro',
                ),
          ],
    );
  });

  //test cuando el usuario inicio de sesion con exito
  group('SignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthState con isLoading=true, AuthState con user != null] si el inicio de sesión es exitoso',
      build: () {
        when(
          () => mockAuthRepository.signIn('jolualca-12@hotmail.com', '123456'),
        ).thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act:
          (bloc) =>
              bloc.add(SignInRequested('jolualca-12@hotmail.com', '123456')),
      expect:
          () => [
            // 1) Estado de carga
            isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
            // 2) Estado con user != null y isLoading=false
            isA<AuthState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having((s) => s.user, 'user', mockUser),
          ],
    );

    //test cuando falla el inicio de sesion
    blocTest<AuthBloc, AuthState>(
      'emits [AuthState con isLoading=true, AuthState con errorMessage=...] cuando falla el inicio de sesión',
      build: () {
        when(
          () => mockAuthRepository.signIn('jolualca-12@hotmail.com', '123456'),
        ).thenThrow(MockFirebaseAuthException('Error al iniciar sesión'));
        return authBloc;
      },
      act:
          (bloc) =>
              bloc.add(SignInRequested('jolualca-12@hotmail.com', '123456')),
      expect:
          () => [
            isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),

            //.having((s) => s.errorMessage, 'errorMessage', null),
            isA<AuthState>()
                .having((s) => s.isLoading, 'isLoading', false)
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  'Error al iniciar sesión',
                ),
          ],
    );
  });

  // test de cierre de sesion
  group('SignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthState con isLoading=true, luego user=null] cuando se cierra sesión correctamente',
      build: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [isA<AuthState>().having((s) => s.user, 'user', null)],
    );
  });

  group('currentUser', () {
    test('devuelve el usuario actual del repositorio', () {
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      expect(authBloc.currentUser, mockUser);
    });
  });
}
