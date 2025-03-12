// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/note_bloc/note_bloc.dart';
import 'package:notas_app/blocs/note_bloc/note_event.dart';
import 'package:notas_app/blocs/note_bloc/note_state.dart';
import 'package:notas_app/models/note.dart';
import 'package:notas_app/widgets/custom_app_bart.dart';
import 'package:notas_app/widgets/custom_button.dart';
import 'package:notas_app/widgets/custom_snackBart.dart';
import 'package:notas_app/widgets/custom_text_field.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final bloc = context.read<NoteBloc>();
      //Reseteamos el formulario para no arrastrar datos de la edición anterior
      bloc.add(const ResetForm());
      //Si es edición, asignamos los valores de la nota
      if (widget.note != null) {
        bloc.add(TitleChanged(widget.note!.title));
        bloc.add(ContentChanged(widget.note!.content));
        bloc.add(CategoryChanged(widget.note!.category));
      }
      _initialized = true;
    }
  }

  void _showSnack(
    BuildContext context,
    String msg, {
    Color backgroundColor = Colors.green,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        message: msg,
        backgroundColor: backgroundColor,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.note == null ? 'Añadir Nota' : 'Editar Nota',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              return Column(children: [_addEditNoteForm(context, state)]);
            },
          ),
        ),
      ),
    );
  }

  Widget _addEditNoteForm(BuildContext context, NoteState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          text: state.editingTitle,
          label: 'Titulo',
          icon: Icons.title,
          maxLength: 30,
          onChanged: (value) {
            context.read<NoteBloc>().add(TitleChanged(value));
          },
          errorText: state.titleError,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          text: state.editingContent,
          label: 'Contenido',
          icon: Icons.content_paste,
          maxLines: 5,
          maxLength: 300,
          onChanged: (value) {
            context.read<NoteBloc>().add(ContentChanged(value));
          },
          errorText: state.contentError,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          text: state.editingCategory,
          label: 'Categoría',
          icon: Icons.category,
          maxLength: 15,
          onChanged: (value) {
            context.read<NoteBloc>().add(CategoryChanged(value));
          },
          errorText: state.categoryError,
        ),
        const SizedBox(height: 25),
        CustomButton(
          text: widget.note == null ? 'Crear' : 'Actualizar',
          onPressed: () {
            final newNote = Note(
              id: widget.note?.id ?? '',
              title: state.editingTitle,
              content: state.editingContent,
              category: state.editingCategory,
              createdAt: widget.note?.createdAt ?? DateTime.now(),
            );
            if (widget.note == null) {
              context.read<NoteBloc>().add(AddNote(newNote));
              _showSnack(
                context,
                "Nota creada exitosamente",
                icon: Icons.check,
              );
            } else {
              context.read<NoteBloc>().add(UpdateNote(newNote));
              _showSnack(
                context,
                "Nota actualizada exitosamente",
                icon: Icons.check,
              );
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
