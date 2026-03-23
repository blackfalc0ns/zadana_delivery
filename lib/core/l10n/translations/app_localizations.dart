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
/// import 'translations/app_localizations.dart';
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
    Locale('en'),
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @name_is_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required!'**
  String get name_is_required;

  /// No description provided for @name_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This name is not valid'**
  String get name_is_not_valid;

  /// No description provided for @email_is_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required!'**
  String get email_is_required;

  /// No description provided for @email_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This email is not valid'**
  String get email_is_not_valid;

  /// No description provided for @password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required!'**
  String get password_is_required;

  /// No description provided for @password_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This password is not valid'**
  String get password_is_not_valid;

  /// No description provided for @password_must_be_at_least_6_characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_must_be_at_least_6_characters;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @confirm_password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required!'**
  String get confirm_password_is_required;

  /// No description provided for @confirm_password_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This confirm password is not valid'**
  String get confirm_password_is_not_valid;

  /// No description provided for @password_and_confirm_password_must_be_same.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password must be same!'**
  String get password_and_confirm_password_must_be_same;

  /// No description provided for @phone_number_is_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required!'**
  String get phone_number_is_required;

  /// No description provided for @phone_number_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This phone number is not valid'**
  String get phone_number_is_not_valid;

  /// No description provided for @this_field_is_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get this_field_is_required;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @start_button.
  ///
  /// In en, this message translates to:
  /// **'start now'**
  String get start_button;

  /// No description provided for @location_service_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location service is disabled'**
  String get location_service_disabled;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get location_permission_denied;

  /// No description provided for @location_permission_denied_forever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get location_permission_denied_forever;

  /// No description provided for @auth_title.
  ///
  /// In en, this message translates to:
  /// **'Get Started Now'**
  String get auth_title;

  /// No description provided for @auth_subtitle_login.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Log in to your account'**
  String get auth_subtitle_login;

  /// No description provided for @auth_subtitle_signup.
  ///
  /// In en, this message translates to:
  /// **'Create an account to explore our app'**
  String get auth_subtitle_signup;

  /// No description provided for @toggle_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get toggle_login;

  /// No description provided for @toggle_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get toggle_signup;

  /// No description provided for @label_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get label_full_name;

  /// No description provided for @label_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get label_email;

  /// No description provided for @label_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get label_phone;

  /// No description provided for @label_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get label_password;

  /// No description provided for @hint_full_name.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get hint_full_name;

  /// No description provided for @hint_email.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com '**
  String get hint_email;

  /// No description provided for @hint_email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'example@email.com or 5xxxxxxxx'**
  String get hint_email_or_phone;

  /// No description provided for @label_email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get label_email_or_phone;

  /// No description provided for @hint_phone.
  ///
  /// In en, this message translates to:
  /// **'(+966) 726-0592'**
  String get hint_phone;

  /// No description provided for @hint_password.
  ///
  /// In en, this message translates to:
  /// **'P@ssw0rd123'**
  String get hint_password;

  /// No description provided for @btn_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get btn_login;

  /// No description provided for @btn_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get btn_signup;

  /// No description provided for @btn_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get btn_forgot_password;

  /// No description provided for @forget_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forget_password_title;

  /// No description provided for @forget_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number or email to receive a verification code'**
  String get forget_password_description;

  /// No description provided for @btn_send_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get btn_send_verification_code;

  /// No description provided for @msg_verification_code_sent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get msg_verification_code_sent;

  /// No description provided for @reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_title;

  /// No description provided for @reset_password_description_prefix.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to'**
  String get reset_password_description_prefix;

  /// No description provided for @label_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get label_verification_code;

  /// No description provided for @hint_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get hint_verification_code;

  /// No description provided for @label_new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get label_new_password;

  /// No description provided for @hint_new_password.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get hint_new_password;

  /// No description provided for @btn_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get btn_confirm;

  /// No description provided for @msg_password_reset_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get msg_password_reset_success;

  /// No description provided for @verification_code_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get verification_code_required;

  /// No description provided for @verification_code_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get verification_code_invalid;

  /// No description provided for @otp_description.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to you'**
  String get otp_description;

  /// No description provided for @otp_code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Code sent to'**
  String get otp_code_sent_to;

  /// No description provided for @otp_verify_button.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otp_verify_button;

  /// No description provided for @otp_complete_code_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete verification code'**
  String get otp_complete_code_required;

  /// No description provided for @otp_success_message.
  ///
  /// In en, this message translates to:
  /// **'Account verified successfully'**
  String get otp_success_message;

  /// No description provided for @otp_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get otp_screen_title;

  /// No description provided for @otp_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to you to confirm your account'**
  String get otp_screen_subtitle;

  /// No description provided for @social_divider.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get social_divider;

  /// No description provided for @btn_login_google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get btn_login_google;

  /// No description provided for @btn_login_apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get btn_login_apple;

  /// No description provided for @footer_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get footer_have_account;

  /// No description provided for @footer_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get footer_no_account;

  /// No description provided for @footer_action_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get footer_action_login;

  /// No description provided for @footer_action_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get footer_action_signup;

  /// No description provided for @deliver_to.
  ///
  /// In en, this message translates to:
  /// **'DELIVER TO'**
  String get deliver_to;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Downtown, New York'**
  String get location;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for products, stores...'**
  String get search_hint;

  /// No description provided for @banner_tag.
  ///
  /// In en, this message translates to:
  /// **'LIMITED OFFER'**
  String get banner_tag;

  /// No description provided for @banner_title.
  ///
  /// In en, this message translates to:
  /// **'Fresh Organic\nVegetables Up to 40% Off'**
  String get banner_title;

  /// No description provided for @banner_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Shop fresh, eat healthy every day'**
  String get banner_subtitle;

  /// No description provided for @banner_action.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get banner_action;

  /// No description provided for @section_special_offers.
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get section_special_offers;

  /// No description provided for @section_best_selling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get section_best_selling;

  /// No description provided for @section_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get section_featured;

  /// No description provided for @section_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get section_recommended;

  /// No description provided for @section_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get section_explore;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_all;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get nav_categories;

  /// No description provided for @nav_cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get nav_cart;

  /// No description provided for @nav_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get nav_orders;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @start_page_title.
  ///
  /// In en, this message translates to:
  /// **'Order Everything You Need Easily'**
  String get start_page_title;

  /// No description provided for @start_page_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast delivery for all your daily needs'**
  String get start_page_subtitle;

  /// No description provided for @start_page_button.
  ///
  /// In en, this message translates to:
  /// **'Get Started Now'**
  String get start_page_button;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @edit_avatar.
  ///
  /// In en, this message translates to:
  /// **'Edit Avatar'**
  String get edit_avatar;

  /// No description provided for @personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_info;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @add_address.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get add_address;

  /// No description provided for @change_address.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change_address;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @help_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_support;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @about_app_title.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app_title;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Zadana Smart Shopping App'**
  String get app_name;

  /// No description provided for @version_label.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version_label;

  /// No description provided for @release_date.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get release_date;

  /// No description provided for @app_description.
  ///
  /// In en, this message translates to:
  /// **'A comprehensive e-commerce app that provides a distinctive and easy shopping experience.'**
  String get app_description;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get login_success;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully, please verify your email'**
  String get register_success;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_conditions;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirm;

  /// No description provided for @cart_title.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cart_title;

  /// No description provided for @cart_items_count.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String cart_items_count(Object count);

  /// No description provided for @current_vendor.
  ///
  /// In en, this message translates to:
  /// **'Current Vendor'**
  String get current_vendor;

  /// No description provided for @change_vendor.
  ///
  /// In en, this message translates to:
  /// **'Change Vendor'**
  String get change_vendor;

  /// No description provided for @vendor_change_warning.
  ///
  /// In en, this message translates to:
  /// **'Changing the vendor will affect all products in your cart. Do you want to continue?'**
  String get vendor_change_warning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @promo_code.
  ///
  /// In en, this message translates to:
  /// **'Promo Code'**
  String get promo_code;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @cart_empty.
  ///
  /// In en, this message translates to:
  /// **'Cart is Empty!'**
  String get cart_empty;

  /// No description provided for @cart_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Start shopping and add products to your cart'**
  String get cart_empty_message;

  /// No description provided for @shop_now.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shop_now;

  /// No description provided for @delete_item.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get delete_item;

  /// No description provided for @delete_item_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this item from your cart?'**
  String get delete_item_confirm;

  /// No description provided for @available_vendors.
  ///
  /// In en, this message translates to:
  /// **'Available Vendors'**
  String get available_vendors;

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout with server'**
  String get error_connection_timeout;

  /// No description provided for @error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout with server'**
  String get error_send_timeout;

  /// No description provided for @error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout with server'**
  String get error_receive_timeout;

  /// No description provided for @error_bad_certificate.
  ///
  /// In en, this message translates to:
  /// **'Invalid security certificate'**
  String get error_bad_certificate;

  /// No description provided for @error_request_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled'**
  String get error_request_cancelled;

  /// No description provided for @error_no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get error_unknown;

  /// No description provided for @error_no_response.
  ///
  /// In en, this message translates to:
  /// **'No response received from server'**
  String get error_no_response;

  /// No description provided for @error_bad_request.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get error_bad_request;

  /// No description provided for @error_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized, please sign in again'**
  String get error_unauthorized;

  /// No description provided for @error_forbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission'**
  String get error_forbidden;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get error_not_found;

  /// No description provided for @error_conflict.
  ///
  /// In en, this message translates to:
  /// **'Data conflict occurred'**
  String get error_conflict;

  /// No description provided for @error_validation.
  ///
  /// In en, this message translates to:
  /// **'Invalid input data'**
  String get error_validation;

  /// No description provided for @error_server.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again later'**
  String get error_server;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get locationPermissionDeniedForever;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get unknownError;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @product_description.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get product_description;

  /// No description provided for @product_description_text.
  ///
  /// In en, this message translates to:
  /// **'This is a high-quality product with excellent features suitable for all uses.'**
  String get product_description_text;

  /// No description provided for @quantity_label.
  ///
  /// In en, this message translates to:
  /// **'Quantity:'**
  String get quantity_label;

  /// No description provided for @add_to_cart_button.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart_button;

  /// No description provided for @added_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Product added to favorites'**
  String get added_to_favorites;

  /// No description provided for @removed_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Product removed from favorites'**
  String get removed_from_favorites;

  /// No description provided for @product_added_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Added {quantity} of {name} to cart'**
  String product_added_to_cart(Object quantity, Object name);

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @buy_now.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// No description provided for @store_price_comparison.
  ///
  /// In en, this message translates to:
  /// **'Store Price Comparison'**
  String get store_price_comparison;

  /// No description provided for @fresh_products.
  ///
  /// In en, this message translates to:
  /// **'Fresh Products'**
  String get fresh_products;

  /// No description provided for @nutrition_info.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Info'**
  String get nutrition_info;

  /// No description provided for @high_fiber.
  ///
  /// In en, this message translates to:
  /// **'High Fiber'**
  String get high_fiber;

  /// No description provided for @high_protein.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get high_protein;

  /// No description provided for @natural_100.
  ///
  /// In en, this message translates to:
  /// **'100% Natural'**
  String get natural_100;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get not_available;

  /// No description provided for @redirecting_to_checkout.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to checkout...'**
  String get redirecting_to_checkout;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cart;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get product;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clear_all;

  /// No description provided for @delete_item_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_item_confirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @clear_cart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clear_cart;

  /// No description provided for @clear_cart_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all items from cart?'**
  String get clear_cart_confirmation;

  /// No description provided for @start_shopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get start_shopping;

  /// No description provided for @start_shopping_message.
  ///
  /// In en, this message translates to:
  /// **'Start shopping and add products to cart'**
  String get start_shopping_message;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @complete_from.
  ///
  /// In en, this message translates to:
  /// **'Complete from'**
  String get complete_from;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @select_vendor_to_show_price.
  ///
  /// In en, this message translates to:
  /// **'Select vendor to show price'**
  String get select_vendor_to_show_price;

  /// No description provided for @comparison_results.
  ///
  /// In en, this message translates to:
  /// **'Comparison Results'**
  String get comparison_results;

  /// No description provided for @save_amount.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_amount;

  /// No description provided for @if_buy_from.
  ///
  /// In en, this message translates to:
  /// **'if you buy from'**
  String get if_buy_from;

  /// No description provided for @cheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get cheapest;

  /// No description provided for @more_expensive_by.
  ///
  /// In en, this message translates to:
  /// **'More expensive by'**
  String get more_expensive_by;

  /// No description provided for @currently_selected.
  ///
  /// In en, this message translates to:
  /// **'Currently Selected'**
  String get currently_selected;

  /// No description provided for @select_one_more_vendor.
  ///
  /// In en, this message translates to:
  /// **'Select at least one more vendor'**
  String get select_one_more_vendor;

  /// No description provided for @compare_prices.
  ///
  /// In en, this message translates to:
  /// **'Compare Prices'**
  String get compare_prices;

  /// No description provided for @select_cheapest.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select_cheapest;

  /// No description provided for @select_vendors_to_compare.
  ///
  /// In en, this message translates to:
  /// **'Select Vendors to Compare'**
  String get select_vendors_to_compare;

  /// No description provided for @select_2_to_3_vendors.
  ///
  /// In en, this message translates to:
  /// **'Select 2 to 3 vendors to compare prices'**
  String get select_2_to_3_vendors;

  /// No description provided for @category_vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get category_vegetables;

  /// No description provided for @category_fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get category_fruits;

  /// No description provided for @category_meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get category_meat;

  /// No description provided for @category_poultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get category_poultry;

  /// No description provided for @category_dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get category_dairy;

  /// No description provided for @category_bakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get category_bakery;

  /// No description provided for @category_beverages.
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get category_beverages;

  /// No description provided for @category_household.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get category_household;

  /// No description provided for @category_personal_care.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get category_personal_care;

  /// No description provided for @category_snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get category_snacks;

  /// No description provided for @sort_newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sort_newest;

  /// No description provided for @sort_newest_desc.
  ///
  /// In en, this message translates to:
  /// **'Recently added products'**
  String get sort_newest_desc;

  /// No description provided for @sort_price_low.
  ///
  /// In en, this message translates to:
  /// **'Price Low to High'**
  String get sort_price_low;

  /// No description provided for @sort_price_low_desc.
  ///
  /// In en, this message translates to:
  /// **'From cheapest to most expensive'**
  String get sort_price_low_desc;

  /// No description provided for @sort_price_high.
  ///
  /// In en, this message translates to:
  /// **'Price High to Low'**
  String get sort_price_high;

  /// No description provided for @sort_price_high_desc.
  ///
  /// In en, this message translates to:
  /// **'From most expensive to cheapest'**
  String get sort_price_high_desc;

  /// No description provided for @sort_best_selling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get sort_best_selling;

  /// No description provided for @sort_best_selling_desc.
  ///
  /// In en, this message translates to:
  /// **'Most purchased products'**
  String get sort_best_selling_desc;

  /// No description provided for @sort_highest_rated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get sort_highest_rated;

  /// No description provided for @sort_highest_rated_desc.
  ///
  /// In en, this message translates to:
  /// **'Based on customer ratings'**
  String get sort_highest_rated_desc;

  /// No description provided for @sort_alphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sort_alphabetical;

  /// No description provided for @sort_alphabetical_desc.
  ///
  /// In en, this message translates to:
  /// **'From A to Z'**
  String get sort_alphabetical_desc;

  /// No description provided for @filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filter Products'**
  String get filter_title;

  /// No description provided for @sort_title.
  ///
  /// In en, this message translates to:
  /// **'Sort Products'**
  String get sort_title;

  /// No description provided for @search_hint_category.
  ///
  /// In en, this message translates to:
  /// **'Search for vegetables, fruits, meat...'**
  String get search_hint_category;

  /// No description provided for @filter_button.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter_button;

  /// No description provided for @sort_button.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort_button;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all_categories;

  /// No description provided for @select_product_type.
  ///
  /// In en, this message translates to:
  /// **'Select Product Type'**
  String get select_product_type;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @price_range.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get price_range;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currency;

  /// No description provided for @filter_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get filter_type;

  /// No description provided for @filter_part.
  ///
  /// In en, this message translates to:
  /// **'Part'**
  String get filter_part;

  /// No description provided for @filter_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get filter_brand;

  /// No description provided for @filter_category_title.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filter_category_title;

  /// No description provided for @filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get filter_apply;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get show_more;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get show_less;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @favorites_empty.
  ///
  /// In en, this message translates to:
  /// **'No favorite products'**
  String get favorites_empty;

  /// No description provided for @favorites_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Start adding your favorite products for easy access'**
  String get favorites_empty_message;

  /// No description provided for @clear_favorites.
  ///
  /// In en, this message translates to:
  /// **'Clear All Favorites'**
  String get clear_favorites;

  /// No description provided for @clear_favorites_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all products from favorites?'**
  String get clear_favorites_confirmation;

  /// No description provided for @invoice_details.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoice_details;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @order_success.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully! '**
  String get order_success;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get order_number;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful! '**
  String get payment_successful;

  /// No description provided for @payment_success_message.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your order has been received and will be delivered soon'**
  String get payment_success_message;

  /// No description provided for @estimated_delivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery Time'**
  String get estimated_delivery;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @track_order.
  ///
  /// In en, this message translates to:
  /// **'Track Order ðŸ“'**
  String get track_order;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;

  /// No description provided for @my_orders_title.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get my_orders_title;

  /// No description provided for @my_orders_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your current and previous orders easily'**
  String get my_orders_subtitle;

  /// No description provided for @active_orders_tab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active_orders_tab;

  /// No description provided for @completed_orders_tab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed_orders_tab;

  /// No description provided for @no_active_orders.
  ///
  /// In en, this message translates to:
  /// **'No active orders'**
  String get no_active_orders;

  /// No description provided for @no_previous_orders.
  ///
  /// In en, this message translates to:
  /// **'No previous orders'**
  String get no_previous_orders;

  /// No description provided for @my_orders_order_date.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get my_orders_order_date;

  /// No description provided for @my_orders_items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get my_orders_items;

  /// No description provided for @my_orders_view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get my_orders_view_details;

  /// No description provided for @my_orders_cancel_order.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get my_orders_cancel_order;

  /// No description provided for @my_orders_reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get my_orders_reorder;

  /// No description provided for @my_orders_rate_order.
  ///
  /// In en, this message translates to:
  /// **'Rate Order'**
  String get my_orders_rate_order;

  /// No description provided for @order_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get order_pending;

  /// No description provided for @order_shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get order_shipped;

  /// No description provided for @order_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get order_delivered;

  /// No description provided for @order_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get order_cancelled;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @credit_debit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get credit_debit_card;

  /// No description provided for @credit_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard, Mada'**
  String get credit_card_subtitle;

  /// No description provided for @apple_pay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get apple_pay;

  /// No description provided for @apple_pay_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast and secure payment'**
  String get apple_pay_subtitle;

  /// No description provided for @cash_on_delivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cash_on_delivery;

  /// No description provided for @cash_on_delivery_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay cash when order arrives'**
  String get cash_on_delivery_subtitle;

  /// No description provided for @bank_transfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bank_transfer;

  /// No description provided for @bank_transfer_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Direct transfer from bank'**
  String get bank_transfer_subtitle;
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
