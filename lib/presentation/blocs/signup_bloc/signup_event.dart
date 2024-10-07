abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final String reenterPassword;

  SignUpSubmitted({
    required this.email,
    required this.password,
    required this.reenterPassword,
  });
}