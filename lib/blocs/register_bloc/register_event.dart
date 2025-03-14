abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged(this.email);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged(this.password);
}

class RegisterSumbmitted extends RegisterEvent {}
