import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_event.dart';
import 'package:notas_app/blocs/note_bloc.dart';
import 'package:notas_app/models/note.dart';
import 'package:notas_app/repositories/auth_repository.dart';
import 'package:notas_app/repositories/note_repository.dart';
import 'package:notas_app/widgets/custom_app_bart.dart';
import 'package:notas_app/widgets/custom_card.dart';
import 'package:notas_app/widgets/custom_dialog.dart';
import 'package:notas_app/widgets/custom_snackBart.dart';
import 'package:notas_app/widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  String searchQuery = "";

  void _showDeleteDialog(BuildContext context, Note note) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (_) => CustomDialog(
            title: "Eliminar Nota",
            contect: Text("¿Deseas eliminar la nota \"${note.title}\"?"),
            primaryButtonText: "Eliminar",
            onPrimaryPressed: () {
              context.read<NoteBloc>().deleteNote(note.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                  message: "Nota eliminada con éxito",
                  backgroundColor: Colors.green,
                  icon: Icons.check,
                ),
              );
            },
            secondaryButtonText: "Cancelar",
            onSecondaryPressed: () => Navigator.pop(context),
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider(
          create: (_) => NoteBloc(NoteRepository(), userId!)..loadNotes(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: CustomAppBar(
          showBackButton: false,
          title: 'Mis Notas',
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black),
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: searchController,
                label: "Buscar notas...",
                icon: Icons.search,
                fillColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<NoteBloc, List<Note>>(
                builder: (context, notes) {
                  if (notes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tienes notas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  final filteredNotes =
                      notes.where((note) {
                        final title = note.title.toLowerCase();
                        final category = note.category.toLowerCase();
                        final content = note.content.toLowerCase();
                        return title.contains(searchQuery) ||
                            category.contains(searchQuery) ||
                            content.contains(searchQuery);
                      }).toList();

                  if (filteredNotes.isEmpty) {
                    return const Center(child: Text('No hay resultados'));
                  }
                  return ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return CustomCard(
                        elevation: 6,
                        child: ListTile(
                          leading: const Icon(
                            Icons.feed_outlined,
                            color: Colors.blue,
                            size: 30,
                          ),
                          title: Text(
                            note.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            note.category,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_note_outlined,
                                  color: Colors.blue,
                                  size: 32,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/addEditNote',
                                    arguments: note,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _showDeleteDialog(context, note);
                                },
                              ), //
                            ],
                          ),
                        ),
                      );
                      //
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/addEditNote');
            },
          ),
        ),
      ),
    );
  }
}
