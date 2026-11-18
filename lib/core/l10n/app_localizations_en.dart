// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Route E-Commerce';

  @override
  String get loading => 'Loading ...';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get invalidNameFormat => 'Invalid name format';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmailFormat => 'Invalid email address format';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordInvalid =>
      'Password must be at least 8 characters, include upper and lower case letters, numbers, and special characters';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get passwordConfirmationMismatch => 'Passwords do not match';

  @override
  String get phoneRequired => 'Mobile number is required';

  @override
  String get invalidPhoneFormat => 'Invalid Egyptian mobile number';

  @override
  String get welcomeBackToRoute => 'Welcome Back To Route';

  @override
  String get pleaseSignInWithYourMail => 'Please sign in with your mail';

  @override
  String get userName => 'User Name';

  @override
  String get enterYourName => 'enter your name';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'enter your password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAnAccount => 'Don’t have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'enter your full name';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get enterYourMobileNo => 'enter your mobile no.';

  @override
  String get emailAddress => 'E-mail address';

  @override
  String get enterYourEmailAddress => 'enter your email address';

  @override
  String get signUp => 'Sign up';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get loginFailed => 'Login failed';
}
