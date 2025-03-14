import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_event.dart';
import 'package:notas_app/blocs/note_bloc/note_bloc.dart';
import 'package:notas_app/blocs/note_bloc/note_event.dart';
import 'package:notas_app/blocs/note_bloc/note_state.dart';
import 'package:notas_app/models/note.dart';
import 'package:notas_app/screens/add_edit_note_screen.dart';
import 'package:notas_app/widgets/custom_app_bart.dart';
import 'package:notas_app/widgets/custom_card.dart';
import 'package:notas_app/widgets/custom_dialog.dart';
import 'package:notas_app/widgets/custom_snackBart.dart';
import 'package:notas_app/widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final userId = context.select((AuthBloc bloc) => bloc.state.user!.uid);

    return Scaffold(
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
                  _showSignOutDialog(context);
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
            child: _notesSearchBar(context),
          ),
          Expanded(child: _notesList(context)),
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
            final noteBloc = context.read<NoteBloc>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: noteBloc,
                      child: const AddEditNoteScreen(note: null),
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _notesSearchBar(BuildContext context) {
  return CustomTextField(
    label: 'Buscar notas...',
    icon: Icons.search,
    fillColor: Colors.white,
    onChanged: (value) {
      context.read<NoteBloc>().add(SearchQueryChanged(value.trim()));
    },
  );
}

Widget _notesList(BuildContext context) {
  return BlocBuilder<NoteBloc, NoteState>(
    builder: (context, noteState) {
      if (noteState.allNotes.isEmpty) {
        return const Center(
          child: Text('No tienes notas', style: TextStyle(fontSize: 16)),
        );
      }

      final filteredNotes = noteState.filteredNotes;

      if (filteredNotes.isEmpty) {
        return const Center(child: Text('No hay resultados'));
      }

      return ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          return _noteListItem(context, note);
        },
      );
    },
  );
}

Widget _noteListItem(BuildContext context, Note note) {
  return CustomCard(
    elevation: 6,
    child: ListTile(
      leading: const Icon(Icons.feed_outlined, color: Colors.blue, size: 30),
      title: Text(
        note.title,
        style: TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(note.category, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_note_outlined, color: Colors.blue),
            onPressed: () {
              final noteBloc = context.read<NoteBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider.value(
                      value: noteBloc,
                      child: AddEditNoteScreen(note: note),
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(context, note);
            },
          ),
        ],
      ),
    ),
  );
}

void _showDeleteDialog(BuildContext context, Note note) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder:
        (_) => CustomDialog(
          title: "Eliminar Nota",
          contect: Text(
            "¿Deseas eliminar la nota \"${note.title}\"?",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.justify,
          ),
          primaryButtonText: "Eliminar",
          onPrimaryPressed: () {
            context.read<NoteBloc>().add(DeleteNote(note.id));
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

void _showSignOutDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder:
        (_) => CustomDialog(
          title: "Cerrar sesión",
          contect: const Text(
            "¿Estás seguro de que deseas cerrar sesión?",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.justify,
          ),
          primaryButtonText: "Aceptar",
          onPrimaryPressed: () {
            Navigator.pop(context);
            context.read<AuthBloc>().add(SignOutRequested());
          },
          secondaryButtonText: "Cancelar",
          onSecondaryPressed: () => Navigator.pop(context),
        ),
  );
}
