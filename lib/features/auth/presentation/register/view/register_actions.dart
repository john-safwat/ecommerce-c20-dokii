sealed class RegisterActions {}

class RegisterSubmitAction extends RegisterActions {
  final String name;
  final String phone;
  final String email;
  final String password;

  RegisterSubmitAction({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });
}

sealed class RegisterUIAction {}

class NavigateBack extends RegisterUIAction {}

class ShowRegisterError extends RegisterUIAction {
  final String? message;
  ShowRegisterError(this.message);
}
