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

  /// Placeholder text in home search bar
  ///
  /// In en, this message translates to:
  /// **'what do you search for?'**
  String get searchHint;

  /// Action link to view all items in a section
  ///
  /// In en, this message translates to:
  /// **'view all'**
  String get viewAll;

  /// CTA button label on home promotional banner
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// Review label before product rating
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewLabel;

  /// Egyptian pound currency code
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egpCurrency;

  /// Retry button label on error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error message when home data fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load home data'**
  String get failedToLoadHomeData;

  /// Semantic tooltip for cart button
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Semantic tooltip for wishlist button
  ///
  /// In en, this message translates to:
  /// **'Add to wishlist'**
  String get addToWishlist;

  /// Semantic tooltip for add to cart button
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// Error message when categories list fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get failedToLoadCategories;

  /// Error message when subcategories fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load subcategories'**
  String get failedToLoadSubCategories;

  /// Empty state message when a category has no subcategories
  ///
  /// In en, this message translates to:
  /// **'No subcategories available'**
  String get noSubCategories;

  /// Empty state message when no categories are returned
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategories;

  /// Semantic label for Home bottom navigation tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// Semantic label for Categories bottom navigation tab
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTab;

  /// Semantic label for Wishlist bottom navigation tab
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTab;

  /// Semantic label for Profile bottom navigation tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// Placeholder message for unimplemented tabs
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Error message when products list fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// Empty state message when no products are returned
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProducts;

  /// App bar title on the product details screen
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// Sold count pill text on product details
  ///
  /// In en, this message translates to:
  /// **'{count} Sold'**
  String soldCount(String count);

  /// Description section heading on product details
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Expandable description link when collapsed
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// Expandable description link when expanded
  ///
  /// In en, this message translates to:
  /// **'Read Less'**
  String get readLess;

  /// Size selector heading on product details
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// Color selector heading on product details
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// Total price label in bottom bar on product details
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get totalPrice;

  /// Confirmation message when adding product to cart
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// Error message when product details fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load product details'**
  String get failedToLoadProductDetails;

  /// Semantic tooltip for search icon button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Semantic tooltip for decrement quantity button
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantity;

  /// Semantic tooltip for increment quantity button
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantity;
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
