import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_event.dart';
import 'package:notas_app/blocs/auth_bloc/auth_state.dart';
import 'package:notas_app/widgets/custom_dialog.dart';
import 'package:notas_app/widgets/custom_snackBart.dart';
import 'package:notas_app/widgets/custom_text_field.dart';

class RegisterDialogScreen extends StatefulWidget {
  const RegisterDialogScreen({super.key});

  @override
  State<RegisterDialogScreen> createState() => _RegisterDialogScreenState();
}

class _RegisterDialogScreenState extends State<RegisterDialogScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isNotEmpty) {
      bool validEmail = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(email);
      emailError = validEmail ? null : "Formato de email inválido";
    } else {
      emailError = null;
    }

    if (password.isNotEmpty) {
      bool validPassword = password.length >= 6;
      passwordError =
          validPassword
              ? null
              : "La contraseña debe tener al menos 6 caracteres";
    } else {
      passwordError = null;
    }

    setState(() {
      isFormValid = email.isNotEmpty && password.isNotEmpty;
    });
  }

  void _showSnack(String msg, {Color color = Colors.green, IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(message: msg, backgroundColor: color, icon: icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: CustomDialog(
        title: "Registrarse",
        contect: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              _showSnack(
                "Registro de usario exitoso",
                color: Colors.green,
                icon: Icons.check,
              );
              Future.delayed(const Duration(seconds: 1), () {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              });
            } else if (state is AuthError) {
              _showSnack(
                "La dirección de correo electrónico ya está siendo utilizada por otra cuenta",
                color: Colors.red,
                icon: Icons.error,
              );
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email_outlined,
                onChanged: (value) => _validateForm(),
                errorText: emailError,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: passwordController,
                label: "Contraseña",
                icon: Icons.lock_outlined,
                obscureText: true,
                onChanged: (value) => _validateForm(),
                errorText: passwordError,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        primaryButtonText: "Registrar",
        onPrimaryPressed:
            isFormValid
                ? () {
                  context.read<AuthBloc>().add(
                    SignUpRequested(
                      emailController.text,
                      passwordController.text,
                    ),
                  );
                }
                : null,
        secondaryButtonText: 'Cancelar',
        onSecondaryPressed: () => Navigator.pop(context),
      ),
    );
  }
}
