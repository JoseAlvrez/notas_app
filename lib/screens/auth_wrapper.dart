import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_state.dart';
import 'package:notas_app/blocs/note_bloc/note_bloc.dart';
import 'package:notas_app/repositories/note_repository.dart';
import 'package:notas_app/screens/home_screen.dart';
import 'package:notas_app/screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authstate) {
        if (authstate.user == null) {
          return const LoginScreen();
        } else {
          //if (authstate.lastAction == AuthAction.signIn) {
          final userId = authstate.user!.uid;
          return BlocProvider<NoteBloc>(
            create:
                (_) =>
                    NoteBloc(noteRepository: NoteRepository(), userId: userId),
            child: const HomeScreen(),
          );
        }
      },
    );
  }
}
