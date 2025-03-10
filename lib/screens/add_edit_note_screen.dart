import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/note_bloc.dart';
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
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final categoryController = TextEditingController();

  String? titleError;
  String? contentError;
  String? categoryError;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      categoryController.text = widget.note!.category;
    }
    titleController.addListener(_validateForm);
    contentController.addListener(_validateForm);
    categoryController.addListener(_validateForm);

    _validateForm();
  }

  @override
  void dispose() {
    titleController.removeListener(_validateForm);
    contentController.removeListener(_validateForm);
    categoryController.removeListener(_validateForm);
    titleController.dispose();
    contentController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final category = categoryController.text.trim();

    if (title.isNotEmpty) {
      titleError = null;
    } else {
      titleError = null;
    }

    if (content.isNotEmpty) {
      contentError = null;
    } else {
      contentError = null;
    }

    if (category.isNotEmpty) {
      categoryError = null;
    } else {
      categoryError = null;
    }

    setState(() {
      isFormValid =
          title.isNotEmpty && content.isNotEmpty && category.isNotEmpty;
    });
  }

  void _showSnack(
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: titleController,
              label: 'Titulo',
              icon: Icons.title,
              maxLength: 30,
              onChanged: (value) => _validateForm(),
              errorText: titleError,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: contentController,
              label: 'Contenido',
              icon: Icons.content_paste,
              maxLines: 5,
              maxLength: 300,
              onChanged: (value) => _validateForm(),
              errorText: contentError,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: categoryController,
              label: 'Categoria',
              icon: Icons.category,
              maxLength: 15,
              onChanged: (value) => _validateForm(),
              errorText: categoryError,
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: widget.note == null ? 'Crear' : 'Actualizar',
              isEnabled: isFormValid,
              onPressed: () {
                final newNote = Note(
                  id: widget.note?.id ?? '',
                  title: titleController.text,
                  content: contentController.text,
                  category: categoryController.text,
                  createdAt: widget.note?.createdAt ?? DateTime.now(),
                );

                if (widget.note == null) {
                  context.read<NoteBloc>().addNote(newNote);
                  _showSnack("Nota creada exitosamente", icon: Icons.check);
                } else {
                  context.read<NoteBloc>().updateNote(newNote);
                  _showSnack(
                    "Nota actualizada exitosamente",
                    icon: Icons.check,
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
