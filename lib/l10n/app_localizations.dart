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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcome_to_company.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lbeena'**
  String get welcome_to_company;

  /// No description provided for @login_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue'**
  String get login_to_continue;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @delete_sure_account.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the account?'**
  String get delete_sure_account;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @sure.
  ///
  /// In en, this message translates to:
  /// **'Sure'**
  String get sure;

  /// No description provided for @choose_date.
  ///
  /// In en, this message translates to:
  /// **'Choose the license expiration date'**
  String get choose_date;

  /// No description provided for @choose_date_license.
  ///
  /// In en, this message translates to:
  /// **'License expiration date'**
  String get choose_date_license;

  /// No description provided for @choose_date_license2.
  ///
  /// In en, this message translates to:
  /// **'You must select an expiration date'**
  String get choose_date_license2;

  /// No description provided for @error_data.
  ///
  /// In en, this message translates to:
  /// **'Error loading, please try again'**
  String get error_data;

  /// No description provided for @dont_have_product.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have products'**
  String get dont_have_product;

  /// No description provided for @login_in_app.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_in_app;

  /// No description provided for @offer.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offer;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get about_app;

  /// No description provided for @field_is_empty.
  ///
  /// In en, this message translates to:
  /// **'The field is empty'**
  String get field_is_empty;

  /// No description provided for @confirm_number.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the number'**
  String get confirm_number;

  /// No description provided for @send_otp_tow.
  ///
  /// In en, this message translates to:
  /// **'Send the OTP again'**
  String get send_otp_tow;

  /// No description provided for @send_otp_pas.
  ///
  /// In en, this message translates to:
  /// **'One-Time Password (OTP)'**
  String get send_otp_pas;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @login_guest.
  ///
  /// In en, this message translates to:
  /// **'Login as a guest'**
  String get login_guest;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forget_password;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @individual_account.
  ///
  /// In en, this message translates to:
  /// **'Individual account'**
  String get individual_account;

  /// No description provided for @company_account.
  ///
  /// In en, this message translates to:
  /// **'Company account'**
  String get company_account;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get user_name;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @agree_terms.
  ///
  /// In en, this message translates to:
  /// **'Agree to the terms and policy of the application'**
  String get agree_terms;

  /// No description provided for @do_you_have_account.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account?'**
  String get do_you_have_account;

  /// No description provided for @send_otp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get send_otp;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile_number;

  /// No description provided for @company_registration.
  ///
  /// In en, this message translates to:
  /// **'Complete registration'**
  String get company_registration;

  /// No description provided for @company_name.
  ///
  /// In en, this message translates to:
  /// **'Company name (as in the license)'**
  String get company_name;

  /// No description provided for @owner_name.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get owner_name;

  /// No description provided for @license_number.
  ///
  /// In en, this message translates to:
  /// **'License number'**
  String get license_number;

  /// No description provided for @emirate.
  ///
  /// In en, this message translates to:
  /// **'Emirate'**
  String get emirate;

  /// No description provided for @upload_license.
  ///
  /// In en, this message translates to:
  /// **'Upload the trade license'**
  String get upload_license;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @company_activity.
  ///
  /// In en, this message translates to:
  /// **'Company activity'**
  String get company_activity;

  /// No description provided for @license_exp_date.
  ///
  /// In en, this message translates to:
  /// **'License expiration date'**
  String get license_exp_date;

  /// No description provided for @otp_send_to.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to {mobile}'**
  String otp_send_to(String mobile);

  /// No description provided for @didnt_receive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive?'**
  String get didnt_receive;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'please wait {time}'**
  String please_wait(String time);

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @msg_valid_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid verification code'**
  String get msg_valid_code;

  /// No description provided for @msg_otp_failed.
  ///
  /// In en, this message translates to:
  /// **'OTP validation failed'**
  String get msg_otp_failed;

  /// No description provided for @msg_upload_license.
  ///
  /// In en, this message translates to:
  /// **'Please upload the trade license!'**
  String get msg_upload_license;

  /// No description provided for @msg_exp_date.
  ///
  /// In en, this message translates to:
  /// **'Please select trade license expiry date!'**
  String get msg_exp_date;

  /// No description provided for @msg_pw_six_char.
  ///
  /// In en, this message translates to:
  /// **'Password should be at-least six characters!'**
  String get msg_pw_six_char;

  /// No description provided for @msg_agree_terms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to our terms'**
  String get msg_agree_terms;

  /// No description provided for @msg_pw_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords doesn\'t match'**
  String get msg_pw_not_match;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @archived_research.
  ///
  /// In en, this message translates to:
  /// **'Archived research'**
  String get archived_research;

  /// No description provided for @customer_support.
  ///
  /// In en, this message translates to:
  /// **'Customer support'**
  String get customer_support;

  /// No description provided for @report_problem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get report_problem;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy and policy'**
  String get privacy;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get dark_mode;

  /// No description provided for @lite_mode.
  ///
  /// In en, this message translates to:
  /// **'Lite mode'**
  String get lite_mode;

  /// No description provided for @home_page.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get home_page;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure;

  /// No description provided for @are_you_sure_des.
  ///
  /// In en, this message translates to:
  /// **'Are your sure want to do this?'**
  String get are_you_sure_des;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @do_you_want_add_wahtsapp.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add your WhatsApp number??'**
  String get do_you_want_add_wahtsapp;

  /// No description provided for @do_you_want_add_coupons.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add a discount coupon??'**
  String get do_you_want_add_coupons;

  /// No description provided for @do_you_want_add_chats.
  ///
  /// In en, this message translates to:
  /// **'Do you want to activate chat??'**
  String get do_you_want_add_chats;

  /// No description provided for @error_size_photo.
  ///
  /// In en, this message translates to:
  /// **'Error: Image size is larger than 1 MB'**
  String get error_size_photo;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search_hint;

  /// No description provided for @main_categories.
  ///
  /// In en, this message translates to:
  /// **'Main sections'**
  String get main_categories;

  /// No description provided for @top_companies.
  ///
  /// In en, this message translates to:
  /// **'Featured advertisers'**
  String get top_companies;

  /// No description provided for @top_ads.
  ///
  /// In en, this message translates to:
  /// **'Featured ads'**
  String get top_ads;

  /// No description provided for @new_ads.
  ///
  /// In en, this message translates to:
  /// **'Newly added ads'**
  String get new_ads;

  /// No description provided for @add_ad.
  ///
  /// In en, this message translates to:
  /// **'Add Ad'**
  String get add_ad;

  /// No description provided for @choose_section.
  ///
  /// In en, this message translates to:
  /// **'Choose the section where you want your ad to appear:'**
  String get choose_section;

  /// No description provided for @main_category.
  ///
  /// In en, this message translates to:
  /// **'Al-Khaaldi sections'**
  String get main_category;

  /// No description provided for @normal_category.
  ///
  /// In en, this message translates to:
  /// **'Another section'**
  String get normal_category;

  /// No description provided for @choose_ad_type.
  ///
  /// In en, this message translates to:
  /// **'Choosing the type of advertising:'**
  String get choose_ad_type;

  /// No description provided for @banner_ad.
  ///
  /// In en, this message translates to:
  /// **'Banner announcement'**
  String get banner_ad;

  /// No description provided for @product_ad.
  ///
  /// In en, this message translates to:
  /// **'Product announcement'**
  String get product_ad;

  /// No description provided for @ad_name.
  ///
  /// In en, this message translates to:
  /// **'Add the name:'**
  String get ad_name;

  /// No description provided for @add_name_here.
  ///
  /// In en, this message translates to:
  /// **'Add name here..'**
  String get add_name_here;

  /// No description provided for @must_choose_photo.
  ///
  /// In en, this message translates to:
  /// **'You must choose a photo for the banner'**
  String get must_choose_photo;

  /// No description provided for @should_link_active.
  ///
  /// In en, this message translates to:
  /// **'Please enter an active link..'**
  String get should_link_active;

  /// No description provided for @choose_parts.
  ///
  /// In en, this message translates to:
  /// **'You must select one of the sections at the top'**
  String get choose_parts;

  /// No description provided for @add_price.
  ///
  /// In en, this message translates to:
  /// **'Price:'**
  String get add_price;

  /// No description provided for @chose_price_less.
  ///
  /// In en, this message translates to:
  /// **'Please choose a price less than 500 thousand AED'**
  String get chose_price_less;

  /// No description provided for @ad_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Ad name here in english'**
  String get ad_name_hint;

  /// No description provided for @ad_name_hint_ar.
  ///
  /// In en, this message translates to:
  /// **'Ad name here in arabic'**
  String get ad_name_hint_ar;

  /// No description provided for @add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add a photo:'**
  String get add_photo;

  /// No description provided for @publish_method.
  ///
  /// In en, this message translates to:
  /// **'Method of publication:'**
  String get publish_method;

  /// No description provided for @link_type.
  ///
  /// In en, this message translates to:
  /// **'External link'**
  String get link_type;

  /// No description provided for @description_method.
  ///
  /// In en, this message translates to:
  /// **'Through the application'**
  String get description_method;

  /// No description provided for @add_link.
  ///
  /// In en, this message translates to:
  /// **'Add the link:'**
  String get add_link;

  /// No description provided for @pay_now.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get pay_now;

  /// No description provided for @add_description.
  ///
  /// In en, this message translates to:
  /// **'Add description:'**
  String get add_description;

  /// No description provided for @description_hint.
  ///
  /// In en, this message translates to:
  /// **'Type description here ..'**
  String get description_hint;

  /// No description provided for @description_hint_ar.
  ///
  /// In en, this message translates to:
  /// **'Type description in arabic here'**
  String get description_hint_ar;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @must_choose_less_one.
  ///
  /// In en, this message translates to:
  /// **'At least one image must be selected'**
  String get must_choose_less_one;

  /// No description provided for @download_data.
  ///
  /// In en, this message translates to:
  /// **'Downloading..'**
  String get download_data;

  /// No description provided for @less_photo.
  ///
  /// In en, this message translates to:
  /// **'5 photos or less..'**
  String get less_photo;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @dont_have_result.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have result ..'**
  String get dont_have_result;

  /// No description provided for @link_hint.
  ///
  /// In en, this message translates to:
  /// **'Paste link here'**
  String get link_hint;

  /// No description provided for @whats_app_number.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number(Optional):'**
  String get whats_app_number;

  /// No description provided for @whats_app_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Type WhatsApp Number'**
  String get whats_app_number_hint;

  /// No description provided for @sign_in_process.
  ///
  /// In en, this message translates to:
  /// **'Signing is being processed...'**
  String get sign_in_process;

  /// No description provided for @want_to_highlight.
  ///
  /// In en, this message translates to:
  /// **'Do you want to highlight your ads?'**
  String get want_to_highlight;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price(Optional)'**
  String get price;

  /// No description provided for @price_hint.
  ///
  /// In en, this message translates to:
  /// **'Type price here'**
  String get price_hint;

  /// No description provided for @req_for_banner.
  ///
  /// In en, this message translates to:
  /// **'Request design from admin panel'**
  String get req_for_banner;

  /// No description provided for @msg_add_ad.
  ///
  /// In en, this message translates to:
  /// **'Your add has been submitted, wait for the approval'**
  String get msg_add_ad;

  /// No description provided for @msg_select_category.
  ///
  /// In en, this message translates to:
  /// **'Please select the category'**
  String get msg_select_category;

  /// No description provided for @msg_banner_img_required.
  ///
  /// In en, this message translates to:
  /// **'Banner image is required!'**
  String get msg_banner_img_required;

  /// No description provided for @msg_add_images.
  ///
  /// In en, this message translates to:
  /// **'Please add images or videos'**
  String get msg_add_images;

  /// No description provided for @msg_company_not_available.
  ///
  /// In en, this message translates to:
  /// **'Company not available!'**
  String get msg_company_not_available;

  /// No description provided for @all_ads.
  ///
  /// In en, this message translates to:
  /// **'All announcements'**
  String get all_ads;

  /// No description provided for @top_rated_ads.
  ///
  /// In en, this message translates to:
  /// **'The most rated ads'**
  String get top_rated_ads;

  /// No description provided for @book_ad_space.
  ///
  /// In en, this message translates to:
  /// **'Book an ad space here'**
  String get book_ad_space;

  /// No description provided for @selected_videos.
  ///
  /// In en, this message translates to:
  /// **'Selected videos from Al-Khaaldi channels:'**
  String get selected_videos;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @joined_on.
  ///
  /// In en, this message translates to:
  /// **'Joined on {date}'**
  String joined_on(String date);

  /// No description provided for @safety_tips.
  ///
  /// In en, this message translates to:
  /// **'Safety tips'**
  String get safety_tips;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faq;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String items(String count);

  /// No description provided for @add_coupon.
  ///
  /// In en, this message translates to:
  /// **'Add coupon'**
  String get add_coupon;

  /// No description provided for @click_here.
  ///
  /// In en, this message translates to:
  /// **'Click here'**
  String get click_here;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @distinction.
  ///
  /// In en, this message translates to:
  /// **'Distinction'**
  String get distinction;

  /// No description provided for @w_app.
  ///
  /// In en, this message translates to:
  /// **'WApp'**
  String get w_app;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @login_first.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get login_first;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @coupon_info_company.
  ///
  /// In en, this message translates to:
  /// **'Company name: {name}'**
  String coupon_info_company(String name);

  /// No description provided for @coupon_info_category.
  ///
  /// In en, this message translates to:
  /// **'Type of advertisement: {name}'**
  String coupon_info_category(String name);

  /// No description provided for @coupon_info_discount.
  ///
  /// In en, this message translates to:
  /// **'Discount percentage: {discount}'**
  String coupon_info_discount(String discount);

  /// No description provided for @coupon_info_date.
  ///
  /// In en, this message translates to:
  /// **'Coupon date: {date}'**
  String coupon_info_date(String date);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get my_profile;

  /// No description provided for @book_plan.
  ///
  /// In en, this message translates to:
  /// **'Book a new plan here'**
  String get book_plan;

  /// No description provided for @buy_package_for.
  ///
  /// In en, this message translates to:
  /// **'for {price}'**
  String buy_package_for(String price);

  /// No description provided for @valid_days.
  ///
  /// In en, this message translates to:
  /// **'Valid {days} day(s)'**
  String valid_days(String days);

  /// No description provided for @ads_count.
  ///
  /// In en, this message translates to:
  /// **'{ads} Ads'**
  String ads_count(String ads);

  /// No description provided for @choose_plan.
  ///
  /// In en, this message translates to:
  /// **'Choose Plane'**
  String get choose_plan;

  /// No description provided for @rate_now.
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get rate_now;

  /// No description provided for @rate_ad.
  ///
  /// In en, this message translates to:
  /// **'Rate Ad'**
  String get rate_ad;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading...'**
  String get loading;

  /// No description provided for @start_message.
  ///
  /// In en, this message translates to:
  /// **'start new message'**
  String get start_message;

  /// No description provided for @loading_old_messages.
  ///
  /// In en, this message translates to:
  /// **'loading older conversation history...'**
  String get loading_old_messages;

  /// No description provided for @write_message.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get write_message;

  /// No description provided for @delete_ad.
  ///
  /// In en, this message translates to:
  /// **'Delete ad'**
  String get delete_ad;

  /// No description provided for @delete_ad_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete this ad?'**
  String get delete_ad_description;

  /// No description provided for @msg_ad_deleted.
  ///
  /// In en, this message translates to:
  /// **'Ad has been deleted successfully!'**
  String get msg_ad_deleted;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sort_by;

  /// No description provided for @newset.
  ///
  /// In en, this message translates to:
  /// **'Newset First'**
  String get newset;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldest;

  /// No description provided for @search_results.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get search_results;

  /// No description provided for @account_transfer_msg.
  ///
  /// In en, this message translates to:
  /// **'Only corporate accounts can upload ads, so if you want to transfer your account to a corporate account, please click on the button below.'**
  String get account_transfer_msg;

  /// No description provided for @account_transfer.
  ///
  /// In en, this message translates to:
  /// **'Account transfer'**
  String get account_transfer;

  /// No description provided for @onboarding_1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lbeena. You can register or continue as a guest.'**
  String get onboarding_1;

  /// No description provided for @onboarding_1_text1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lbeena'**
  String get onboarding_1_text1;

  /// No description provided for @onboarding_1_text2.
  ///
  /// In en, this message translates to:
  /// **'You can register in the app'**
  String get onboarding_1_text2;

  /// No description provided for @onboarding_1_text3.
  ///
  /// In en, this message translates to:
  /// **'in the app or enter guest.'**
  String get onboarding_1_text3;

  /// No description provided for @onboarding_2.
  ///
  /// In en, this message translates to:
  /// **'You can add or request to add an ad in the application after you register as a company.'**
  String get onboarding_2;

  /// No description provided for @onboarding_2_text1.
  ///
  /// In en, this message translates to:
  /// **'You can add or request to add'**
  String get onboarding_2_text1;

  /// No description provided for @onboarding_2_text2.
  ///
  /// In en, this message translates to:
  /// **'an ad in the application after'**
  String get onboarding_2_text2;

  /// No description provided for @onboarding_2_text3.
  ///
  /// In en, this message translates to:
  /// **'you register as a company.'**
  String get onboarding_2_text3;

  /// No description provided for @onboarding_3_text1.
  ///
  /// In en, this message translates to:
  /// **'Browse ads and connect with'**
  String get onboarding_3_text1;

  /// No description provided for @onboarding_3_text2.
  ///
  /// In en, this message translates to:
  /// **'advertisers easily،'**
  String get onboarding_3_text2;

  /// No description provided for @onboarding_3_text3.
  ///
  /// In en, this message translates to:
  /// **'We wish you a special experience.'**
  String get onboarding_3_text3;

  /// No description provided for @onboarding_3.
  ///
  /// In en, this message translates to:
  /// **'Browse ads and connect with advertisers easily، We wish you a special experience.'**
  String get onboarding_3;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @add_feedback.
  ///
  /// In en, this message translates to:
  /// **'Add Feedback'**
  String get add_feedback;

  /// No description provided for @feedback_here.
  ///
  /// In en, this message translates to:
  /// **'Type your message here'**
  String get feedback_here;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @msg_fill_details.
  ///
  /// In en, this message translates to:
  /// **'Please fill the all details!'**
  String get msg_fill_details;

  /// No description provided for @exit_app.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exit_app;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get no_data;

  /// No description provided for @unlimited_ads.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Ads'**
  String get unlimited_ads;

  /// No description provided for @active_package.
  ///
  /// In en, this message translates to:
  /// **'My active package'**
  String get active_package;

  /// No description provided for @choose_package.
  ///
  /// In en, this message translates to:
  /// **'Buy a package'**
  String get choose_package;

  /// No description provided for @msg_no_package.
  ///
  /// In en, this message translates to:
  /// **'Your don\'t have active package, please purchase one'**
  String get msg_no_package;

  /// No description provided for @select_method.
  ///
  /// In en, this message translates to:
  /// **'Select a payment method'**
  String get select_method;

  /// No description provided for @boost_ad.
  ///
  /// In en, this message translates to:
  /// **'Highlight advertising for a {duration} days'**
  String boost_ad(String duration);

  /// No description provided for @ad_boost_state.
  ///
  /// In en, this message translates to:
  /// **'Advertising discrimination:'**
  String get ad_boost_state;

  /// No description provided for @promote_listing.
  ///
  /// In en, this message translates to:
  /// **'Promote your listing'**
  String get promote_listing;

  /// No description provided for @ad_is_special.
  ///
  /// In en, this message translates to:
  /// **'Advertising is special'**
  String get ad_is_special;

  /// No description provided for @your_ad_end.
  ///
  /// In en, this message translates to:
  /// **'Your ad ends after:'**
  String get your_ad_end;

  /// No description provided for @number_days.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String number_days(String days);

  /// No description provided for @no_packages.
  ///
  /// In en, this message translates to:
  /// **'No boosting packages found!'**
  String get no_packages;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get see_all;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get read_more;

  /// No description provided for @checkout_news.
  ///
  /// In en, this message translates to:
  /// **'Check out all the news and updates'**
  String get checkout_news;

  /// No description provided for @breaking_news.
  ///
  /// In en, this message translates to:
  /// **'Breaking News'**
  String get breaking_news;

  /// No description provided for @search_news_hint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search_news_hint;
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
      'that was used.');
}
