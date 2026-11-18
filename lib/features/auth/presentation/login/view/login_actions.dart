sealed class LoginActions {}

class LoginAction extends LoginActions {
  final String email;
  final String password;

  LoginAction(this.email, this.password);
}

class NavigateToRegisterAction extends LoginActions {}

sealed class LoginUIAction {}

class NavigateToRegisterScreen extends LoginUIAction {}

class NavigateToHomeScreen extends LoginUIAction {}

class ShowLoginError extends LoginUIAction {
  final String? message;

  ShowLoginError(this.message);
}
