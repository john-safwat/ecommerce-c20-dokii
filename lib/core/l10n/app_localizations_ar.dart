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

  @override
  String get searchHint => 'عمّ تبحث؟';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get shopNow => 'تسوق الآن';

  @override
  String get reviewLabel => 'تقييم';

  @override
  String get egpCurrency => 'ج.م';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get failedToLoadHomeData => 'تعذر تحميل بيانات الصفحة الرئيسية';

  @override
  String get cart => 'عربة التسوق';

  @override
  String get addToWishlist => 'إضافة إلى المفضلة';

  @override
  String get addToCart => 'إضافة إلى السلة';

  @override
  String get failedToLoadCategories => 'تعذر تحميل الفئات';

  @override
  String get failedToLoadSubCategories => 'تعذر تحميل الفئات الفرعية';

  @override
  String get noSubCategories => 'لا توجد فئات فرعية متاحة';

  @override
  String get noCategories => 'لا توجد فئات متاحة';

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get categoriesTab => 'الفئات';

  @override
  String get wishlistTab => 'المفضلة';

  @override
  String get profileTab => 'الحساب';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get failedToLoadProducts => 'تعذر تحميل المنتجات';

  @override
  String get noProducts => 'لا توجد منتجات متاحة';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String soldCount(String count) {
    return '$count مباع';
  }

  @override
  String get description => 'الوصف';

  @override
  String get readMore => 'اقرأ المزيد';

  @override
  String get readLess => 'اقرأ أقل';

  @override
  String get size => 'المقاس';

  @override
  String get color => 'اللون';

  @override
  String get totalPrice => 'السعر الإجمالي';

  @override
  String get addedToCart => 'تمت الإضافة إلى السلة';

  @override
  String get failedToLoadProductDetails => 'تعذر تحميل تفاصيل المنتج';

  @override
  String get search => 'بحث';

  @override
  String get decreaseQuantity => 'تقليل الكمية';

  @override
  String get increaseQuantity => 'زيادة الكمية';

  @override
  String get removeFromCart => 'إزالة من السلة';

  @override
  String get checkOut => 'إتمام الشراء';

  @override
  String get emptyCart => 'عربة التسوق فارغة';

  @override
  String get failedToLoadCart => 'تعذر تحميل عربة التسوق';

  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع';

  @override
  String get creditCard => 'بطاقة ائتمان';

  @override
  String get creditCardSubtitle =>
      'ادفع بأمان عبر الإنترنت باستخدام فيزا أو ماستركارد';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get cashOnDeliverySubtitle => 'ادفع نقدًا عند وصول طلبك';

  @override
  String get shippingAddress => 'عنوان الشحن';

  @override
  String get addressDetails => 'تفاصيل العنوان';

  @override
  String get enterAddressDetails => 'أدخل الشارع، المبنى، الشقة';

  @override
  String get city => 'المدينة';

  @override
  String get enterCity => 'أدخل مدينتك';

  @override
  String get postalCode => 'الرمز البريدي (اختياري)';

  @override
  String get enterPostalCode => 'أدخل الرمز البريدي';

  @override
  String get addressDetailsRequired => 'تفاصيل العنوان مطلوبة';

  @override
  String get cityRequired => 'المدينة مطلوبة';

  @override
  String get placeOrder => 'تأكيد الطلب';

  @override
  String get proceedToPayment => 'المتابعة إلى الدفع';

  @override
  String get orderPlacedSuccessfully => 'تم تقديم الطلب بنجاح';

  @override
  String get paymentSuccessful => 'تم الدفع بنجاح';

  @override
  String get paymentCancelled => 'تم إلغاء عملية الدفع';

  @override
  String get paymentFailed => 'فشلت عملية الدفع، يرجى المحاولة مرة أخرى';

  @override
  String get paymentTitle => 'الدفع الإلكتروني';

  @override
  String get cartNotReadyForCheckout =>
      'عربة التسوق غير جاهزة لإتمام الشراء، يرجى التحديث والمحاولة مرة أخرى';
}
