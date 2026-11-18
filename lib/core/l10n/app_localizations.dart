import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Route E-Commerce'**
  String get appTitle;

  /// Default loading text
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get loading;

  /// Validation error when name is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Validation error when name format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid name format'**
  String get invalidNameFormat;

  /// Validation error when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Validation error when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email address format'**
  String get invalidEmailFormat;

  /// Validation error when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Validation error when password does not meet requirements
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters, include upper and lower case letters, numbers, and special characters'**
  String get passwordInvalid;

  /// Validation error when password confirmation is empty
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// Validation error when confirmation password does not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordConfirmationMismatch;

  /// Validation error when mobile number is empty
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get phoneRequired;

  /// Validation error when mobile number format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid Egyptian mobile number'**
  String get invalidPhoneFormat;

  /// Login screen main heading
  ///
  /// In en, this message translates to:
  /// **'Welcome Back To Route'**
  String get welcomeBackToRoute;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Please sign in with your mail'**
  String get pleaseSignInWithYourMail;

  /// Login email/username field label
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// Login email/username field hint
  ///
  /// In en, this message translates to:
  /// **'enter your name'**
  String get enterYourName;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'enter your password'**
  String get enterYourPassword;

  /// Forgot password link label
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Prompt before create account link
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get dontHaveAnAccount;

  /// Create account link label
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Register full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Register full name field hint
  ///
  /// In en, this message translates to:
  /// **'enter your full name'**
  String get enterYourFullName;

  /// Register mobile number field label
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Register mobile number field hint
  ///
  /// In en, this message translates to:
  /// **'enter your mobile no.'**
  String get enterYourMobileNo;

  /// Register email address field label
  ///
  /// In en, this message translates to:
  /// **'E-mail address'**
  String get emailAddress;

  /// Register email address field hint
  ///
  /// In en, this message translates to:
  /// **'enter your email address'**
  String get enterYourEmailAddress;

  /// Sign up button label
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// Tooltip for showing password
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// Tooltip for hiding password
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// Default error message when login fails
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
