import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/register_bloc/register_bloc.dart';
import 'package:notas_app/blocs/register_bloc/register_event.dart';
import 'package:notas_app/blocs/register_bloc/register_state.dart';
import 'package:notas_app/widgets/custom_dialog.dart';
import 'package:notas_app/widgets/custom_snackBart.dart';
import 'package:notas_app/widgets/custom_text_field.dart';

class RegisterDialogScreen extends StatelessWidget {
  const RegisterDialogScreen({super.key});

  void _showSnack(
    BuildContext context,
    String msg, {
    Color color = Colors.green,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(message: msg, backgroundColor: color, icon: icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isRegistered) {
          _showSnack(
            context,
            'Registro de usuario exitoso',
            color: Colors.green,
            icon: Icons.check,
          );
          Navigator.pop(context);
        } else if (state.errorMessage != null) {
          _showSnack(
            context,
            state.errorMessage!,
            color: Colors.red,
            icon: Icons.error,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomDialog(
          title: 'Registrarse',
          contect: _registerDialogContent(context, state),
          primaryButtonText: 'Registrar',
          onPrimaryPressed:
              (state.isFormValid && !state.isLoading)
                  ? () => context.read<RegisterBloc>().add(RegisterSumbmitted())
                  : null,
          secondaryButtonText: 'Cancelar',
          onSecondaryPressed: () => Navigator.pop(context),
        );
      },
    );
  }

  Widget _registerDialogContent(BuildContext context, RegisterState state) {
    final registerBloc = context.read<RegisterBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          onChanged: (value) => {registerBloc.add(RegisterEmailChanged(value))},
          errorText: state.emailError,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          label: 'Contraseña',
          icon: Icons.lock_outlined,
          obscureText: true,
          onChanged:
              (value) => {registerBloc.add(RegisterPasswordChanged(value))},
          errorText: state.passwordError,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
