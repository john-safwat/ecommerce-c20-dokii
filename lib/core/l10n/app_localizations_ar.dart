// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'راوت للتجارة الإلكترونية';

  @override
  String get loading => 'جارٍ التحميل ...';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get invalidNameFormat => 'صيغة الاسم غير صحيحة';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get invalidEmailFormat => 'صيغة البريد الإلكتروني غير صحيحة';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordInvalid =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل، وتحتوي على أحرف كبيرة وصغيرة وأرقام ورموز خاصة';

  @override
  String get confirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get passwordConfirmationMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get invalidPhoneFormat => 'رقم الهاتف المصري غير صحيح';

  @override
  String get welcomeBackToRoute => 'مرحبًا بعودتك إلى راوت';

  @override
  String get pleaseSignInWithYourMail =>
      'يرجى تسجيل الدخول باستخدام بريدك الإلكتروني';

  @override
  String get userName => 'اسم المستخدم';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterYourFullName => 'أدخل اسمك الكامل';

  @override
  String get mobileNumber => 'رقم الهاتف';

  @override
  String get enterYourMobileNo => 'أدخل رقم هاتفك';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get enterYourEmailAddress => 'أدخل بريدك الإلكتروني';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';
}
