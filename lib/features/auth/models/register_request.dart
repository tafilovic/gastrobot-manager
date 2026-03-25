/// Body for POST `/v1/users/register`.
class RegisterRequest {
  const RegisterRequest({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });

  final String firstname;
  final String lastname;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
      };
}
