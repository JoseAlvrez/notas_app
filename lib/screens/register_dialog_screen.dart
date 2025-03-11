import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_event.dart';
import 'package:notas_app/blocs/auth_bloc/auth_state.dart';
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
    return Material(
      type: MaterialType.transparency,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.user != null && state.lastAction == AuthAction.signUp) {
            _showSnack(
              context,
              'Registro de usuario exitoso',
              color: Colors.green,
              icon: Icons.check,
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context); // cierra el diálogo
            });
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
          final bloc = context.read<AuthBloc>();
          return CustomDialog(
            title: 'Registrarse',
            contect: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  onChanged: (value) => bloc.add(EmailChanged(value)),
                  errorText: state.emailError,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Contraseña',
                  icon: Icons.lock_outlined,
                  obscureText: true,
                  onChanged: (value) => bloc.add(PasswordChanged(value)),
                  errorText: state.passwordError,
                ),
                const SizedBox(height: 20),
              ],
            ),
            primaryButtonText: 'Registrar',
            onPrimaryPressed:
                state.isFormValid
                    ? () {
                      bloc.add(SignUpRequested(state.email, state.password));
                    }
                    : null,
            secondaryButtonText: 'Cancelar',
            onSecondaryPressed: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}
