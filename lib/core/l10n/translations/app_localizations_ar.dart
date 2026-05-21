// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get name_is_required => 'الاسم مطلوب!';

  @override
  String get name_is_not_valid => 'هذا الاسم غير صالح';

  @override
  String get email_is_required => 'البريد الإلكتروني مطلوب!';

  @override
  String get email_is_not_valid => 'هذا البريد الإلكتروني غير صالح';

  @override
  String get password_is_required => 'كلمة المرور مطلوبة!';

  @override
  String get password_is_not_valid => 'كلمة المرور هذه غير صالحة';

  @override
  String get password_requirements_prefix => 'كلمة المرور ناقصها';

  @override
  String get password_requirements_separator => '، ';

  @override
  String get password_requirement_min_length => '8 أحرف على الأقل';

  @override
  String get password_requirement_uppercase => 'حرف كبير';

  @override
  String get password_requirement_lowercase => 'حرف صغير';

  @override
  String get password_requirement_number => 'رقم';

  @override
  String get password_requirement_special_character => 'رمز خاص مثل !';

  @override
  String get password_must_be_at_least_6_characters =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get passwords_do_not_match => 'كلمتا المرور غير متطابقتين';

  @override
  String get confirm_password_is_required => 'تأكيد كلمة المرور مطلوب!';

  @override
  String get confirm_password_is_not_valid => 'تأكيد كلمة المرور غير صالح';

  @override
  String get password_and_confirm_password_must_be_same =>
      'يجب أن تكون كلمة المرور وتأكيد كلمة المرور متطابقتين!';

  @override
  String get phone_number_is_required => 'رقم الهاتف مطلوب!';

  @override
  String get phone_number_is_not_valid => 'رقم الهاتف هذا غير صالح';

  @override
  String get this_field_is_required => 'هذا الحقل مطلوب';

  @override
  String get error => 'خطأ';

  @override
  String get start_button => 'ابدأ الآن';

  @override
  String get location_service_disabled => 'خدمة الموقع معطلة';

  @override
  String get location_service_disabled_message =>
      'يرجى تفعيل خدمات الموقع والمحاولة مرة أخرى.';

  @override
  String get location_permission_denied => 'تم رفض إذن الموقع';

  @override
  String get location_permission_denied_message =>
      'يرجى السماح بالوصول إلى الموقع للمتابعة.';

  @override
  String get location_permission_denied_forever => 'تم رفض إذن الموقع نهائيًا';

  @override
  String get location_permission_denied_forever_message =>
      'تم رفض إذن الموقع نهائيًا. يرجى تفعيله من إعدادات الجهاز.';

  @override
  String get error_no_internet_connection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get error_no_internet_connection_desc =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get error_connection_timeout_desc =>
      'استغرق الاتصال وقتاً طويلاً. يرجى المحاولة مرة أخرى';

  @override
  String get error_receive_timeout_desc =>
      'استغرق الخادم وقتاً طويلاً للرد. يرجى المحاولة مرة أخرى';

  @override
  String get error_send_timeout_desc =>
      'فشل في إرسال البيانات إلى الخادم. يرجى المحاولة مرة أخرى';

  @override
  String get error_server_error => 'خطأ في الخادم';

  @override
  String get error_server_error_desc =>
      'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';

  @override
  String get error_internal_server_error => 'خطأ داخلي في الخادم';

  @override
  String get error_internal_server_error_desc =>
      'واجه الخادم خطأ داخلي. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_gateway => 'بوابة سيئة';

  @override
  String get error_bad_gateway_desc =>
      'تلقى الخادم استجابة غير صالحة. يرجى المحاولة لاحقاً';

  @override
  String get error_service_unavailable => 'الخدمة غير متاحة';

  @override
  String get error_service_unavailable_desc =>
      'الخدمة غير متاحة مؤقتاً. يرجى المحاولة لاحقاً';

  @override
  String get error_gateway_timeout => 'انتهت مهلة البوابة';

  @override
  String get error_gateway_timeout_desc =>
      'انتهت مهلة البوابة. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_request_desc =>
      'يحتوي الطلب على بيانات غير صالحة. يرجى التحقق من المدخلات';

  @override
  String get error_unauthorized_desc =>
      'أنت غير مصرح للوصول إلى هذا المورد. يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_forbidden_desc => 'ليس لديك إذن للوصول إلى هذا المورد';

  @override
  String get error_not_found_desc => 'المورد المطلوب غير موجود';

  @override
  String get error_method_not_allowed => 'الطريقة غير مسموحة';

  @override
  String get error_method_not_allowed_desc =>
      'هذه الطريقة غير مسموحة لهذا المورد';

  @override
  String get error_not_acceptable => 'غير مقبول';

  @override
  String get error_not_acceptable_desc => 'الطلب غير مقبول';

  @override
  String get error_request_timeout => 'انتهت مهلة الطلب';

  @override
  String get error_request_timeout_desc =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى';

  @override
  String get error_conflict_desc => 'يوجد تعارض مع الحالة الحالية للمورد';

  @override
  String get error_gone => 'المورد غير متاح';

  @override
  String get error_gone_desc => 'المورد المطلوب لم يعد متاحاً';

  @override
  String get error_length_required => 'الطول مطلوب';

  @override
  String get error_length_required_desc => 'يجب أن يحدد الطلب طول المحتوى';

  @override
  String get error_precondition_failed => 'فشل الشرط المسبق';

  @override
  String get error_precondition_failed_desc => 'فشل شرط مسبق واحد أو أكثر';

  @override
  String get error_payload_too_large => 'الحمولة كبيرة جداً';

  @override
  String get error_payload_too_large_desc => 'حمولة الطلب كبيرة جداً';

  @override
  String get error_uri_too_long => 'الرابط طويل جداً';

  @override
  String get error_uri_too_long_desc => 'رابط الطلب طويل جداً';

  @override
  String get error_unsupported_media_type => 'نوع الوسائط غير مدعوم';

  @override
  String get error_unsupported_media_type_desc => 'نوع الوسائط غير مدعوم';

  @override
  String get error_range_not_satisfiable => 'النطاق غير قابل للتحقيق';

  @override
  String get error_range_not_satisfiable_desc => 'لا يمكن تحقيق النطاق المطلوب';

  @override
  String get error_expectation_failed => 'فشل التوقع';

  @override
  String get error_expectation_failed_desc =>
      'لا يمكن تلبية التوقع المحدد في حقل رأس الطلب';

  @override
  String get error_too_many_requests => 'طلبات كثيرة جداً';

  @override
  String get error_too_many_requests_desc =>
      'لقد أرسلت طلبات كثيرة جداً. يرجى المحاولة لاحقاً';

  @override
  String get error_unknown_desc => 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى';

  @override
  String get error_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_cancelled_desc => 'تم إلغاء الطلب';

  @override
  String get error_other => 'حدث خطأ';

  @override
  String get error_other_desc => 'حدث خطأ. يرجى المحاولة مرة أخرى';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get go_back => 'العودة';

  @override
  String get contact_support => 'تواصل مع الدعم';

  @override
  String get check_connection => 'فحص الاتصال';

  @override
  String get auth_title => 'ابدأ الآن';

  @override
  String get auth_subtitle_login => 'مرحبًا بعودتك! سجّل الدخول إلى حسابك';

  @override
  String get auth_subtitle_signup => 'أنشئ حسابًا لاستكشاف تطبيقنا';

  @override
  String get toggle_login => 'تسجيل الدخول';

  @override
  String get toggle_signup => 'إنشاء حساب';

  @override
  String get label_full_name => 'الاسم الكامل';

  @override
  String get label_email => 'البريد الإلكتروني';

  @override
  String get label_phone => 'الهاتف';

  @override
  String get label_password => 'كلمة المرور';

  @override
  String get hint_full_name => 'محمد أحمد';

  @override
  String get hint_email => 'example@gmail.com';

  @override
  String get hint_email_or_phone => 'example@email.com';

  @override
  String get label_email_or_phone => 'البريد الالكتروني';

  @override
  String get hint_phone => '(+966) 726-0592';

  @override
  String get hint_password => 'P@ssw0rd123';

  @override
  String get btn_login => 'تسجيل الدخول';

  @override
  String get btn_signup => 'إنشاء حساب';

  @override
  String get btn_forgot_password => 'هل نسيت كلمة المرور؟';

  @override
  String get forget_password_title => 'نسيت كلمة المرور';

  @override
  String get forget_password_description =>
      'أدخل رقم هاتفك أو بريدك الإلكتروني لاستلام رمز التحقق';

  @override
  String get btn_send_verification_code => 'إرسال رمز التحقق';

  @override
  String get msg_verification_code_sent => 'تم إرسال رمز التحقق بنجاح';

  @override
  String get reset_password_title => 'إعادة تعيين كلمة المرور';

  @override
  String get reset_password_description_prefix => 'أدخل رمز التحقق المرسل إلى';

  @override
  String get label_verification_code => 'رمز التحقق';

  @override
  String get hint_verification_code => 'أدخل رمز التحقق';

  @override
  String get label_new_password => 'كلمة المرور الجديدة';

  @override
  String get hint_new_password => 'أدخل كلمة المرور الجديدة';

  @override
  String get btn_confirm => 'تأكيد';

  @override
  String get msg_password_reset_success => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get verification_code_required => 'يرجى إدخال رمز التحقق';

  @override
  String get verification_code_invalid => 'رمز التحقق غير صالح';

  @override
  String get otp_description => 'أدخل رمز التحقق المرسل إليك';

  @override
  String get otp_code_sent_to => 'تم إرسال الرمز إلى';

  @override
  String get otp_verify_button => 'تحقق';

  @override
  String get otp_complete_code_required => 'يرجى إدخال رمز التحقق كاملًا';

  @override
  String get otp_success_message => 'تم تأكيد الحساب بنجاح';

  @override
  String get otp_screen_title => 'رمز التحقق';

  @override
  String get otp_screen_subtitle => 'أدخل رمز التحقق المرسل إليك لتأكيد حسابك';

  @override
  String get social_divider => 'أو المتابعة باستخدام';

  @override
  String get btn_login_google => 'جوجل';

  @override
  String get btn_login_apple => 'آبل';

  @override
  String get footer_have_account => 'لديك حساب بالفعل؟ ';

  @override
  String get footer_no_account => 'ليس لديك حساب؟ ';

  @override
  String get footer_action_login => 'تسجيل الدخول';

  @override
  String get footer_action_signup => 'إنشاء حساب';

  @override
  String get deliver_to => 'التوصيل إلى';

  @override
  String get location => 'وسط المدينة، نيويورك';

  @override
  String get search_hint => 'ابحث عن المنتجات أو المتاجر...';

  @override
  String get banner_tag => 'عرض محدود';

  @override
  String get banner_title => 'خضروات عضوية طازجة\nحتى 40% خصم';

  @override
  String get banner_subtitle => 'تسوّق طازجًا، وعِش بصحة كل يوم';

  @override
  String get banner_action => 'تسوّق الآن';

  @override
  String get section_special_offers => 'عروض خاصة';

  @override
  String get section_best_selling => 'الأكثر مبيعًا';

  @override
  String get section_featured => 'منتجات مميزة';

  @override
  String get section_recommended => 'مقترح لك';

  @override
  String get section_explore => 'استكشف المزيد';

  @override
  String get see_all => 'عرض الكل';

  @override
  String get refresh => 'تحديث';

  @override
  String get add_to_cart => 'أضف إلى السلة';

  @override
  String get nav_home => 'الرئيسية';

  @override
  String get nav_categories => 'الفئات';

  @override
  String get nav_cart => 'السلة';

  @override
  String get nav_orders => 'الطلبات';

  @override
  String get nav_profile => 'الحساب';

  @override
  String get start_page_title => 'اطلب كل ما تحتاجه بسهولة';

  @override
  String get start_page_subtitle => 'توصيل سريع لكل احتياجاتك اليومية';

  @override
  String get start_page_button => 'ابدأ الآن';

  @override
  String get profile_title => 'الملف الشخصي';

  @override
  String get edit_avatar => 'تعديل الصورة الشخصية';

  @override
  String get personal_info => 'المعلومات الشخصية';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get date_of_birth => 'تاريخ الميلاد';

  @override
  String get gender => 'النوع';

  @override
  String get addresses => 'العناوين';

  @override
  String get add_address => 'إضافة عنوان جديد';

  @override
  String get change_address => 'تغيير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notifications_mark_all_read => 'قراءة الكل';

  @override
  String get notifications_mark_as_read => 'تحديد كمقروء';

  @override
  String get notifications_unread_badge => 'غير مقروء';

  @override
  String get notifications_all_caught_up => 'لا توجد إشعارات غير مقروءة';

  @override
  String get notifications_empty_title => 'لا توجد إشعارات بعد';

  @override
  String get notifications_empty_description =>
      'ستظهر هنا التنبيهات والعروض الجديدة فور وصولها إليك.';

  @override
  String notifications_unread_summary(int count) {
    return 'لديك $count إشعارات غير مقروءة';
  }

  @override
  String notifications_total_summary(int count) {
    return 'إجمالي الإشعارات $count';
  }

  @override
  String get dark_mode => 'الوضع الداكن';

  @override
  String get account => 'الحساب';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get help_support => 'المساعدة والدعم';

  @override
  String get about_app => 'حول التطبيق';

  @override
  String get developer => 'المطور';

  @override
  String get version => 'الإصدار';

  @override
  String get contact_us => 'تواصل معنا';

  @override
  String get select_language => 'اختر اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get about_app_title => 'حول التطبيق';

  @override
  String get app_name => 'تطبيق زادانا للتسوق الذكي';

  @override
  String get version_label => 'الإصدار';

  @override
  String get release_date => 'تاريخ الإصدار';

  @override
  String get app_description =>
      'تطبيق تجارة إلكترونية متكامل يوفّر تجربة تسوق مميزة وسهلة.';

  @override
  String get ok => 'موافق';

  @override
  String get login_success => 'تم تسجيل الدخول بنجاح';

  @override
  String get register_success =>
      'تم إنشاء الحساب بنجاح، يرجى تأكيد بريدك الإلكتروني';

  @override
  String get legal => 'قانوني';

  @override
  String get terms_conditions => 'الشروط والأحكام';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logout_confirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cart_title => 'سلتي';

  @override
  String cart_items_count(Object count) {
    return '$count عناصر';
  }

  @override
  String get current_vendor => 'المتجر الحالي';

  @override
  String get change_vendor => 'تغيير المتجر';

  @override
  String get vendor_change_warning =>
      'تغيير المتجر سيؤثر على جميع المنتجات في سلتك. هل تريد المتابعة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get promo_code => 'رمز الخصم';

  @override
  String get apply => 'تطبيق';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get shipping => 'الشحن';

  @override
  String get discount => 'الخصم';

  @override
  String get total => 'الإجمالي';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get cart_empty => 'سلتك فارغة';

  @override
  String get cart_empty_message => 'ابدأ التسوق وأضف المنتجات إلى سلتك';

  @override
  String get shop_now => 'تسوّق الآن';

  @override
  String get delete_item => 'حذف العنصر';

  @override
  String get delete_item_confirm => 'هل تريد إزالة هذا العنصر من سلتك؟';

  @override
  String get available_vendors => 'المتاجر المتاحة';

  @override
  String get sar => 'ر.س';

  @override
  String get free => 'مجاني';

  @override
  String get quantity => 'الكمية';

  @override
  String get error_connection_timeout => 'انتهت مهلة الاتصال بالخادم';

  @override
  String get error_send_timeout => 'انتهت مهلة إرسال الطلب إلى الخادم';

  @override
  String get error_receive_timeout => 'انتهت مهلة استقبال الرد من الخادم';

  @override
  String get error_bad_certificate => 'شهادة الأمان غير صالحة';

  @override
  String get error_request_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_no_internet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get error_unknown => 'حدث خطأ غير متوقع';

  @override
  String get error_no_response => 'لم يتم استلام أي رد من الخادم';

  @override
  String get error_bad_request => 'طلب غير صالح';

  @override
  String get error_unauthorized => 'غير مصرح، يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_forbidden => 'ليس لديك صلاحية';

  @override
  String get error_not_found => 'المورد غير موجود';

  @override
  String get error_conflict => 'حدث تعارض في البيانات';

  @override
  String get error_validation => 'بيانات الإدخال غير صالحة';

  @override
  String get error_server => 'خطأ في الخادم، يرجى المحاولة لاحقًا';

  @override
  String get locationServicesDisabled => 'خدمات الموقع معطلة';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get locationPermissionDeniedForever => 'تم رفض إذن الموقع نهائيًا';

  @override
  String get unknownError => 'حدث خطأ ما';

  @override
  String get product_details => 'تفاصيل المنتج';

  @override
  String get product_description => 'وصف المنتج';

  @override
  String get product_description_text =>
      'هذا منتج عالي الجودة بميزات ممتازة ومناسب لجميع الاستخدامات.';

  @override
  String get quantity_label => 'الكمية:';

  @override
  String get add_to_cart_button => 'أضف إلى السلة';

  @override
  String get added_to_favorites => 'تمت إضافة المنتج إلى المفضلة';

  @override
  String get removed_from_favorites => 'تمت إزالة المنتج من المفضلة';

  @override
  String product_added_to_cart(Object quantity, Object name) {
    return 'تمت إضافة $quantity من $name إلى السلة';
  }

  @override
  String get buy_now => 'اشترِ الآن';

  @override
  String get store_price_comparison => 'مقارنة أسعار المتاجر';

  @override
  String get fresh_products => 'منتجات طازجة';

  @override
  String get nutrition_info => 'المعلومات الغذائية';

  @override
  String get high_fiber => 'غني بالألياف';

  @override
  String get high_protein => 'غني بالبروتين';

  @override
  String get natural_100 => 'طبيعي 100%';

  @override
  String get available => 'متوفر';

  @override
  String get not_available => 'غير متوفر';

  @override
  String get redirecting_to_checkout => 'جارٍ تحويلك إلى الدفع...';

  @override
  String get cart => 'سلة التسوق';

  @override
  String get product => 'منتج';

  @override
  String get clear_all => 'مسح الكل';

  @override
  String get delete_item_confirmation => 'حذف';

  @override
  String get delete => 'حذف';

  @override
  String get no => 'لا';

  @override
  String get clear_cart => 'تفريغ السلة';

  @override
  String get clear_cart_confirmation =>
      'هل أنت متأكد أنك تريد إزالة جميع العناصر من السلة؟';

  @override
  String get start_shopping => 'ابدأ التسوق';

  @override
  String get start_shopping_message => 'ابدأ التسوق وأضف المنتجات إلى السلة';

  @override
  String get item => 'عنصر';

  @override
  String get complete_from => 'أكمل من';

  @override
  String get compare => 'قارن';

  @override
  String get select_vendor_to_show_price => 'اختر متجرًا لعرض السعر';

  @override
  String get comparison_results => 'نتائج المقارنة';

  @override
  String get save_amount => 'وفّر';

  @override
  String get if_buy_from => 'إذا اشتريت من';

  @override
  String get cheapest => 'الأرخص';

  @override
  String get more_expensive_by => 'أغلى بمقدار';

  @override
  String get currently_selected => 'المحدد حاليًا';

  @override
  String get select_one_more_vendor => 'اختر متجرًا إضافيًا واحدًا على الأقل';

  @override
  String get compare_prices => 'قارن الأسعار';

  @override
  String get select_cheapest => 'اختر';

  @override
  String get select_vendors_to_compare => 'اختر المتاجر للمقارنة';

  @override
  String get select_2_to_3_vendors => 'اختر من متجرين إلى ثلاثة متاجر للمقارنة';

  @override
  String get category_vegetables => 'الخضروات';

  @override
  String get category_fruits => 'الفواكه';

  @override
  String get category_meat => 'اللحوم';

  @override
  String get category_poultry => 'الدواجن';

  @override
  String get category_dairy => 'الألبان';

  @override
  String get category_bakery => 'المخبوزات';

  @override
  String get category_beverages => 'المشروبات';

  @override
  String get category_household => 'المنزل';

  @override
  String get category_personal_care => 'العناية الشخصية';

  @override
  String get category_snacks => 'الوجبات الخفيفة';

  @override
  String get sort_newest => 'الأحدث';

  @override
  String get sort_newest_desc => 'المنتجات المضافة حديثًا';

  @override
  String get sort_price_low => 'السعر من الأقل إلى الأعلى';

  @override
  String get sort_price_low_desc => 'من الأرخص إلى الأغلى';

  @override
  String get sort_price_high => 'السعر من الأعلى إلى الأقل';

  @override
  String get sort_price_high_desc => 'من الأغلى إلى الأرخص';

  @override
  String get sort_best_selling => 'الأكثر مبيعًا';

  @override
  String get sort_best_selling_desc => 'المنتجات الأكثر شراءً';

  @override
  String get sort_highest_rated => 'الأعلى تقييمًا';

  @override
  String get sort_highest_rated_desc => 'بناءً على تقييمات العملاء';

  @override
  String get sort_alphabetical => 'أبجديًا';

  @override
  String get sort_alphabetical_desc => 'من أ إلى ي';

  @override
  String get filter_title => 'تصفية المنتجات';

  @override
  String get sort_title => 'ترتيب المنتجات';

  @override
  String get search_hint_category => 'ابحث عن خضروات أو فواكه أو لحوم...';

  @override
  String get filter_button => 'تصفية';

  @override
  String get sort_button => 'ترتيب';

  @override
  String get all_categories => 'الكل';

  @override
  String get select_product_type => 'اختر نوع المنتج';

  @override
  String get category => 'الفئة';

  @override
  String get price_range => 'نطاق السعر';

  @override
  String get currency => 'ريال';

  @override
  String get filter_type => 'النوع';

  @override
  String get filter_part => 'الجزء';

  @override
  String get filter_brand => 'العلامة التجارية';

  @override
  String get filter_category_title => 'الفئة';

  @override
  String get filter_apply => 'تطبيق التصفية';

  @override
  String get show_more => 'عرض المزيد';

  @override
  String get show_less => 'عرض أقل';

  @override
  String get favorites => 'المفضلة';

  @override
  String get favorites_empty => 'لا توجد منتجات مفضلة';

  @override
  String get favorites_empty_message =>
      'ابدأ بإضافة منتجاتك المفضلة للوصول إليها بسهولة';

  @override
  String get clear_favorites => 'مسح كل المفضلة';

  @override
  String get clear_favorites_confirmation =>
      'هل أنت متأكد أنك تريد إزالة جميع المنتجات من المفضلة؟';

  @override
  String get invoice_details => 'تفاصيل الفاتورة';

  @override
  String get processing => 'جارٍ المعالجة...';

  @override
  String get order_success => 'تم تقديم الطلب بنجاح! ';

  @override
  String get order_number => 'رقم الطلب';

  @override
  String get payment_successful => 'تم الدفع بنجاح! ';

  @override
  String get payment_success_message =>
      'شكرًا لك! تم استلام طلبك وسيتم توصيله قريبًا';

  @override
  String get estimated_delivery => 'وقت التوصيل المتوقع';

  @override
  String get minutes => 'دقائق';

  @override
  String get track_order => 'تتبع الطلب 📍';

  @override
  String get back_to_home => 'العودة إلى الرئيسية';

  @override
  String get my_orders_title => 'طلباتي';

  @override
  String get my_orders_subtitle => 'تتبّع طلباتك الحالية والسابقة بسهولة';

  @override
  String get active_orders_tab => 'النشطة';

  @override
  String get completed_orders_tab => 'المكتملة';

  @override
  String get no_active_orders => 'لا توجد طلبات نشطة';

  @override
  String get no_previous_orders => 'لا توجد طلبات سابقة';

  @override
  String get my_orders_order_date => 'تاريخ الطلب';

  @override
  String get my_orders_items => 'العناصر';

  @override
  String get my_orders_view_details => 'عرض التفاصيل';

  @override
  String get my_orders_cancel_order => 'إلغاء الطلب';

  @override
  String get my_orders_reorder => 'إعادة الطلب';

  @override
  String get my_orders_rate_order => 'تقييم الطلب';

  @override
  String get order_pending => 'قيد الانتظار';

  @override
  String get order_shipped => 'تم الشحن';

  @override
  String get order_delivered => 'تم التسليم';

  @override
  String get order_cancelled => 'تم الإلغاء';

  @override
  String get payment_method => 'طريقة الدفع';

  @override
  String get credit_debit_card => 'بطاقة ائتمان/خصم';

  @override
  String get credit_card_subtitle => 'فيزا، ماستركارد، مدى';

  @override
  String get apple_pay => 'آبل باي';

  @override
  String get apple_pay_subtitle => 'دفع سريع وآمن';

  @override
  String get cash_on_delivery => 'الدفع عند الاستلام';

  @override
  String get cash_on_delivery_subtitle => 'ادفع نقدًا عند وصول الطلب';

  @override
  String get bank_transfer => 'تحويل بنكي';

  @override
  String get bank_transfer_subtitle => 'تحويل مباشر من البنك';

  @override
  String get auth_driver_account_caption => 'حساب السائق';

  @override
  String get auth_login_description =>
      'سجّل الدخول لإدارة رحلاتك وعمليات التسليم الخاصة بك.';

  @override
  String get auth_login_error =>
      'تعذر تسجيل الدخول. تحقق من بياناتك وحاول مرة أخرى.';

  @override
  String get auth_forgot_password_pending =>
      'سيتم ربط نسيت كلمة المرور في الخطوة التالية.';

  @override
  String get auth_signup_caption => 'إنشاء حساب سائق';

  @override
  String get auth_signup_description => 'أدخل بياناتك الأساسية للبدء.';

  @override
  String get auth_continue => 'متابعة';

  @override
  String get driver_profile_caption => 'إكمال الملف الشخصي';

  @override
  String get driver_profile_title => 'بيانات السائق والمركبة';

  @override
  String get driver_profile_subtitle =>
      'أضف صور المستندات وبيانات المركبة لتفعيل حسابك.';

  @override
  String get driver_profile_description =>
      'ارفع الصور المطلوبة واملأ المعلومات الأساسية.';

  @override
  String get driver_profile_save => 'حفظ ومتابعة';

  @override
  String get driver_profile_save_success =>
      'تم حفظ بيانات الملف الشخصي الأولية بنجاح.';

  @override
  String get driver_profile_picker_restart_required =>
      'اختيار الصور يحتاج إلى إعادة تشغيل كاملة للتطبيق بعد إضافة الإضافة.';

  @override
  String get driver_profile_picker_error =>
      'تعذر فتح منتقي الصور. يرجى المحاولة مرة أخرى.';

  @override
  String get driver_profile_identity_section => 'صور الهوية';

  @override
  String get driver_profile_vehicle_section => 'بيانات المركبة';

  @override
  String get driver_profile_vehicle_images_section => 'صور المركبة';

  @override
  String get driver_profile_vehicle_type => 'نوع المركبة';

  @override
  String get driver_profile_vehicle_type_car => 'سيارة';

  @override
  String get driver_profile_vehicle_type_bike => 'دراجة نارية';

  @override
  String get driver_profile_vehicle_type_scooter => 'سكوتر';

  @override
  String get driver_profile_vehicle_type_van => 'فان';

  @override
  String get driver_profile_vehicle_type_bicycle => 'دراجة';

  @override
  String get driver_profile_vehicle_type_truck => 'شاحنة';

  @override
  String get driver_profile_portrait_title => 'الصورة الشخصية للسائق';

  @override
  String get driver_profile_portrait_subtitle => 'صورة شخصية واضحة للسائق.';

  @override
  String get driver_profile_id_front_title => 'الوجه الأمامي للهوية';

  @override
  String get driver_profile_id_front_subtitle =>
      'ارفع صورة الوجه الأمامي للهوية.';

  @override
  String get driver_profile_id_back_title => 'الوجه الخلفي للهوية';

  @override
  String get driver_profile_id_back_subtitle =>
      'ارفع صورة الوجه الخلفي للهوية.';

  @override
  String get driver_profile_license_title => 'رخصة القيادة';

  @override
  String get driver_profile_license_subtitle => 'ارفع صورة واضحة للرخصة.';

  @override
  String get driver_profile_vehicle_photo_title => 'صورة المركبة';

  @override
  String get driver_profile_vehicle_photo_subtitle =>
      'صورة كاملة لمركبة التوصيل.';

  @override
  String get driver_profile_plate_photo_title => 'صورة اللوحة';

  @override
  String get driver_profile_plate_photo_subtitle => 'صورة واضحة للوحة المركبة.';

  @override
  String get driver_profile_brand_label => 'العلامة التجارية';

  @override
  String get driver_profile_brand_hint => 'مثال: تويوتا أو ياماها';

  @override
  String get driver_profile_model_label => 'الموديل';

  @override
  String get driver_profile_model_hint => 'مثال: 2022 أو NMAX';

  @override
  String get driver_profile_plate_label => 'رقم اللوحة';

  @override
  String get driver_profile_plate_hint => 'أدخل رقم اللوحة';

  @override
  String get auth_gate_ready_title => 'جاهز للانطلاق';

  @override
  String get auth_gate_ready_description =>
      'جارٍ تجهيز جلسة السائق وتوجيهك إلى الخطوة التالية المناسبة.';

  @override
  String get auth_login_hero_badge => 'جاهز للتوصيل';

  @override
  String get auth_login_hero_title => 'تسجيل دخول السائق';

  @override
  String get auth_login_hero_subtitle => 'الوصول للطلبات وإدارة نشاطك بسهولة.';

  @override
  String get auth_login_section_badge => 'حساب السائق';

  @override
  String get auth_verify_otp_hero_badge => 'التحقق';

  @override
  String get auth_verify_otp_hero_title => 'أدخل كود التفعيل';

  @override
  String get auth_verify_otp_hero_subtitle =>
      'لن يكتمل تفعيل الحساب قبل تأكيد الكود المرسل إلى بريدك الإلكتروني.';

  @override
  String get auth_verify_otp_section_badge => 'OTP';

  @override
  String get auth_verify_otp_section_title => 'التحقق من حساب المندوب';

  @override
  String get auth_verify_otp_section_description =>
      'راجع بريدك الإلكتروني وأدخل الكود المكوّن من 4 أرقام للمتابعة.';

  @override
  String get auth_verify_otp_identifier_label => 'البريد الإلكتروني';

  @override
  String get auth_verify_otp_code_hint => 'أدخل الكود من 4 أرقام';

  @override
  String get auth_verify_otp_code_helper => 'الكود لازم يكون 4 أرقام فقط.';

  @override
  String get auth_verify_otp_resend_action => 'إعادة إرسال';

  @override
  String get auth_verify_otp_resending => 'جارٍ الإرسال...';

  @override
  String get auth_verify_otp_back_to_login => 'العودة لتسجيل الدخول';

  @override
  String get auth_verify_otp_missing_tokens =>
      'لم يتم استلام بيانات تسجيل الدخول بعد التحقق.';

  @override
  String get auth_signup_hero_badge => 'انضم إلى فريق السائقين';

  @override
  String get auth_signup_hero_title => 'إنشاء حساب سائق';

  @override
  String get auth_signup_hero_subtitle =>
      'ابدأ ببياناتك الأساسية للانضمام سريعًا.';

  @override
  String get auth_signup_section_badge => 'رحلة جديدة';

  @override
  String get auth_forgot_hero_badge => 'استعادة سريعة';

  @override
  String get auth_forgot_hero_subtitle =>
      'استعد الوصول إلى حسابك بخطوات بسيطة.';

  @override
  String get auth_forgot_section_badge => 'استعادة الوصول';

  @override
  String get auth_reset_hero_badge => 'أمان الحساب';

  @override
  String get auth_reset_hero_subtitle => 'عيّن كلمة مرور جديدة لحسابك.';

  @override
  String get auth_reset_section_badge => 'كلمة مرور جديدة';

  @override
  String get auth_confirm_password_label => 'تأكيد كلمة المرور';

  @override
  String get auth_confirm_password_hint => 'أعد إدخال كلمة المرور';

  @override
  String get auth_header_platform_caption => 'منصة التوصيل';

  @override
  String get driver_upload_status_done => 'تم';

  @override
  String get driver_upload_status_upload => 'رفع';

  @override
  String get driver_profile_step_identity_title => 'الهوية';

  @override
  String get driver_profile_step_vehicle_title => 'المركبة';

  @override
  String get driver_profile_step_uploads_title => 'الملفات المرفوعة';

  @override
  String get driver_profile_step_submit_title => 'إرسال';

  @override
  String get driver_profile_step_identity_subtitle =>
      'أدخل بيانات الهوية الرسمية للسائق.';

  @override
  String get driver_profile_step_vehicle_subtitle =>
      'اختر المركبة وأضف بياناتها الأساسية.';

  @override
  String get driver_profile_step_uploads_subtitle =>
      'ارفع الصور والمستندات المطلوبة بوضوح.';

  @override
  String get driver_profile_step_submit_subtitle =>
      'راجع كل شيء وأرسل البيانات النهائية.';

  @override
  String get driver_profile_page_subtitle =>
      'أكمل ملف السائق خطوة بخطوة ضمن تدفق واضح وموجّه.';

  @override
  String get driver_profile_step_back => 'رجوع';

  @override
  String get driver_profile_step_next => 'التالي';

  @override
  String get driver_profile_submit_information => 'إرسال المعلومات';

  @override
  String get driver_profile_images_required_error =>
      'يرجى رفع جميع الصور المطلوبة قبل المتابعة.';

  @override
  String get driver_profile_submit_success => 'تم إرسال معلومات السائق بنجاح.';

  @override
  String get driver_profile_identity_card_title => 'البيانات الشخصية والرسمية';

  @override
  String get driver_profile_identity_card_subtitle =>
      'املأ هذه البيانات بعناية لأنها الأساس لبقية الملف الشخصي.';

  @override
  String get driver_profile_address_label => 'العنوان';

  @override
  String get driver_profile_address_hint => 'مثال: مدينة نصر، شارع عباس العقاد';

  @override
  String get driver_profile_national_id_label => 'الرقم القومي';

  @override
  String get driver_profile_national_id_hint => 'أدخل الرقم القومي';

  @override
  String get driver_profile_national_id_expiry_label => 'تاريخ انتهاء البطاقة';

  @override
  String get driver_profile_license_number_label => 'رقم الرخصة';

  @override
  String get driver_profile_license_number_hint => 'أدخل رقم الرخصة';

  @override
  String get driver_profile_driver_license_expiry_label =>
      'تاريخ انتهاء رخصة القيادة';

  @override
  String get driver_profile_vehicle_license_number_label => 'رقم رخصة المركبة';

  @override
  String get driver_profile_vehicle_license_number_hint =>
      'أدخل رقم رخصة المركبة';

  @override
  String get driver_profile_vehicle_license_expiry_label =>
      'تاريخ انتهاء رخصة المركبة';

  @override
  String get driver_profile_expiry_date_label => 'تاريخ الانتهاء';

  @override
  String get driver_profile_expiry_date_hint => 'اختر تاريخ الانتهاء';

  @override
  String get driver_profile_invalid_date_error => 'أدخل تاريخًا صالحًا.';

  @override
  String get driver_profile_expiry_date_past_error =>
      'تاريخ الانتهاء لا يمكن أن يكون في الماضي.';

  @override
  String get driver_profile_vehicle_card_title => 'بيانات المركبة';

  @override
  String get driver_profile_vehicle_card_subtitle =>
      'اختر المركبة المناسبة لك ثم أكمل بياناتها الأساسية.';

  @override
  String get driver_profile_zone_label => 'منطقة العمل';

  @override
  String get driver_profile_zone_region_label => 'المنطقة';

  @override
  String get driver_profile_zone_city_label => 'المدينة';

  @override
  String get driver_profile_zone_placeholder => 'اختر المنطقة والمدينة';

  @override
  String get driver_profile_zone_region_placeholder => 'اختر المنطقة';

  @override
  String get driver_profile_zone_city_placeholder => 'اختر المدينة';

  @override
  String get driver_profile_zone_hint =>
      'حدد المنطقة ثم المدينة التي تريد بدء استقبال الطلبات منها.';

  @override
  String get driver_profile_zone_loading => 'جارٍ تحميل المناطق والمدن';

  @override
  String get driver_profile_zone_sheet_title => 'اختر نطاق عملك';

  @override
  String get driver_profile_zone_sheet_subtitle =>
      'ابدأ باختيار المنطقة ثم اختر المدينة التي سيتم ربطها بحساب السائق.';

  @override
  String get driver_profile_zone_region_sheet_title => 'اختر المنطقة';

  @override
  String get driver_profile_zone_region_sheet_subtitle =>
      'اختيار المنطقة هيحدد المدن المتاحة لك.';

  @override
  String get driver_profile_zone_city_sheet_title => 'اختر المدينة';

  @override
  String get driver_profile_zone_city_sheet_subtitle =>
      'اختر المدينة التي تريد بدء استقبال الطلبات منها.';

  @override
  String get driver_profile_zone_sheet_region_label => '1. المنطقة';

  @override
  String get driver_profile_zone_sheet_city_label => '2. المدينة';

  @override
  String get driver_profile_zone_empty => 'لا توجد مناطق أو مدن متاحة حاليًا.';

  @override
  String driver_profile_zone_cities_count(String count) {
    return '$count مدن';
  }

  @override
  String get driver_profile_zone_required_error =>
      'لازم تختار المنطقة والمدينة قبل المتابعة.';

  @override
  String get driver_profile_vehicle_required_error =>
      'لازم تختار نوع المركبة قبل المتابعة.';

  @override
  String driver_profile_zone_radius(String radius) {
    return 'نطاق التغطية $radius كم';
  }

  @override
  String driver_profile_vehicle_selected_message(String vehicleType) {
    return 'تم اختيار $vehicleType. تأكد أن الصورة المرفوعة مطابقة لنوع المركبة.';
  }

  @override
  String get driver_profile_vehicle_selected_bike_message =>
      'تم اختيار الدراجة. هذا الإعداد يركز على المرونة وسرعة الحركة في الزحام.';

  @override
  String get driver_profile_vehicle_selected_car_message =>
      'تم اختيار السيارة. هذا الإعداد مناسب للطلبات الأكبر والأكثر تنوعًا.';

  @override
  String get driver_profile_uploads_card_title => 'الصور والمرفقات';

  @override
  String get driver_profile_uploads_card_subtitle =>
      'كل ملف يتم رفعه هنا يجعل بيانات السائق والمركبة أوضح.';

  @override
  String get driver_profile_national_id_card_title => 'البطاقة الشخصية';

  @override
  String get driver_profile_driver_license_card_title => 'رخصة القيادة';

  @override
  String get driver_profile_vehicle_license_card_title => 'رخصة المركبة';

  @override
  String get driver_profile_vehicle_license_title => 'صورة رخصة المركبة';

  @override
  String get driver_profile_vehicle_license_subtitle =>
      'ارفع صورة واضحة لرخصة المركبة.';

  @override
  String get driver_profile_review_card_title => 'المراجعة والإرسال';

  @override
  String get driver_profile_review_card_subtitle =>
      'راجع كل ما أدخلته قبل الإرسال النهائي.';

  @override
  String get driver_profile_uploaded_images_label => 'الصور المرفوعة';

  @override
  String get driver_profile_vehicle_type_label => 'نوع المركبة';

  @override
  String get driver_profile_brand_review_label => 'العلامة التجارية';

  @override
  String get driver_profile_model_review_label => 'الموديل';

  @override
  String get driver_profile_plate_review_label => 'رقم اللوحة';

  @override
  String get driver_profile_incomplete => 'غير مكتمل';

  @override
  String get driver_profile_steps_progress => 'تقدّم الخطوات';

  @override
  String get driver_vehicle_type_car_subtitle =>
      'مثالية للطلبات الأكبر والمتعددة';

  @override
  String get driver_vehicle_type_bike_subtitle =>
      'أسرع داخل طرق المدينة المزدحمة';

  @override
  String get driver_vehicle_type_motorcycle_subtitle =>
      'توازن جيد بين السرعة وقدرة حمل الطلبات داخل المدينة';

  @override
  String get driver_vehicle_type_scooter_subtitle =>
      'خفيف وعملي للمشاوير السريعة داخل الأحياء';

  @override
  String get driver_vehicle_type_van_subtitle =>
      'مناسب للحمولات المتوسطة والطلبات الأكبر حجمًا';

  @override
  String get driver_vehicle_type_bicycle_subtitle =>
      'مناسب للمسافات القصيرة والتنقل السهل داخل الشوارع الضيقة';

  @override
  String get driver_vehicle_type_truck_subtitle =>
      'مخصص للحمولات الثقيلة والشحنات الكبيرة';

  @override
  String get auth_section_badge_default => 'عضو';

  @override
  String get auth_phone_hint_compact => '5xxxxxxxx';

  @override
  String get auth_pending_title => 'حسابك قيد المراجعة';

  @override
  String get auth_pending_description =>
      'تم استلام بياناتك بنجاح. سيقوم فريقنا بمراجعة الحساب وتفعيله قبل بدء استلام الطلبات.';

  @override
  String get auth_pending_notification_hint =>
      'سيصلك إشعار جديد فور الموافقة على الحساب، ويمكنك متابعة كل التنبيهات من زر الإشعارات بالأعلى.';

  @override
  String get auth_pending_eta_hint =>
      'عادةً تتم مراجعة الحساب خلال وقت قصير بعد التأكد من اكتمال البيانات.';

  @override
  String get auth_pending_update_required => 'مطلوب تعديل';

  @override
  String get auth_pending_under_review_badge => 'قيد المراجعة';

  @override
  String get auth_pending_update_short_description =>
      'فيه بيانات أو مستندات محتاجة تعديل.';

  @override
  String get auth_pending_review_short_description =>
      'بياناتك وصلت لفريق المراجعة.';

  @override
  String get auth_pending_note_title => 'ملاحظة';

  @override
  String get auth_pending_notifications_title => 'الإشعارات';

  @override
  String get auth_pending_notifications_update_message =>
      'تابع أي طلب تعديل من زر الإشعارات.';

  @override
  String get auth_pending_notifications_review_message =>
      'سيصلك إشعار أول ما تتم المراجعة.';

  @override
  String get auth_pending_support_title => 'الدعم';

  @override
  String get auth_pending_support_message =>
      'لو محتاج تستفسر عن حالة الحساب أو تبعت شكوى، تقدر تكلم الدعم مباشرة من هنا.';

  @override
  String get driver_account_support_title => 'دعم حساب المندوب';

  @override
  String get driver_account_support_subtitle =>
      'أرسل طلب دعم مباشر بخصوص المراجعة أو الإيقاف أو الحظر أو أي مشكلة تمنع استخدام الحساب.';

  @override
  String get driver_account_support_identifier_label => 'البريد أو رقم الجوال';

  @override
  String get driver_account_support_identifier_hint =>
      'أدخل البريد أو رقم الجوال';

  @override
  String get driver_account_support_reason_label => 'سبب الطلب';

  @override
  String get driver_account_support_message_label => 'الرسالة';

  @override
  String get driver_account_support_message_hint =>
      'اشرح المشكلة أو الطلب بشكل واضح';

  @override
  String get driver_account_support_attach_files => 'إرفاق ملفات';

  @override
  String get driver_account_support_attach_more_files => 'إرفاق ملفات إضافية';

  @override
  String get driver_account_support_submit => 'إرسال طلب الدعم';

  @override
  String get driver_account_support_reason_required => 'اختر سبب طلب الدعم';

  @override
  String get driver_account_support_empty_reasons =>
      'لا توجد أسباب متاحة حاليًا. اسحب للتحديث ثم حاول مرة أخرى.';

  @override
  String get driver_account_support_pick_files_error =>
      'تعذر فتح منتقي الصور. حاول مرة أخرى.';

  @override
  String get driver_account_support_upload_files_error =>
      'تعذر رفع الملفات المرفقة. حاول مرة أخرى.';

  @override
  String get driver_support_case_entry_title => 'تفاصيل الشكوى';

  @override
  String get driver_support_case_entry_retry => 'إعادة تحميل الشكوى';

  @override
  String get driver_support_cases_title => 'الشكاوى والنزاعات';

  @override
  String get driver_support_cases_empty_title => 'لا توجد طلبات دعم حتى الآن';

  @override
  String get driver_support_cases_empty_subtitle =>
      'أي شكوى أو نزاع أو طلب دعم حساب ترسله سيظهر هنا مباشرة.';

  @override
  String get driver_support_case_order_number => 'رقم الطلب';

  @override
  String get driver_support_case_reference => 'مرجع القضية';

  @override
  String get driver_support_case_type_report => 'بلاغ تشغيلي';

  @override
  String get driver_support_case_type_dispute => 'نزاع مالي';

  @override
  String get driver_support_case_type_account => 'دعم الحساب';

  @override
  String get driver_support_case_status_submitted => 'تم الاستلام';

  @override
  String get driver_support_case_status_in_review => 'قيد المراجعة';

  @override
  String get driver_support_case_status_awaiting_evidence => 'بانتظار الإثبات';

  @override
  String get driver_support_case_status_approved => 'تمت الموافقة';

  @override
  String get driver_support_case_status_rejected => 'مرفوضة';

  @override
  String get driver_support_case_status_resolved => 'تم الحل';

  @override
  String get driver_support_case_details_title => 'تفاصيل الشكوى';

  @override
  String get driver_support_case_description_title => 'الوصف';

  @override
  String get driver_support_case_admin_note_title => 'ملاحظة الإدارة';

  @override
  String get driver_support_case_decision_notes_title => 'ملاحظات القرار';

  @override
  String get driver_support_case_attachments_title => 'المرفقات';

  @override
  String get driver_support_case_recent_activity_title => 'آخر النشاطات';

  @override
  String get driver_support_case_add_follow_up_title => 'إضافة متابعة';

  @override
  String get driver_support_follow_up_reason => 'سبب المتابعة';

  @override
  String get driver_support_follow_up_message => 'الرسالة';

  @override
  String get driver_support_follow_up_message_hint =>
      'اكتب أي تفاصيل جديدة أو توضيح إضافي';

  @override
  String get driver_support_attach_files => 'إرفاق ملفات';

  @override
  String get driver_support_attach_more_files => 'إرفاق ملفات إضافية';

  @override
  String get driver_support_send_follow_up => 'إرسال المتابعة';

  @override
  String get driver_support_follow_up_required_error =>
      'اختر سبب المتابعة واكتب الرسالة';

  @override
  String get driver_support_pick_files_error =>
      'تعذر فتح منتقي الصور. حاول مرة أخرى.';

  @override
  String get driver_support_attachment_file_name => 'مرفق.jpg';

  @override
  String get driver_support_upload_files_error =>
      'تعذر رفع الملفات المرفقة. حاول مرة أخرى.';

  @override
  String get driver_support_open_attachment_error => 'تعذر فتح الملف المرفق.';

  @override
  String get driver_support_not_available => '--';

  @override
  String get driver_support_case_reason => 'السبب';

  @override
  String get driver_support_case_last_update => 'آخر تحديث';

  @override
  String get driver_support_case_queue => 'القسم';

  @override
  String get driver_support_case_priority_low => 'منخفضة';

  @override
  String get driver_support_case_priority_medium => 'متوسطة';

  @override
  String get driver_support_case_priority_high => 'عالية';

  @override
  String get driver_support_case_priority_critical => 'حرجة';

  @override
  String get driver_support_reason_customer_unavailable => 'العميل غير متاح';

  @override
  String get driver_support_reason_wrong_address => 'العنوان غير صحيح';

  @override
  String get driver_support_reason_payout_issue => 'مشكلة في المستحقات';

  @override
  String get driver_support_reason_damaged_package => 'الشحنة تالفة';

  @override
  String get driver_support_follow_up_reason_general => 'متابعة عامة';

  @override
  String get driver_support_follow_up_reason_additional_info => 'إضافة تفاصيل';

  @override
  String get driver_support_follow_up_reason_proof_submitted => 'إرسال إثبات';

  @override
  String get driver_support_attachment => 'مرفق';

  @override
  String get driver_support_activity_case_opened => 'تم فتح القضية';

  @override
  String get driver_support_activity_follow_up_added => 'تمت إضافة متابعة';

  @override
  String get driver_support_activity_driver_replied => 'رد المندوب';

  @override
  String get auth_pending_update_details => 'تحديث البيانات';

  @override
  String get auth_pending_review_details => 'مراجعة البيانات';

  @override
  String get driver_account_status_title => 'حالة الحساب';

  @override
  String get driver_account_status_subtitle =>
      'تابع مراجعة كل مستند، والمتطلبات الناقصة، وما الذي يجب تحديثه حتى يكتمل حسابك.';

  @override
  String get profile_rejection_policy_title => 'سياسة رفض العروض';

  @override
  String get profile_rejection_policy_tracking_subtitle =>
      'حدود الرفض اليومية والأسبوعية كما يعرضها النظام';

  @override
  String get profile_rejection_policy_frozen_badge =>
      'استلام العروض موقوف مؤقتًا';

  @override
  String get profile_rejection_policy_status_active => 'نشط';

  @override
  String get profile_rejection_policy_status_frozen => 'مجمّد';

  @override
  String get profile_rejection_policy_summary_active =>
      'تابع حدود الرفض اليومية والأسبوعية بشكل مباشر';

  @override
  String get profile_rejection_policy_summary_frozen =>
      'تم إيقاف استلام العروض مؤقتًا حسب السياسة الحالية';

  @override
  String get profile_rejection_today_label => 'اليوم';

  @override
  String get profile_rejection_today_remaining_label => 'المتبقي اليوم';

  @override
  String get profile_rejection_week_label => 'هذا الأسبوع';

  @override
  String get profile_rejection_week_remaining_label => 'المتبقي هذا الأسبوع';

  @override
  String get driver_account_status_completion_label => 'نسبة اكتمال الملف';

  @override
  String get driver_account_status_account_label => 'حالة الحساب';

  @override
  String get driver_account_status_portrait_ready => 'تم رفع الصورة الشخصية';

  @override
  String get driver_account_status_portrait_missing =>
      'الصورة الشخصية غير مرفوعة';

  @override
  String get driver_account_status_files_label => 'الملفات المرفوعة';

  @override
  String driver_account_status_files_count(int count) {
    return '$count ملف';
  }

  @override
  String get driver_account_status_edit_details => 'تعديل البيانات';

  @override
  String get driver_account_status_update_files => 'تحديث الملفات';

  @override
  String get driver_account_status_edit_personal => 'تعديل البيانات الشخصية';

  @override
  String get driver_account_status_edit_vehicle => 'تعديل المركبة والتواريخ';

  @override
  String get driver_account_status_edit_documents => 'تعديل المستندات المرفوعة';

  @override
  String get driver_account_status_document_valid => 'تمت الموافقة';

  @override
  String get driver_account_status_document_review => 'تحت المراجعة';

  @override
  String get driver_account_status_document_rejected => 'مرفوض';

  @override
  String get driver_account_status_document_expiring => 'منتهي';

  @override
  String get driver_account_status_verification_approved => 'تم اعتماد التحقق';

  @override
  String get driver_account_status_verification_needs_documents =>
      'مطلوب مستندات';

  @override
  String get driver_account_status_verification_under_review => 'قيد المراجعة';

  @override
  String get driver_account_status_account_active => 'نشط';

  @override
  String get driver_account_status_account_pending => 'معلّق';

  @override
  String get driver_account_status_missing_personal_info =>
      'بيانات شخصية ناقصة';

  @override
  String get driver_account_status_missing_vehicle_info =>
      'بيانات المركبة ناقصة';

  @override
  String get driver_account_status_missing_documents => 'مستندات ناقصة';

  @override
  String get driver_account_status_expired_documents => 'مستندات منتهية';

  @override
  String get driver_account_status_rejected_documents => 'مستندات مرفوضة';

  @override
  String get driver_account_status_missing_region_city =>
      'المنطقة والمدينة غير مكتملتين';

  @override
  String get driver_account_status_document_rejected_banner =>
      'يوجد مستند يحتاج تعديلًا';

  @override
  String get driver_account_status_document_approved_banner =>
      'تم اعتماد أحد المستندات';

  @override
  String get driver_account_status_request_docs_banner =>
      'مطلوب استكمال مستندات إضافية';

  @override
  String get auth_blocked_title => 'الحساب محظور مؤقتًا';

  @override
  String get auth_blocked_description =>
      'تم إيقاف الوصول إلى حسابك في الوقت الحالي. إذا كنت تعتقد أن هذا الإجراء بالخطأ، تواصل مع فريق الدعم لمراجعة الحالة.';

  @override
  String get auth_blocked_access_hint =>
      'لن تتمكن من استلام الطلبات أو استخدام مزايا التطبيق إلى حين رفع الحظر أو مراجعة الحساب من الإدارة.';

  @override
  String get auth_blocked_support_hint =>
      'يمكنك الرجوع إلى الدعم والمساعدة لإرسال استفسار أو متابعة سبب الحظر وخطوات استعادة الحساب.';

  @override
  String get auth_blocked_rejection_policy_hint =>
      'يُرفع هذا الحظر اليومي تلقائيًا غدًا حسب يوم الخادم، ما لم يقم المشرف بإزالته قبل ذلك.';

  @override
  String get auth_blocked_rejection_policy_reset_note =>
      'يتم رفع تجميد الرفض اليومي تلقائيًا مع بداية يوم الخادم التالي، ويمكن للمشرف أيضًا إزالة التقييد قبل ذلك.';

  @override
  String get auth_contact_support => 'التواصل مع الدعم';

  @override
  String get auth_logout_account => 'تسجيل الخروج من الحساب';

  @override
  String get auth_session_parse_error =>
      'تعذر قراءة بيانات الجلسة من استجابة تسجيل الدخول.';

  @override
  String get driver_home_accept => 'قبول';

  @override
  String get driver_home_reject => 'رفض';

  @override
  String get driver_home_pickup_label => 'الاستلام';

  @override
  String get driver_home_delivery_label => 'التوصيل';

  @override
  String get driver_home_distance_unit => 'كم';

  @override
  String get driver_home_accept_order_dialog_title => 'تأكيد قبول الطلب';

  @override
  String driver_home_accept_order_dialog_message(
    Object orderTitle,
    Object vendorName,
  ) {
    return 'هل تريد قبول $orderTitle من $vendorName والانتقال إلى تفاصيل الطلب؟';
  }

  @override
  String get driver_home_accept_order_dialog_confirm => 'تأكيد القبول';

  @override
  String get driver_home_reject_order_dialog_title => 'تأكيد رفض الطلب';

  @override
  String driver_home_reject_order_dialog_message(
    Object orderTitle,
    Object vendorName,
  ) {
    return 'هل تريد رفض $orderTitle من $vendorName وانتظار العرض التالي؟';
  }

  @override
  String get driver_home_reject_order_dialog_confirm => 'تأكيد الرفض';

  @override
  String get driver_home_connection_online_title => 'متصل الآن';

  @override
  String get driver_home_connection_offline_title => 'غير متصل';

  @override
  String get driver_home_connection_online_subtitle => 'جاهز للطلبات';

  @override
  String get driver_home_connection_offline_subtitle => 'موقفه مؤقتًا';

  @override
  String get driver_profile_mock_address => 'مدينة نصر، القاهرة';

  @override
  String get driver_profile_mock_national_id => '29801011234567';

  @override
  String get driver_profile_mock_license_number => 'C-452188';

  @override
  String get driver_profile_mock_vehicle_brand => 'ياماها';

  @override
  String get driver_profile_mock_vehicle_model => 'NMAX 2023';

  @override
  String get driver_profile_mock_plate_number => 'س ط ر 2486';

  @override
  String get completed_orders_title => 'الطلبات المكتملة';

  @override
  String get completed_orders_subtitle =>
      'راجع الطلبات التي تم تسليمها أو إلغاؤها أو التي فشل تسليمها ضمن سجل منظم.';

  @override
  String get completed_orders_history_badge => 'أرشيف السجل';

  @override
  String get completed_orders_search_hint =>
      'ابحث برقم الطلب أو التاجر أو العميل أو العنوان';

  @override
  String get completed_orders_filter_all => 'الكل';

  @override
  String get completed_orders_merchant_label => 'التاجر';

  @override
  String get completed_orders_customer_label => 'العميل';

  @override
  String get completed_orders_customer_name_label => 'اسم العميل';

  @override
  String get completed_orders_delivery_address_label => 'عنوان التسليم';

  @override
  String get completed_orders_summary_orders => 'طلب';

  @override
  String get completed_orders_summary_distance => 'كم مسافة';

  @override
  String get completed_orders_distance_label => 'المسافة';

  @override
  String get completed_orders_order_total_label => 'إجمالي الطلب';

  @override
  String get completed_orders_view_details_hint => 'اضغط لعرض التفاصيل';

  @override
  String get completed_orders_customer_section_title => 'بيانات العميل';

  @override
  String get completed_orders_order_details_section_title => 'تفاصيل الطلب';

  @override
  String get completed_orders_items_section_title => 'الأصناف والكميات';

  @override
  String get completed_orders_date_label => 'التاريخ';

  @override
  String get completed_orders_time_label => 'الوقت';

  @override
  String get completed_orders_order_number_prefix => 'طلب';

  @override
  String get completed_orders_empty_title => 'لا توجد طلبات مكتملة بعد';

  @override
  String get completed_orders_empty_subtitle =>
      'ستظهر رحلات السائق المنتهية هنا بعد تسليم الطلب أو إلغائه أو اعتباره فاشلًا.';

  @override
  String get completed_orders_no_results_title => 'لا توجد طلبات مطابقة';

  @override
  String get completed_orders_no_results_subtitle =>
      'جرّب كلمة بحث أخرى أو امسح عامل التصفية النشط.';

  @override
  String get order_delivery_failed => 'فشل التسليم';

  @override
  String get completed_orders_card_title => 'طلبك';

  @override
  String get nav_wallet => 'المحفظة';

  @override
  String get wallet_title => 'المحفظة';

  @override
  String get wallet_subtitle =>
      'تابع رصيدك الحالي، وجاهزية السحب، والحوافز، وكل حركة في لوحة تحكم متميزة.';

  @override
  String get wallet_subtitle_secure =>
      'راجع رصيدك الحالي، وآخر الحركات، وجاهزية السحب من خلال مركز محفظة آمن.';

  @override
  String get wallet_subtitle_ready => 'صافي الرصيد المتاح جاهز للسحب الآن.';

  @override
  String get wallet_subtitle_add_primary => 'أضف وسيلة سحب أساسية لبدء السحب.';

  @override
  String get wallet_subtitle_cod_blocked =>
      'السحب متوقف حتى تتم تسوية مستحق COD.';

  @override
  String get wallet_subtitle_no_withdrawable =>
      'لا يوجد صافي رصيد متاح للسحب حاليًا.';

  @override
  String get wallet_preview_state => 'حالة المعاينة';

  @override
  String get wallet_state_success => 'نجاح';

  @override
  String get wallet_state_empty => 'فارغ';

  @override
  String get wallet_state_error => 'خطأ';

  @override
  String get wallet_current_balance => 'الرصيد الحالي';

  @override
  String get wallet_available_to_withdraw => 'المتاح للسحب';

  @override
  String get wallet_pending_balance => 'الرصيد المعلّق';

  @override
  String get wallet_cod_owed_balance => 'مستحق COD';

  @override
  String get wallet_withdraw_cta => 'اسحب الآن';

  @override
  String get wallet_withdraw_success => 'تم إنشاء طلب السحب بنجاح.';

  @override
  String get wallet_earnings_summary => 'ملخص الأرباح';

  @override
  String get wallet_metric_today => 'اليوم';

  @override
  String get wallet_metric_week => 'هذا الأسبوع';

  @override
  String get wallet_metric_month => 'هذا الشهر';

  @override
  String get wallet_transaction_history => 'سجل المعاملات';

  @override
  String get wallet_payment_methods => 'طرق الدفع';

  @override
  String get wallet_bonuses => 'المكافآت والحوافز';

  @override
  String get wallet_alerts => 'تنبيهات المحفظة';

  @override
  String get wallet_primary_method => 'أساسي';

  @override
  String get wallet_unverified_method => 'يحتاج إلى تحقق';

  @override
  String get wallet_bonus_progress => 'مكتمل';

  @override
  String get wallet_bonus_unlock_before => 'افتحه قبل';

  @override
  String get wallet_empty_title => 'محفظتك جاهزة لأول عملية سحب';

  @override
  String get wallet_empty_subtitle =>
      'أكمل بعض رحلات التوصيل وستظهر أرباحك وسجلك وخيارات السحب هنا.';

  @override
  String get wallet_error_title => 'تعذر تحميل المحفظة الآن';

  @override
  String get wallet_error_subtitle =>
      'لم نتمكن من جلب أحدث حالة للمحفظة. حاول مرة أخرى بعد قليل.';

  @override
  String get wallet_retry => 'حاول مرة أخرى';

  @override
  String get wallet_status_completed => 'مكتمل';

  @override
  String get wallet_status_ready => 'جاهز';

  @override
  String get wallet_status_blocked => 'متوقف';

  @override
  String get wallet_status_pending => 'قيد الانتظار';

  @override
  String get wallet_status_failed => 'فشل';

  @override
  String get wallet_transaction_delivery => 'أرباح التوصيل';

  @override
  String get wallet_transaction_withdrawal => 'تم صرف السحب';

  @override
  String get wallet_transaction_bonus => 'صرف مكافأة';

  @override
  String get wallet_transaction_refund => 'استرجاع/عكس';

  @override
  String get wallet_transaction_settlement => 'تسوية';

  @override
  String get wallet_transaction_adjustment => 'تعديل على المحفظة';

  @override
  String get wallet_transaction_cash_collected => 'تحصيل/توريد COD';

  @override
  String get wallet_transaction_hold => 'رصيد محتجز';

  @override
  String get wallet_transaction_release => 'رصيد تم الإفراج عنه';

  @override
  String get wallet_transaction_credit => 'إضافة';

  @override
  String get wallet_transaction_debit => 'خصم';

  @override
  String get wallet_transaction_generic => 'حركة على المحفظة';

  @override
  String get wallet_direction_in => 'داخل';

  @override
  String get wallet_direction_out => 'خارج';

  @override
  String get wallet_payment_bank_account => 'حساب بنكي';

  @override
  String get wallet_payment_mobile_wallet => 'محفظة إلكترونية';

  @override
  String get wallet_payment_debit_card => 'بطاقة خصم';

  @override
  String get wallet_payment_instant_transfer => 'تحويل فوري';

  @override
  String get wallet_withdrawal_requests => 'طلبات السحب';

  @override
  String get wallet_pending_requests => 'الطلبات المعلقة';

  @override
  String get wallet_pending_requests_amount => 'المبلغ المعلق';

  @override
  String get wallet_total_requests => 'إجمالي الطلبات';

  @override
  String get wallet_view_all => 'عرض الكل';

  @override
  String get wallet_transactions_empty_title => 'لا توجد معاملات للمحفظة بعد';

  @override
  String get wallet_transactions_empty_subtitle =>
      'ستظهر هنا أرباح التوصيل وحركات المحفظة بعد بدء النشاط.';

  @override
  String get wallet_withdrawals_empty_title => 'لا توجد طلبات سحب بعد';

  @override
  String get wallet_withdrawals_empty_subtitle =>
      'سيظهر سجل طلبات السحب هنا بعد أول طلب سحب.';

  @override
  String get wallet_load_more => 'تحميل المزيد';

  @override
  String get wallet_add_method => 'إضافة وسيلة';

  @override
  String get wallet_methods_empty_title => 'لا توجد وسائل سحب مضافة';

  @override
  String get wallet_methods_empty_subtitle =>
      'أضف وسيلة سحب آمنة لبدء سحب رصيد محفظتك.';

  @override
  String get wallet_withdraw_title => 'إنشاء طلب سحب';

  @override
  String get wallet_withdraw_info_hint =>
      'تتم معالجة طلبات السحب بشكل آمن باستخدام وسيلة السحب التي تختارها.';

  @override
  String get wallet_withdraw_amount_subtitle =>
      'أدخل المبلغ الذي تريد تحويله من رصيد محفظتك.';

  @override
  String get wallet_withdraw_method_subtitle =>
      'اختر استخدام وسيلة السحب الأساسية أو حدد وسيلة محفوظة أخرى.';

  @override
  String get wallet_amount_label => 'المبلغ';

  @override
  String get wallet_amount_hint => 'أدخل المبلغ';

  @override
  String get wallet_amount_invalid => 'أدخل مبلغًا أكبر من صفر.';

  @override
  String get wallet_amount_exceeds_balance => 'المبلغ أكبر من الرصيد المتاح.';

  @override
  String get wallet_use_primary_method => 'استخدم وسيلة السحب الأساسية';

  @override
  String get wallet_no_primary_method => 'لا توجد وسيلة أساسية متاحة';

  @override
  String get wallet_withdraw_blocked_no_primary =>
      'أضف وسيلة سحب أساسية قبل طلب السحب.';

  @override
  String get wallet_withdraw_blocked_cod =>
      'يجب تسوية النقد المحصل COD قبل طلب السحب.';

  @override
  String get wallet_withdraw_blocked_no_balance =>
      'قيمة السحب أكبر من صافي الرصيد المتاح بعد التزامات COD.';

  @override
  String get wallet_select_method => 'اختر وسيلة سحب.';

  @override
  String get wallet_method_saved => 'تمت إضافة وسيلة السحب بنجاح.';

  @override
  String get wallet_method_updated => 'تم تحديث وسيلة السحب بنجاح.';

  @override
  String get wallet_method_deleted => 'تم حذف وسيلة السحب بنجاح.';

  @override
  String get wallet_make_primary => 'تعيين كأساسية';

  @override
  String get wallet_primary_updated => 'تم تحديث وسيلة السحب الأساسية.';

  @override
  String get wallet_delete_method_title => 'حذف وسيلة السحب؟';

  @override
  String get wallet_delete_method_message =>
      'سيتم حذف وسيلة السحب إذا لم تكن مرتبطة بسجل طلبات سحب.';

  @override
  String get wallet_edit_method_title => 'تعديل وسيلة السحب';

  @override
  String get wallet_type_label => 'نوع الوسيلة';

  @override
  String get wallet_account_holder_label => 'اسم صاحب الحساب';

  @override
  String get wallet_provider_name_label => 'اسم الجهة';

  @override
  String get wallet_account_identifier_label => 'معرّف الحساب';

  @override
  String get wallet_identifier_reentry_hint =>
      'أعد إدخال المعرّف كاملًا للحفاظ على أمان وسيلة السحب.';

  @override
  String get wallet_identifier_secure_hint =>
      'يتم إرسال المعرّف الكامل بشكل آمن ولا يظهر مرة أخرى داخل واجهة المحفظة.';

  @override
  String get wallet_save_action => 'حفظ';

  @override
  String get wallet_status_processing => 'قيد المعالجة';

  @override
  String get wallet_status_paid => 'تم الدفع';

  @override
  String get wallet_status_cancelled => 'تم الإلغاء';

  @override
  String get wallet_transfer_reference => 'مرجع التحويل';

  @override
  String get wallet_bonus_weekend => 'تحدي نهاية الأسبوع';

  @override
  String get wallet_bonus_consistency => 'سلسلة الاستمرارية';

  @override
  String get wallet_bonus_peak_hours => 'تعزيز ساعات الذروة';

  @override
  String get wallet_alert_verification_title => 'تحقق من حساب السحب الخاص بك';

  @override
  String get wallet_alert_verification_subtitle =>
      'تحقق سريع من الحساب يحافظ على سلاسة وأمان عمليات السحب.';

  @override
  String get wallet_alert_payout_title => 'السحب قيد المعالجة';

  @override
  String get wallet_alert_payout_subtitle =>
      'تم إدراج آخر طلب سحب لديك في قائمة المعالجة، ويُفترض أن يصل خلال المدة المتوقعة للتسوية.';

  @override
  String get wallet_cod_block_title => 'مستحق COD يمنع السحب';

  @override
  String get wallet_cod_block_subtitle =>
      'يجب أن تنهي الإدارة مطابقة توريد COD قبل أن تتمكن من السحب من المحفظة.';

  @override
  String get wallet_alert_incentive_title => 'تم فتح حافز جديد';

  @override
  String get wallet_alert_incentive_subtitle =>
      'أنت قريب من الحصول على مكافأة إضافية للسائق خلال ساعات التوصيل المزدحمة.';

  @override
  String get wallet_alert_action_verify => 'تحقق';

  @override
  String get wallet_alert_action_view => 'عرض';

  @override
  String get wallet_alert_action_claim => 'استلام';

  @override
  String get profile_edit_profile_title => 'تعديل الملف الشخصي';

  @override
  String get profile_edit_profile_subtitle =>
      'حدّث بياناتك الشخصية وبيانات المركبة والمرفقات';

  @override
  String get profile_language_subtitle => 'الإنجليزية';

  @override
  String get profile_notifications_subtitle =>
      'افتح الإشعارات وأدر تفضيلات التنبيه';

  @override
  String get profile_change_password_subtitle =>
      'افتح إعدادات الأمان لإدارة كلمة المرور';

  @override
  String get profile_update_action => 'تحديث';

  @override
  String get profile_support_subtitle => 'تواصل معنا أو تصفح موارد المساعدة';

  @override
  String get profile_privacy_subtitle =>
      'اطّلع على كيفية جمع البيانات وتخزينها واستخدامها';

  @override
  String get profile_logout_subtitle => 'سجّل الخروج من هذا الجهاز بأمان';

  @override
  String get profile_logout_success => 'تم تسجيل الخروج بنجاح';

  @override
  String get profile_language_info =>
      'إعدادات اللغة متاحة حاليًا باللغة الإنجليزية';

  @override
  String get profile_default_name => 'اسم المستخدم';

  @override
  String get profile_default_email => 'example@zadana.com';

  @override
  String get profile_default_phone => '+20 100 000 0000';

  @override
  String get profile_security_documents_title => 'الأمان والمستندات';

  @override
  String profile_documents_uploaded_count(Object count) {
    return 'المستندات المرفوعة: $count/5';
  }

  @override
  String get profile_current_documents => 'المستندات الحالية';

  @override
  String get profile_not_uploaded_yet => 'لم يتم الرفع بعد';

  @override
  String get profile_personal_info_saved => 'تم حفظ المعلومات الشخصية بنجاح';

  @override
  String get profile_vehicle_info_saved => 'تم حفظ بيانات المركبة بنجاح';

  @override
  String get profile_security_documents_saved =>
      'تم حفظ بيانات الأمان والمستندات بنجاح';

  @override
  String get order_details_title => 'تفاصيل الطلب';

  @override
  String get order_details_distance_label => 'المسافة';

  @override
  String get order_details_accept_order => 'قبول الطلب';

  @override
  String get order_details_reject_order => 'رفض';

  @override
  String get order_details_show_pickup_code => 'عرض كود الاستلام من المتجر';

  @override
  String get order_details_start_delivery => 'بدء التوصيل للعميل';

  @override
  String get order_details_confirm_delivery_with_code =>
      'تأكيد التسليم برمز العميل';

  @override
  String get order_details_order_delivered => 'تم تسليم الطلب';

  @override
  String get order_details_customer_details_title => 'بيانات العميل';

  @override
  String get order_details_customer_name_label => 'اسم العميل';

  @override
  String get order_details_customer_address_label => 'عنوان العميل';

  @override
  String get order_details_pickup_details_title => 'بيانات الاستلام';

  @override
  String get order_details_store_label => 'المتجر';

  @override
  String get order_details_store_address_label => 'عنوان المتجر';

  @override
  String get order_details_open_customer_location => 'افتح موقع العميل';

  @override
  String get order_details_open_customer_location_hint =>
      'يفتح لك موقع العميل في تطبيق الخرائط';

  @override
  String get order_details_open_store_location => 'افتح موقع المتجر';

  @override
  String get order_details_open_store_location_hint =>
      'يفتح لك موقع المتجر على الخريطة';

  @override
  String get order_details_customer_otp_hint => 'اكتب رمز تسليم العميل';

  @override
  String get order_details_customer_otp_title => 'تأكيد تسليم الطلب';

  @override
  String get order_details_customer_otp_subtitle =>
      'خذ رمز التسليم من العميل واكتبه هنا عشان نكمل تسليم الطلب';

  @override
  String get order_details_confirm_delivery => 'تأكيد التسليم';

  @override
  String get order_details_resend_otp => 'إعادة إرسال الرمز';

  @override
  String order_details_resend_otp_in(int seconds) {
    return 'إعادة الإرسال خلال $seconds ث';
  }

  @override
  String get order_details_pickup_code_title => 'كود استلام الطلب';

  @override
  String get order_details_pickup_code_subtitle =>
      'اعرض هذا الكود للمتجر حتى يتم تسليم الطلب لك';

  @override
  String get order_details_pickup_code_copied => 'تم نسخ كود الاستلام';

  @override
  String get order_details_waiting_for_merchant_confirmation =>
      'في انتظار تأكيد التاجر...';

  @override
  String get order_details_confirm_pickup => 'تأكيد الاستلام من المتجر';

  @override
  String get order_details_arrived_at_vendor => 'وصلت إلى المتجر';

  @override
  String get order_details_arrived_at_customer => 'وصلت إلى العميل';

  @override
  String get order_details_order_items_title => 'أصناف الطلب';

  @override
  String get order_details_items_unit => 'صنف';

  @override
  String get order_details_pieces_unit => 'قطعة';

  @override
  String get order_details_route_map_title => 'خريطة المسار';

  @override
  String get order_details_map_hint => 'اسحب وكبر الخريطة';

  @override
  String get order_details_items_details_title => 'تفاصيل الطلب المستلم';

  @override
  String get order_details_total_pieces_label => 'إجمالي القطع';

  @override
  String get order_details_items_count_label => 'عدد الأصناف';

  @override
  String get order_details_view_products => 'عرض المنتجات';

  @override
  String get order_details_status_accepted => 'تم قبول الطلب';

  @override
  String get order_details_status_picked_up => 'تم الاستلام من المتجر';

  @override
  String get order_details_status_on_the_way => 'في الطريق للعميل';

  @override
  String get order_details_status_delivered => 'تم التسليم';

  @override
  String get order_details_sheet_hint =>
      'في النسخة التجريبية تقدر تكتب أي 4 أرقام للتأكيد';

  @override
  String get order_details_enter_otp_snackbar => 'اكتب الرمز عشان نأكد التسليم';

  @override
  String get order_details_package_note_fallback =>
      'راجع عدد القطع وتأكد إن التغليف مقفول قبل التحرك.';

  @override
  String get order_details_accept_dialog_title => 'تأكيد قبول الطلب';

  @override
  String order_details_accept_dialog_message(Object orderTitle) {
    return 'هل تريد قبول $orderTitle والبدء في تنفيذ الطلب الآن؟';
  }

  @override
  String get order_details_accept_dialog_confirm => 'تأكيد القبول';

  @override
  String get order_details_pickup_dialog_title => 'تأكيد الاستلام من المتجر';

  @override
  String order_details_pickup_dialog_message(Object vendorName) {
    return 'هل تؤكد استلام الطلب من $vendorName وأن كل الأصناف جاهزة معك؟';
  }

  @override
  String get order_details_pickup_dialog_confirm => 'تأكيد الاستلام';

  @override
  String get order_details_arrived_vendor_dialog_title =>
      'تأكيد الوصول إلى المتجر';

  @override
  String order_details_arrived_vendor_dialog_message(String vendorName) {
    return 'هل تؤكد أنك وصلت إلى $vendorName؟';
  }

  @override
  String get order_details_arrived_vendor_dialog_confirm => 'تأكيد الوصول';

  @override
  String get order_details_start_delivery_dialog_title => 'تأكيد بدء التوصيل';

  @override
  String get order_details_start_delivery_dialog_message =>
      'هل تريد بدء التوجه إلى العميل الآن؟';

  @override
  String get order_details_start_delivery_dialog_confirm => 'بدء التوصيل';

  @override
  String get order_details_arrived_customer_dialog_title =>
      'تأكيد الوصول إلى العميل';

  @override
  String get order_details_arrived_customer_dialog_message =>
      'هل تؤكد أنك وصلت إلى موقع العميل؟';

  @override
  String get order_details_arrived_customer_dialog_confirm => 'تأكيد الوصول';

  @override
  String get order_details_delivered_dialog_title => 'تأكيد تسليم الطلب';

  @override
  String get order_details_delivered_dialog_message =>
      'هل تؤكد أن الطلب تم تسليمه بنجاح؟';

  @override
  String get order_details_delivered_dialog_confirm => 'تأكيد التسليم';

  @override
  String get order_delivery_success_title => 'تم تسليم الطلب بنجاح';

  @override
  String get order_delivery_success_subtitle =>
      'أحسنت، تم إغلاق الرحلة بنجاح ويمكنك الآن الرجوع لمتابعة الطلبات الجديدة.';

  @override
  String get order_delivery_success_button => 'العودة للرئيسية';

  @override
  String get order_details_call_failure =>
      'تعذر فتح تطبيق الاتصال على هذا الجهاز';

  @override
  String get order_details_maps_failure =>
      'تعذر فتح تطبيق الخرائط على هذا الجهاز';
}
