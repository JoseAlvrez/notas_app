import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/note_bloc/note_bloc.dart';
import 'package:notas_app/models/note.dart';
import 'package:notas_app/repositories/auth_repository.dart';
import 'package:notas_app/repositories/note_repository.dart';
import 'package:notas_app/screens/add_edit_note_screen.dart';
import 'package:notas_app/screens/home_screen.dart';
import 'package:notas_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository())),
        if (userId != null)
          BlocProvider(
            create:
                (_) =>
                    NoteBloc(noteRepository: NoteRepository(), userId: userId),
          ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (_) => LoginScreen(),
          '/home': (_) => HomeScreen(),
          '/addEditNote': (context) {
            final note = ModalRoute.of(context)!.settings.arguments as Note?;
            return BlocProvider.value(
              value: BlocProvider.of<NoteBloc>(context),
              child: AddEditNoteScreen(note: note),
            );
          },
        },
      ),
    );
  }
}
