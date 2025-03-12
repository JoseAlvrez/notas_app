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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _showError(BuildContext context, String msg) {
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
          if (state.user != null && state.lastAction == AuthAction.signIn) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.errorMessage != null) {
            _showError(context, state.errorMessage!);
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
                            _loginHeader(),
                            const SizedBox(height: 8),
                            _loginFormCard(context),
                            const SizedBox(height: 20),
                            CustomTextbutton(
                              text: "¿No tienes cuenta? Regístrate",
                              textColor: Colors.black54,
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: context.read<AuthBloc>(),
                                      child: const RegisterDialogScreen(),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (state.isLoading)
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

  Widget _loginHeader() {
    return Column(
      children: [
        Image.asset('assets/images/registro-en-linea.png', height: 150),
        const SizedBox(height: 20),
        const Text(
          'Bienvenidos App Notas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _loginFormCard(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return CustomCard(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              children: [
                CustomTextField(
                  label: 'email',
                  icon: Icons.email_outlined,
                  onChanged: (value) {
                    authBloc.add(EmailChanged(value));
                  },
                  errorText: state.emailError,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Contraseña',
                  icon: Icons.lock_outlined,
                  obscureText: true,
                  onChanged: (value) {
                    authBloc.add(PasswordChanged(value));
                  },
                  errorText: state.passwordError,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Iniciar sesión',
                  isEnabled: state.isFormValid,
                  onPressed: () {
                    if (!state.isFormValid) return;
                    authBloc.add(SignInRequested(state.email, state.password));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
