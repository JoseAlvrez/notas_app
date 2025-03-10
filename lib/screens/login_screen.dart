import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:notas_app/blocs/auth_bloc/auth_event.dart';
import 'package:notas_app/blocs/auth_bloc/auth_state.dart';
import 'package:notas_app/repositories/auth_repository.dart';
import 'package:notas_app/screens/register_dialog_screen.dart';
import 'package:notas_app/widgets/custom_app_bart.dart';
import 'package:notas_app/widgets/custom_button.dart';
import 'package:notas_app/widgets/custom_card.dart';
import 'package:notas_app/widgets/custom_progress_Indicator.dart';
import 'package:notas_app/widgets/custom_snackBart.dart';
import 'package:notas_app/widgets/custom_textButton.dart';
import 'package:notas_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void _showFirebaseError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        message: msg,
        backgroundColor: Colors.red,
        icon: Icons.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            _showFirebaseError(state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: const CustomAppBar(isVisible: false),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              kToolbarHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/registro-en-linea.png',
                              height: 150,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Bienvenidos App Notas",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            CustomCard(
                              elevation: 10,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: emailController,
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                    onChanged: (value) => _validateForm(),
                                    errorText: emailError,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    controller: passwordController,
                                    label: 'Contraseña',
                                    obscureText: true,
                                    icon: Icons.lock_outlined,
                                    onChanged: (value) => _validateForm(),
                                    errorText: passwordError,
                                  ),
                                  const SizedBox(height: 20),
                                  Builder(
                                    builder: (context) {
                                      return CustomButton(
                                        text: 'Iniciar sesión',
                                        isEnabled: isFormValid,
                                        onPressed: () {
                                          if (!isFormValid) return;
                                          context.read<AuthBloc>().add(
                                            SignInRequested(
                                              emailController.text,
                                              passwordController.text,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextbutton(
                              text: "¿No tienes cuenta? Regístrate",
                              textColor: Colors.black54,
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder:
                                      (context) => BlocProvider(
                                        create:
                                            (_) => AuthBloc(AuthRepository()),
                                        child: const RegisterDialogScreen(),
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (state is AuthLoading)
                  Container(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    child: const CustomProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
