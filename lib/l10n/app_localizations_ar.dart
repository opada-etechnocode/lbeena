// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get language => 'اللغة';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get welcome_to_company => 'أهلاً بك في لبينا';

  @override
  String get login_to_continue => 'سجل الدخول للمتابعة';

  @override
  String get login => 'دخول';

  @override
  String get delete_sure_account => 'هل أنت متأكد من حذف الحساب ؟';

  @override
  String get password => 'كلمة المرور';

  @override
  String get sure => 'تأكيد';

  @override
  String get choose_date => 'اختر تاريخ انتهاء الرخصة';

  @override
  String get choose_date_license => 'تاريخ انتهاء الرخصة';

  @override
  String get choose_date_license2 => 'يجب تحديد تاريخ انتهاء الصلاحية';

  @override
  String get error_data => 'خطأ بالتحميل, الرجاء المحاولة مرة أخرى';

  @override
  String get dont_have_product => 'لايوجد إعلانات ';

  @override
  String get login_in_app => 'تسجيل الدخول';

  @override
  String get offer => 'عروض';

  @override
  String get or => 'أو';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get about_app => 'عن التطبيق';

  @override
  String get field_is_empty => 'الحقل فارغ';

  @override
  String get confirm_number => 'يرجى التأكد من الرقم';

  @override
  String get send_otp_tow => 'ارسال ال OTP مرة ثانية';

  @override
  String get send_otp_pas =>
      'كلمة مرور واحد OTP ستصلك على الواتس آب أو رسالة قصيرة';

  @override
  String get new_password => 'كلمة المرور الجديدة';

  @override
  String get login_guest => 'الدخول كضيف';

  @override
  String get forget_password => 'هل نسيت كلمة المرور؟';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get dont_have_account => 'ليس لديك حساب؟';

  @override
  String get sign_up => 'تسجيل جديد';

  @override
  String get individual_account => 'حساب فردي';

  @override
  String get company_account => 'حساب شركة';

  @override
  String get user_name => 'اسم المستخدم';

  @override
  String get confirm_password => 'تأكيد كلمة المرور';

  @override
  String get agree_terms => 'الموافقة على شروط و سياسة التطبيق';

  @override
  String get do_you_have_account => 'هل لديك حساب؟';

  @override
  String get send_otp => 'أرسل الكود';

  @override
  String get mobile_number => 'رقم الجوال';

  @override
  String get company_registration => 'إكمال التسجيل';

  @override
  String get company_name => 'اسم الشركة (كما في الرخصة)';

  @override
  String get owner_name => 'اسم الشخص المسؤول';

  @override
  String get license_number => 'رقم الرخصة';

  @override
  String get emirate => 'الإمارة';

  @override
  String get upload_license => 'تحميل الرخصة التجارية';

  @override
  String get remove => 'إزالة';

  @override
  String get company_activity => 'نشاط الشركة';

  @override
  String get license_exp_date => 'تاريخ انتهاء الرخصة';

  @override
  String otp_send_to(String mobile) {
    return 'تم إرسال رمز التحقق إلى $mobile';
  }

  @override
  String get didnt_receive => 'لم تستلم؟';

  @override
  String please_wait(String time) {
    return 'يرجى الانتظار $time';
  }

  @override
  String get resend => 'إعادة الإرسال';

  @override
  String get verify => 'التحقق';

  @override
  String get msg_valid_code => 'يرجى إدخال رمز التحقق الصحيح';

  @override
  String get msg_otp_failed => 'فشل التحقق من رمز التحقق';

  @override
  String get msg_upload_license => 'يرجى تحميل رخصة التجارة!';

  @override
  String get msg_exp_date => 'يرجى تحديد تاريخ انتهاء صلاحية رخصة التجارة!';

  @override
  String get msg_pw_six_char =>
      'يجب أن تكون كلمة المرور مكونة على الأقل من ستة أحرف!';

  @override
  String get msg_agree_terms => 'يرجى الموافقة على شروطنا';

  @override
  String get msg_pw_not_match => 'كلمات المرور غير متطابقة';

  @override
  String get view => 'عرض';

  @override
  String get archived_research => 'البحوثات المحفوظة';

  @override
  String get customer_support => 'خدمة دعم العملاء';

  @override
  String get report_problem => 'الإبلاغ عن مشكلة';

  @override
  String get contact_us => 'اتصل بنا';

  @override
  String get terms => 'الأحكام و الشروط';

  @override
  String get privacy => 'الخصوصية والسياسة';

  @override
  String get delete_account => 'حذف الحساب';

  @override
  String get dark_mode => 'الوضع الليلي';

  @override
  String get lite_mode => 'الوضع النهاري';

  @override
  String get home_page => 'الرئيسية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get are_you_sure => 'هل أنت متأكد؟';

  @override
  String get are_you_sure_des => 'هل أنت متأكد أنك تريد القيام بذلك؟';

  @override
  String get no => 'لا';

  @override
  String get yes => 'نعم';

  @override
  String get search => 'منتج، اسم شركة،';

  @override
  String get do_you_want_add_wahtsapp => 'هل تريد إضافة رقم الواتساب؟؟';

  @override
  String get do_you_want_add_coupons => 'هل تريد إضافة كوبون خصم؟؟';

  @override
  String get do_you_want_add_chats => 'هل تريد تفعيل الدردشة؟؟';

  @override
  String get error_size_photo => 'خطأ: حجم الصورة أكبر من 1 ميغابايت';

  @override
  String get search_hint => 'منتج، اسم شركة، ....';

  @override
  String get main_categories => 'الأقسام الرئيسية';

  @override
  String get top_companies => 'المعلنين المميزين:';

  @override
  String get top_ads => 'إعلانات مميزة';

  @override
  String get new_ads => 'إعلانات مضافة حديثا';

  @override
  String get add_ad => 'أعلن هنا';

  @override
  String get choose_section => 'اختر القسم الذي تريد أن يظهر إعلانك فيه:';

  @override
  String get main_category => 'أقسام الخالدي';

  @override
  String get normal_category => 'قسم آخر';

  @override
  String get choose_ad_type => 'اختيار نوع الإعلان:';

  @override
  String get banner_ad => 'إعلان بنر';

  @override
  String get product_ad => 'إعلان منتج';

  @override
  String get ad_name => 'إضافة الاسم:';

  @override
  String get add_name_here => 'أضف اسم هنا ..';

  @override
  String get must_choose_photo => 'يجب اختيار صورة للبنر';

  @override
  String get should_link_active => 'يرجى إدخال رابط فعال ..';

  @override
  String get choose_parts => 'يجب اختيار قسم من الأقسام في الأعلى';

  @override
  String get add_price => 'السعر :';

  @override
  String get chose_price_less => 'يرجى اختيار سعر أقل من 500 ألف درهم';

  @override
  String get ad_name_hint => 'اسم الإعلان باللغة الانجليزية';

  @override
  String get ad_name_hint_ar => 'اسم الإعلان هنا باللغة العربية';

  @override
  String get add_photo => 'إضافة صورة:';

  @override
  String get publish_method => 'عند النقر على إعلانك يفتح:';

  @override
  String get link_type => 'رابط خارجي';

  @override
  String get description_method => 'وصف داخل التطبيق';

  @override
  String get add_link => 'إضافة الرابط:';

  @override
  String get pay_now => 'دفع الآن';

  @override
  String get add_description => 'إضافة الوصف:';

  @override
  String get description_hint => 'اكتب الوصف هنا ..';

  @override
  String get description_hint_ar => 'اكتب الوصف هنا باللغة العربية';

  @override
  String get add => 'إضافة';

  @override
  String get must_choose_less_one => 'يجب اختيار صورة واحدة على الأقل';

  @override
  String get download_data => 'جاري التحميل ..';

  @override
  String get less_photo => '5 صور أو أقل ..';

  @override
  String get submit => 'إرسال';

  @override
  String get link => 'رابط';

  @override
  String get dont_have_result => 'لايوجد نتائج ..';

  @override
  String get link_hint => 'الصق الرابط هنا';

  @override
  String get whats_app_number => 'رقم واتس آب:';

  @override
  String get whats_app_number_hint => 'اكتب رقم واتس آب';

  @override
  String get sign_in_process => 'جاري تسجيل الدخول...';

  @override
  String get want_to_highlight => 'هل تريد تمييز إعلانك؟؟';

  @override
  String get price => 'السعر (اختياري) :';

  @override
  String get price_hint => 'اكتب السعر هنا';

  @override
  String get req_for_banner => 'طلب تصميم من لوحة التحكم الإدارية';

  @override
  String get msg_add_ad => 'تم تقديم إعلانك، انتظر الموافقة';

  @override
  String get msg_select_category => 'يرجى تحديد الفئة';

  @override
  String get msg_banner_img_required => 'الصورة البانر مطلوبة!';

  @override
  String get msg_add_images => 'يرجى إضافة صور أو فيديوهات';

  @override
  String get msg_company_not_available => 'الشركة غير متوفرة!';

  @override
  String get all_ads => 'جميع الإعلانات';

  @override
  String get top_rated_ads => 'إعلانات أكثر تقييما';

  @override
  String get book_ad_space => 'احجز مساحة إعلانية هنا';

  @override
  String get selected_videos => ' إعلانات مختارة من قنوات الخالدي:';

  @override
  String get info => 'عن الشركة';

  @override
  String get share => 'مشاركة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get packages => 'بكجاتي';

  @override
  String joined_on(String date) {
    return 'تاريخ الانضمام: $date ';
  }

  @override
  String get safety_tips => 'نصائح السلامة';

  @override
  String get faq => 'أسئلة متكررة';

  @override
  String items(String count) {
    return '$count أغراض';
  }

  @override
  String get add_coupon => 'إحصل على كود خصم :';

  @override
  String get click_here => 'حك هنا';

  @override
  String get views => 'إحصاء:';

  @override
  String get details => 'التفاصيل:';

  @override
  String get distinction => 'تمييز';

  @override
  String get w_app => 'واتساب';

  @override
  String get chat => 'الدردشة';

  @override
  String get coupons => 'كوبونات';

  @override
  String get login_first => 'الرجاء تسجيل الدخول أولاً';

  @override
  String get notifications => 'الإشعارات';

  @override
  String coupon_info_company(String name) {
    return 'اسم الشركة: $name';
  }

  @override
  String coupon_info_category(String name) {
    return 'نوع الإعلان: $name';
  }

  @override
  String coupon_info_discount(String discount) {
    return 'نسبة الخصم: $discount';
  }

  @override
  String coupon_info_date(String date) {
    return 'تاريخ القسيمة: $date';
  }

  @override
  String get close => 'يغلق';

  @override
  String get my_profile => 'ملفي الشخصي';

  @override
  String get book_plan => 'احجز خطة جديدة هنا';

  @override
  String buy_package_for(String price) {
    return 'لـ $price';
  }

  @override
  String valid_days(String days) {
    return 'صالح لـ $days يوم';
  }

  @override
  String ads_count(String ads) {
    return '$ads إعلانات';
  }

  @override
  String get choose_plan => 'مختارة';

  @override
  String get rate_now => 'قيم الآن';

  @override
  String get rate_ad => 'تقييم الإعلان';

  @override
  String get update => 'تحديث';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get start_message => 'بدء محادثة جديدة';

  @override
  String get loading_old_messages => 'جار تحميل سجل المحادثات القديمة...';

  @override
  String get write_message => 'اكتب رسالة...';

  @override
  String get delete_ad => 'حذف الإعلان';

  @override
  String get delete_ad_description => 'هل أنت متأكد أنك تريد حذف هذا الإعلان؟';

  @override
  String get msg_ad_deleted => 'تم حذف الإعلان بنجاح!';

  @override
  String get sort_by => 'ترتيب حسب';

  @override
  String get newset => 'الأحدث أولاً';

  @override
  String get oldest => 'الأقدم أولاً';

  @override
  String get search_results => 'نتائج البحث';

  @override
  String get account_transfer_msg =>
      'فقط حسابات الشركات من يمكنها رفع الإعلانات، لذلك إذا أردت تحويل الحساب إلى حساب شركة يرجى الضغط على الزر أدناه.';

  @override
  String get account_transfer => 'تحويل الحساب';

  @override
  String get onboarding_1 =>
      'نرحب بك في تطبيق لبينا، يمكنك التسجيل أو الدخول كضيف.';

  @override
  String get onboarding_1_text1 => 'نرحب بك في تطبيق لبينا';

  @override
  String get onboarding_1_text2 => 'يمكنك التسجيل في التطبيق';

  @override
  String get onboarding_1_text3 => 'في التطبيق أو الدخول ضيف.';

  @override
  String get onboarding_2 =>
      'تستطيع أن تضيف أو تطلب اضافة إعلان في التطبيق بعد تسجيلك كشركة.';

  @override
  String get onboarding_2_text1 => 'تستطيع أن تضيف أو تطلب';

  @override
  String get onboarding_2_text2 => 'اضافة إعلان في التطبيق بعد';

  @override
  String get onboarding_2_text3 => 'تسجيلك كشركة.';

  @override
  String get onboarding_3_text1 => 'تصفح الاعلانات و تواصل مع';

  @override
  String get onboarding_3_text2 => 'المعلنين بسهولة،';

  @override
  String get onboarding_3_text3 => 'نتمنى لك تجربة مميزة..';

  @override
  String get onboarding_3 => 'تصفح الاعلانات و تواصل مع المعلنين بسهولة،...';

  @override
  String get select_language => 'اختر اللغة';

  @override
  String get add_feedback => 'أضف تعليق';

  @override
  String get feedback_here => 'اكتب رسالتك هنا';

  @override
  String get full_name => 'الاسم الكامل';

  @override
  String get msg_fill_details => 'يرجى ملء جميع التفاصيل!';

  @override
  String get exit_app => 'هل أنت متأكد أنك تريد الخروج؟';

  @override
  String get no_data => 'لم يتم العثور على بيانات';

  @override
  String get unlimited_ads => 'إعلانات غير محدودة';

  @override
  String get active_package => 'حزمتي النشطة';

  @override
  String get choose_package => 'شراء حزمة';

  @override
  String get msg_no_package => 'لا تملك حزمة نشطة، يرجى شراء واحدة';

  @override
  String get select_method => 'اختر طريقة الدفع';

  @override
  String boost_ad(String duration) {
    return 'تسليط الضوء على الإعلان لمدة $duration أيام';
  }

  @override
  String get ad_boost_state => 'تمييز الإعلانات:';

  @override
  String get promote_listing => 'تعزيز قائمة الإعلانات الخاصة بك';

  @override
  String get ad_is_special => 'الإعلان خاص';

  @override
  String get your_ad_end => 'ينتهي إعلانك بعد:';

  @override
  String number_days(String days) {
    return '$days أيام';
  }

  @override
  String get no_packages => 'لم يتم العثور على حزم تعزيز!';

  @override
  String get news => 'أخبار';

  @override
  String get see_all => 'عرض الكل';

  @override
  String get read_more => 'اقرأ المزيد';

  @override
  String get checkout_news => 'قسم الأخبار';

  @override
  String get breaking_news => 'قسم الأخبار';

  @override
  String get search_news_hint => 'بحث...';
}
