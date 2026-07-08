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

  /// No description provided for @password_requirements_prefix.
  ///
  /// In en, this message translates to:
  /// **'Password still needs'**
  String get password_requirements_prefix;

  /// No description provided for @password_requirements_separator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get password_requirements_separator;

  /// No description provided for @password_requirement_min_length.
  ///
  /// In en, this message translates to:
  /// **'at least 8 characters'**
  String get password_requirement_min_length;

  /// No description provided for @password_requirement_uppercase.
  ///
  /// In en, this message translates to:
  /// **'an uppercase letter'**
  String get password_requirement_uppercase;

  /// No description provided for @password_requirement_lowercase.
  ///
  /// In en, this message translates to:
  /// **'a lowercase letter'**
  String get password_requirement_lowercase;

  /// No description provided for @password_requirement_number.
  ///
  /// In en, this message translates to:
  /// **'a number'**
  String get password_requirement_number;

  /// No description provided for @password_requirement_special_character.
  ///
  /// In en, this message translates to:
  /// **'a special character like !'**
  String get password_requirement_special_character;

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

  /// No description provided for @location_service_disabled_message.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services and try again.'**
  String get location_service_disabled_message;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get location_permission_denied;

  /// No description provided for @location_permission_denied_message.
  ///
  /// In en, this message translates to:
  /// **'Please allow location access to continue.'**
  String get location_permission_denied_message;

  /// No description provided for @location_permission_denied_forever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get location_permission_denied_forever;

  /// No description provided for @location_permission_denied_forever_message.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it from your device settings.'**
  String get location_permission_denied_forever_message;

  /// No description provided for @error_no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet_connection;

  /// No description provided for @error_no_internet_connection_desc.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get error_no_internet_connection_desc;

  /// No description provided for @error_connection_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The connection took too long. Please try again.'**
  String get error_connection_timeout_desc;

  /// No description provided for @error_receive_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again.'**
  String get error_receive_timeout_desc;

  /// No description provided for @error_send_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data to the server. Please try again.'**
  String get error_send_timeout_desc;

  /// No description provided for @error_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get error_server_error;

  /// No description provided for @error_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again later.'**
  String get error_server_error_desc;

  /// No description provided for @error_internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get error_internal_server_error;

  /// No description provided for @error_internal_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'The server encountered an internal error. Please try again later.'**
  String get error_internal_server_error_desc;

  /// No description provided for @error_bad_gateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway'**
  String get error_bad_gateway;

  /// No description provided for @error_bad_gateway_desc.
  ///
  /// In en, this message translates to:
  /// **'The server received an invalid response. Please try again later.'**
  String get error_bad_gateway_desc;

  /// No description provided for @error_service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get error_service_unavailable;

  /// No description provided for @error_service_unavailable_desc.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again later.'**
  String get error_service_unavailable_desc;

  /// No description provided for @error_gateway_timeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout'**
  String get error_gateway_timeout;

  /// No description provided for @error_gateway_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The gateway timed out. Please try again later.'**
  String get error_gateway_timeout_desc;

  /// No description provided for @reviewsFor.
  ///
  /// In en, this message translates to:
  /// **'Reviews for'**
  String get reviewsFor;

  /// No description provided for @error_bad_request_desc.
  ///
  /// In en, this message translates to:
  /// **'The request contains invalid data. Please check your input.'**
  String get error_bad_request_desc;

  /// No description provided for @error_unauthorized_desc.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this resource. Please sign in again.'**
  String get error_unauthorized_desc;

  /// No description provided for @error_forbidden_desc.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this resource.'**
  String get error_forbidden_desc;

  /// No description provided for @error_not_found_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource could not be found.'**
  String get error_not_found_desc;

  /// No description provided for @error_method_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Method not allowed'**
  String get error_method_not_allowed;

  /// No description provided for @error_method_not_allowed_desc.
  ///
  /// In en, this message translates to:
  /// **'This method is not allowed for this resource.'**
  String get error_method_not_allowed_desc;

  /// No description provided for @error_not_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Not acceptable'**
  String get error_not_acceptable;

  /// No description provided for @error_not_acceptable_desc.
  ///
  /// In en, this message translates to:
  /// **'The request is not acceptable.'**
  String get error_not_acceptable_desc;

  /// No description provided for @error_request_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get error_request_timeout;

  /// No description provided for @error_request_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again.'**
  String get error_request_timeout_desc;

  /// No description provided for @error_conflict_desc.
  ///
  /// In en, this message translates to:
  /// **'There is a conflict with the current state of the resource.'**
  String get error_conflict_desc;

  /// No description provided for @error_gone.
  ///
  /// In en, this message translates to:
  /// **'Resource unavailable'**
  String get error_gone;

  /// No description provided for @error_gone_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource is no longer available.'**
  String get error_gone_desc;

  /// No description provided for @error_length_required.
  ///
  /// In en, this message translates to:
  /// **'Length required'**
  String get error_length_required;

  /// No description provided for @error_length_required_desc.
  ///
  /// In en, this message translates to:
  /// **'The request must specify a content length.'**
  String get error_length_required_desc;

  /// No description provided for @error_precondition_failed.
  ///
  /// In en, this message translates to:
  /// **'Precondition failed'**
  String get error_precondition_failed;

  /// No description provided for @error_precondition_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'One or more preconditions failed.'**
  String get error_precondition_failed_desc;

  /// No description provided for @error_payload_too_large.
  ///
  /// In en, this message translates to:
  /// **'Payload too large'**
  String get error_payload_too_large;

  /// No description provided for @error_payload_too_large_desc.
  ///
  /// In en, this message translates to:
  /// **'The request payload is too large.'**
  String get error_payload_too_large_desc;

  /// No description provided for @error_uri_too_long.
  ///
  /// In en, this message translates to:
  /// **'URI too long'**
  String get error_uri_too_long;

  /// No description provided for @error_uri_too_long_desc.
  ///
  /// In en, this message translates to:
  /// **'The request URI is too long.'**
  String get error_uri_too_long_desc;

  /// No description provided for @lead_send_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending the contact request'**
  String get lead_send_error;

  /// No description provided for @lead_info_collected.
  ///
  /// In en, this message translates to:
  /// **'Lead information collected successfully'**
  String get lead_info_collected;

  /// No description provided for @lead_offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Contact information has been saved locally'**
  String get lead_offline_mode;

  /// No description provided for @error_unsupported_media_type.
  ///
  /// In en, this message translates to:
  /// **'Unsupported media type'**
  String get error_unsupported_media_type;

  /// No description provided for @error_unsupported_media_type_desc.
  ///
  /// In en, this message translates to:
  /// **'This media type is not supported.'**
  String get error_unsupported_media_type_desc;

  /// No description provided for @error_range_not_satisfiable.
  ///
  /// In en, this message translates to:
  /// **'Range not satisfiable'**
  String get error_range_not_satisfiable;

  /// No description provided for @error_range_not_satisfiable_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested range cannot be satisfied.'**
  String get error_range_not_satisfiable_desc;

  /// No description provided for @error_expectation_failed.
  ///
  /// In en, this message translates to:
  /// **'Expectation failed'**
  String get error_expectation_failed;

  /// No description provided for @error_expectation_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'The expectation in the request headers could not be met.'**
  String get error_expectation_failed_desc;

  /// No description provided for @error_too_many_requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests'**
  String get error_too_many_requests;

  /// No description provided for @error_too_many_requests_desc.
  ///
  /// In en, this message translates to:
  /// **'You have sent too many requests. Please try again later.'**
  String get error_too_many_requests_desc;

  /// No description provided for @error_unknown_desc.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again.'**
  String get error_unknown_desc;

  /// No description provided for @error_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get error_cancelled;

  /// No description provided for @error_cancelled_desc.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get error_cancelled_desc;

  /// No description provided for @error_other.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error_other;

  /// No description provided for @error_other_desc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_other_desc;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get go_back;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contact_support;

  /// No description provided for @check_connection.
  ///
  /// In en, this message translates to:
  /// **'Check connection'**
  String get check_connection;

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

  /// No description provided for @notifications_mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get notifications_mark_all_read;

  /// No description provided for @notifications_mark_as_read.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get notifications_mark_as_read;

  /// No description provided for @notifications_unread_badge.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notifications_unread_badge;

  /// No description provided for @notifications_all_caught_up.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get notifications_all_caught_up;

  /// No description provided for @notifications_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifications_empty_title;

  /// No description provided for @notifications_empty_description.
  ///
  /// In en, this message translates to:
  /// **'New alerts and delivery offers will appear here as soon as they arrive.'**
  String get notifications_empty_description;

  /// No description provided for @notifications_unread_summary.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notifications'**
  String notifications_unread_summary(int count);

  /// No description provided for @notifications_total_summary.
  ///
  /// In en, this message translates to:
  /// **'{count} total notifications'**
  String notifications_total_summary(int count);

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
  /// **'Arabic'**
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

  /// No description provided for @auth_driver_account_caption.
  ///
  /// In en, this message translates to:
  /// **'Driver account'**
  String get auth_driver_account_caption;

  /// No description provided for @auth_login_description.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your trips and deliveries.'**
  String get auth_login_description;

  /// No description provided for @auth_login_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in. Check your credentials and try again.'**
  String get auth_login_error;

  /// No description provided for @auth_forgot_password_pending.
  ///
  /// In en, this message translates to:
  /// **'Forgot password will be connected in the next step.'**
  String get auth_forgot_password_pending;

  /// No description provided for @auth_signup_caption.
  ///
  /// In en, this message translates to:
  /// **'Create driver account'**
  String get auth_signup_caption;

  /// No description provided for @auth_signup_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your basic details to get started.'**
  String get auth_signup_description;

  /// No description provided for @auth_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get auth_continue;

  /// No description provided for @driver_profile_caption.
  ///
  /// In en, this message translates to:
  /// **'Complete profile'**
  String get driver_profile_caption;

  /// No description provided for @driver_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Driver and vehicle details'**
  String get driver_profile_title;

  /// No description provided for @driver_profile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add document photos and vehicle details to activate your account.'**
  String get driver_profile_subtitle;

  /// No description provided for @driver_profile_description.
  ///
  /// In en, this message translates to:
  /// **'Upload the required images and fill in the basic information.'**
  String get driver_profile_description;

  /// No description provided for @driver_profile_save.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get driver_profile_save;

  /// No description provided for @driver_profile_save_success.
  ///
  /// In en, this message translates to:
  /// **'Initial profile data was saved successfully.'**
  String get driver_profile_save_success;

  /// No description provided for @driver_profile_picker_restart_required.
  ///
  /// In en, this message translates to:
  /// **'Image picking needs a full app restart after adding the plugin.'**
  String get driver_profile_picker_restart_required;

  /// No description provided for @driver_profile_picker_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the image picker. Please try again.'**
  String get driver_profile_picker_error;

  /// No description provided for @driver_profile_image_changed_success.
  ///
  /// In en, this message translates to:
  /// **'{documentName} has been changed successfully.'**
  String driver_profile_image_changed_success(String documentName);

  /// No description provided for @driver_profile_identity_section.
  ///
  /// In en, this message translates to:
  /// **'Identity images'**
  String get driver_profile_identity_section;

  /// No description provided for @driver_profile_vehicle_section.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details'**
  String get driver_profile_vehicle_section;

  /// No description provided for @driver_profile_vehicle_images_section.
  ///
  /// In en, this message translates to:
  /// **'Vehicle images'**
  String get driver_profile_vehicle_images_section;

  /// No description provided for @driver_profile_vehicle_type.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get driver_profile_vehicle_type;

  /// No description provided for @driver_profile_vehicle_type_car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get driver_profile_vehicle_type_car;

  /// No description provided for @driver_profile_vehicle_type_bike.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get driver_profile_vehicle_type_bike;

  /// No description provided for @driver_profile_vehicle_type_scooter.
  ///
  /// In en, this message translates to:
  /// **'Scooter'**
  String get driver_profile_vehicle_type_scooter;

  /// No description provided for @driver_profile_vehicle_type_van.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get driver_profile_vehicle_type_van;

  /// No description provided for @driver_profile_vehicle_type_bicycle.
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get driver_profile_vehicle_type_bicycle;

  /// No description provided for @driver_profile_vehicle_type_truck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get driver_profile_vehicle_type_truck;

  /// No description provided for @driver_profile_portrait_title.
  ///
  /// In en, this message translates to:
  /// **'Driver portrait'**
  String get driver_profile_portrait_title;

  /// No description provided for @driver_profile_portrait_subtitle.
  ///
  /// In en, this message translates to:
  /// **'A clear personal photo of the driver.'**
  String get driver_profile_portrait_subtitle;

  /// No description provided for @driver_profile_id_front_title.
  ///
  /// In en, this message translates to:
  /// **'ID front side'**
  String get driver_profile_id_front_title;

  /// No description provided for @driver_profile_id_front_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload the front side of the ID.'**
  String get driver_profile_id_front_subtitle;

  /// No description provided for @driver_profile_id_back_title.
  ///
  /// In en, this message translates to:
  /// **'ID back side'**
  String get driver_profile_id_back_title;

  /// No description provided for @driver_profile_id_back_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload the back side of the ID.'**
  String get driver_profile_id_back_subtitle;

  /// No description provided for @driver_profile_license_title.
  ///
  /// In en, this message translates to:
  /// **'Driver license'**
  String get driver_profile_license_title;

  /// No description provided for @driver_profile_license_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear image of the license.'**
  String get driver_profile_license_subtitle;

  /// No description provided for @driver_profile_vehicle_photo_title.
  ///
  /// In en, this message translates to:
  /// **'Vehicle photo'**
  String get driver_profile_vehicle_photo_title;

  /// No description provided for @driver_profile_vehicle_photo_subtitle.
  ///
  /// In en, this message translates to:
  /// **'A full image of the delivery vehicle.'**
  String get driver_profile_vehicle_photo_subtitle;

  /// No description provided for @driver_profile_plate_photo_title.
  ///
  /// In en, this message translates to:
  /// **'Plate image'**
  String get driver_profile_plate_photo_title;

  /// No description provided for @driver_profile_plate_photo_subtitle.
  ///
  /// In en, this message translates to:
  /// **'A clear image of the vehicle plate.'**
  String get driver_profile_plate_photo_subtitle;

  /// No description provided for @driver_profile_brand_label.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get driver_profile_brand_label;

  /// No description provided for @driver_profile_brand_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: Toyota or Yamaha'**
  String get driver_profile_brand_hint;

  /// No description provided for @driver_profile_model_label.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get driver_profile_model_label;

  /// No description provided for @driver_profile_model_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: 2022 or NMAX'**
  String get driver_profile_model_hint;

  /// No description provided for @driver_profile_plate_label.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get driver_profile_plate_label;

  /// No description provided for @driver_profile_plate_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter plate number'**
  String get driver_profile_plate_hint;

  /// No description provided for @auth_gate_ready_title.
  ///
  /// In en, this message translates to:
  /// **'Ready to roll'**
  String get auth_gate_ready_title;

  /// No description provided for @auth_gate_ready_description.
  ///
  /// In en, this message translates to:
  /// **'Preparing your driver session and routing you to the right next step.'**
  String get auth_gate_ready_description;

  /// No description provided for @auth_login_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Ready to deliver'**
  String get auth_login_hero_badge;

  /// No description provided for @auth_login_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Driver sign in'**
  String get auth_login_hero_title;

  /// No description provided for @auth_login_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Access deliveries and manage your activity easily.'**
  String get auth_login_hero_subtitle;

  /// No description provided for @auth_login_section_badge.
  ///
  /// In en, this message translates to:
  /// **'Driver account'**
  String get auth_login_section_badge;

  /// No description provided for @auth_verify_otp_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get auth_verify_otp_hero_badge;

  /// No description provided for @auth_verify_otp_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get auth_verify_otp_hero_title;

  /// No description provided for @auth_verify_otp_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your account will stay pending until you confirm the code sent to your email.'**
  String get auth_verify_otp_hero_subtitle;

  /// No description provided for @auth_verify_otp_section_badge.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get auth_verify_otp_section_badge;

  /// No description provided for @auth_verify_otp_section_title.
  ///
  /// In en, this message translates to:
  /// **'Verify driver account'**
  String get auth_verify_otp_section_title;

  /// No description provided for @auth_verify_otp_section_description.
  ///
  /// In en, this message translates to:
  /// **'Review your email and enter the 4-digit code to continue.'**
  String get auth_verify_otp_section_description;

  /// No description provided for @auth_verify_otp_identifier_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_verify_otp_identifier_label;

  /// No description provided for @auth_verify_otp_code_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit code'**
  String get auth_verify_otp_code_hint;

  /// No description provided for @auth_verify_otp_code_helper.
  ///
  /// In en, this message translates to:
  /// **'The code must contain 4 digits only.'**
  String get auth_verify_otp_code_helper;

  /// No description provided for @auth_verify_otp_resend_action.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get auth_verify_otp_resend_action;

  /// No description provided for @auth_verify_otp_resending.
  ///
  /// In en, this message translates to:
  /// **'Resending...'**
  String get auth_verify_otp_resending;

  /// No description provided for @auth_verify_otp_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get auth_verify_otp_back_to_login;

  /// No description provided for @auth_verify_otp_missing_tokens.
  ///
  /// In en, this message translates to:
  /// **'No login tokens were returned after verification.'**
  String get auth_verify_otp_missing_tokens;

  /// No description provided for @auth_signup_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Join the driver team'**
  String get auth_signup_hero_badge;

  /// No description provided for @auth_signup_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Create driver account'**
  String get auth_signup_hero_title;

  /// No description provided for @auth_signup_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with your basic details and join quickly.'**
  String get auth_signup_hero_subtitle;

  /// No description provided for @auth_signup_section_badge.
  ///
  /// In en, this message translates to:
  /// **'New journey'**
  String get auth_signup_section_badge;

  /// No description provided for @auth_forgot_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Quick recovery'**
  String get auth_forgot_hero_badge;

  /// No description provided for @auth_forgot_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Recover access to your account in a few steps.'**
  String get auth_forgot_hero_subtitle;

  /// No description provided for @auth_forgot_section_badge.
  ///
  /// In en, this message translates to:
  /// **'Recover access'**
  String get auth_forgot_section_badge;

  /// No description provided for @auth_reset_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Account security'**
  String get auth_reset_hero_badge;

  /// No description provided for @auth_reset_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password for your account.'**
  String get auth_reset_hero_subtitle;

  /// No description provided for @auth_reset_section_badge.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get auth_reset_section_badge;

  /// No description provided for @auth_confirm_password_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get auth_confirm_password_label;

  /// No description provided for @auth_confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get auth_confirm_password_hint;

  /// No description provided for @auth_header_platform_caption.
  ///
  /// In en, this message translates to:
  /// **'Delivery platform'**
  String get auth_header_platform_caption;

  /// No description provided for @driver_upload_status_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get driver_upload_status_done;

  /// No description provided for @driver_upload_status_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get driver_upload_status_upload;

  /// No description provided for @driver_profile_step_identity_title.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get driver_profile_step_identity_title;

  /// No description provided for @driver_profile_step_vehicle_title.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get driver_profile_step_vehicle_title;

  /// No description provided for @driver_profile_step_uploads_title.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get driver_profile_step_uploads_title;

  /// No description provided for @driver_profile_step_submit_title.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get driver_profile_step_submit_title;

  /// No description provided for @driver_profile_step_identity_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the driver official identity details.'**
  String get driver_profile_step_identity_subtitle;

  /// No description provided for @driver_profile_step_vehicle_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the vehicle and add its key details.'**
  String get driver_profile_step_vehicle_subtitle;

  /// No description provided for @driver_profile_step_uploads_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload the required visuals and documents clearly.'**
  String get driver_profile_step_uploads_subtitle;

  /// No description provided for @driver_profile_step_submit_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Review everything and submit the final information.'**
  String get driver_profile_step_submit_subtitle;

  /// No description provided for @driver_profile_page_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the driver profile step by step with a clear guided flow.'**
  String get driver_profile_page_subtitle;

  /// No description provided for @driver_profile_step_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get driver_profile_step_back;

  /// No description provided for @driver_profile_step_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get driver_profile_step_next;

  /// No description provided for @driver_profile_submit_information.
  ///
  /// In en, this message translates to:
  /// **'Submit information'**
  String get driver_profile_submit_information;

  /// No description provided for @driver_profile_images_required_error.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required images before continuing.'**
  String get driver_profile_images_required_error;

  /// No description provided for @driver_profile_submit_success.
  ///
  /// In en, this message translates to:
  /// **'Driver information submitted successfully.'**
  String get driver_profile_submit_success;

  /// No description provided for @driver_profile_identity_card_title.
  ///
  /// In en, this message translates to:
  /// **'Personal and official details'**
  String get driver_profile_identity_card_title;

  /// No description provided for @driver_profile_identity_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill these details carefully because they anchor the rest of the profile.'**
  String get driver_profile_identity_card_subtitle;

  /// No description provided for @driver_profile_address_label.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get driver_profile_address_label;

  /// No description provided for @driver_profile_address_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: Al Narjis, Riyadh'**
  String get driver_profile_address_hint;

  /// No description provided for @driver_profile_national_id_label.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get driver_profile_national_id_label;

  /// No description provided for @driver_profile_national_id_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter ID number'**
  String get driver_profile_national_id_hint;

  /// No description provided for @driver_profile_national_id_expiry_label.
  ///
  /// In en, this message translates to:
  /// **'ID expiry date'**
  String get driver_profile_national_id_expiry_label;

  /// No description provided for @driver_profile_license_number_label.
  ///
  /// In en, this message translates to:
  /// **'License number'**
  String get driver_profile_license_number_label;

  /// No description provided for @driver_profile_license_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter license number'**
  String get driver_profile_license_number_hint;

  /// No description provided for @driver_profile_driver_license_expiry_label.
  ///
  /// In en, this message translates to:
  /// **'Driver license expiry date'**
  String get driver_profile_driver_license_expiry_label;

  /// No description provided for @driver_profile_vehicle_license_number_label.
  ///
  /// In en, this message translates to:
  /// **'Vehicle license number'**
  String get driver_profile_vehicle_license_number_label;

  /// No description provided for @driver_profile_vehicle_license_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter vehicle license number'**
  String get driver_profile_vehicle_license_number_hint;

  /// No description provided for @driver_profile_vehicle_license_expiry_label.
  ///
  /// In en, this message translates to:
  /// **'Vehicle license expiry date'**
  String get driver_profile_vehicle_license_expiry_label;

  /// No description provided for @driver_profile_expiry_date_label.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get driver_profile_expiry_date_label;

  /// No description provided for @driver_profile_expiry_date_hint.
  ///
  /// In en, this message translates to:
  /// **'Select expiry date'**
  String get driver_profile_expiry_date_hint;

  /// No description provided for @driver_profile_invalid_date_error.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid date.'**
  String get driver_profile_invalid_date_error;

  /// No description provided for @driver_profile_expiry_date_past_error.
  ///
  /// In en, this message translates to:
  /// **'Expiry date cannot be in the past.'**
  String get driver_profile_expiry_date_past_error;

  /// No description provided for @driver_profile_vehicle_card_title.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details'**
  String get driver_profile_vehicle_card_title;

  /// No description provided for @driver_profile_vehicle_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the right vehicle for you, then complete its essential data.'**
  String get driver_profile_vehicle_card_subtitle;

  /// No description provided for @driver_profile_zone_label.
  ///
  /// In en, this message translates to:
  /// **'Working area'**
  String get driver_profile_zone_label;

  /// No description provided for @driver_profile_zone_region_label.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get driver_profile_zone_region_label;

  /// No description provided for @driver_profile_zone_city_label.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get driver_profile_zone_city_label;

  /// No description provided for @driver_profile_zone_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Choose region and city'**
  String get driver_profile_zone_placeholder;

  /// No description provided for @driver_profile_zone_region_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Choose region'**
  String get driver_profile_zone_region_placeholder;

  /// No description provided for @driver_profile_zone_city_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Choose city'**
  String get driver_profile_zone_city_placeholder;

  /// No description provided for @driver_profile_zone_hint.
  ///
  /// In en, this message translates to:
  /// **'Select the region and city where you want to start receiving orders.'**
  String get driver_profile_zone_hint;

  /// No description provided for @driver_profile_zone_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading regions and cities'**
  String get driver_profile_zone_loading;

  /// No description provided for @driver_profile_zone_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Choose your working area'**
  String get driver_profile_zone_sheet_title;

  /// No description provided for @driver_profile_zone_sheet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the region first, then choose the city linked to your driver account.'**
  String get driver_profile_zone_sheet_subtitle;

  /// No description provided for @driver_profile_zone_region_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Choose region'**
  String get driver_profile_zone_region_sheet_title;

  /// No description provided for @driver_profile_zone_region_sheet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your selected region controls the available cities.'**
  String get driver_profile_zone_region_sheet_subtitle;

  /// No description provided for @driver_profile_zone_city_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Choose city'**
  String get driver_profile_zone_city_sheet_title;

  /// No description provided for @driver_profile_zone_city_sheet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the city where you want to receive orders.'**
  String get driver_profile_zone_city_sheet_subtitle;

  /// No description provided for @driver_profile_zone_sheet_region_label.
  ///
  /// In en, this message translates to:
  /// **'1. Region'**
  String get driver_profile_zone_sheet_region_label;

  /// No description provided for @driver_profile_zone_sheet_city_label.
  ///
  /// In en, this message translates to:
  /// **'2. City'**
  String get driver_profile_zone_sheet_city_label;

  /// No description provided for @driver_profile_zone_empty.
  ///
  /// In en, this message translates to:
  /// **'No available regions or cities right now.'**
  String get driver_profile_zone_empty;

  /// No description provided for @driver_profile_zone_cities_count.
  ///
  /// In en, this message translates to:
  /// **'{count} cities'**
  String driver_profile_zone_cities_count(String count);

  /// No description provided for @driver_profile_zone_required_error.
  ///
  /// In en, this message translates to:
  /// **'Choose your region and city before continuing.'**
  String get driver_profile_zone_required_error;

  /// No description provided for @driver_profile_vehicle_required_error.
  ///
  /// In en, this message translates to:
  /// **'Choose a vehicle type before continuing.'**
  String get driver_profile_vehicle_required_error;

  /// No description provided for @driver_profile_zone_radius.
  ///
  /// In en, this message translates to:
  /// **'Coverage {radius} km'**
  String driver_profile_zone_radius(String radius);

  /// No description provided for @driver_profile_vehicle_selected_message.
  ///
  /// In en, this message translates to:
  /// **'{vehicleType} selected. Make sure the uploaded photo matches this vehicle type.'**
  String driver_profile_vehicle_selected_message(String vehicleType);

  /// No description provided for @driver_profile_vehicle_selected_bike_message.
  ///
  /// In en, this message translates to:
  /// **'Bike selected. This setup emphasizes agility and faster movement in traffic.'**
  String get driver_profile_vehicle_selected_bike_message;

  /// No description provided for @driver_profile_vehicle_selected_car_message.
  ///
  /// In en, this message translates to:
  /// **'Car selected. This setup is suitable for larger and more varied orders.'**
  String get driver_profile_vehicle_selected_car_message;

  /// No description provided for @driver_profile_uploads_card_title.
  ///
  /// In en, this message translates to:
  /// **'Images and attachments'**
  String get driver_profile_uploads_card_title;

  /// No description provided for @driver_profile_uploads_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Each upload here makes the driver and vehicle data clearer.'**
  String get driver_profile_uploads_card_subtitle;

  /// No description provided for @driver_profile_national_id_card_title.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get driver_profile_national_id_card_title;

  /// No description provided for @driver_profile_driver_license_card_title.
  ///
  /// In en, this message translates to:
  /// **'Driver license'**
  String get driver_profile_driver_license_card_title;

  /// No description provided for @driver_profile_vehicle_license_card_title.
  ///
  /// In en, this message translates to:
  /// **'Vehicle license'**
  String get driver_profile_vehicle_license_card_title;

  /// No description provided for @driver_profile_vehicle_license_title.
  ///
  /// In en, this message translates to:
  /// **'Vehicle license image'**
  String get driver_profile_vehicle_license_title;

  /// No description provided for @driver_profile_vehicle_license_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear image of the vehicle license.'**
  String get driver_profile_vehicle_license_subtitle;

  /// No description provided for @driver_profile_review_card_title.
  ///
  /// In en, this message translates to:
  /// **'Review and submit'**
  String get driver_profile_review_card_title;

  /// No description provided for @driver_profile_review_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Review everything you entered before the final submission.'**
  String get driver_profile_review_card_subtitle;

  /// No description provided for @driver_profile_uploaded_images_label.
  ///
  /// In en, this message translates to:
  /// **'Uploaded images'**
  String get driver_profile_uploaded_images_label;

  /// No description provided for @driver_profile_vehicle_type_label.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get driver_profile_vehicle_type_label;

  /// No description provided for @driver_profile_brand_review_label.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get driver_profile_brand_review_label;

  /// No description provided for @driver_profile_model_review_label.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get driver_profile_model_review_label;

  /// No description provided for @driver_profile_plate_review_label.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get driver_profile_plate_review_label;

  /// No description provided for @driver_profile_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get driver_profile_incomplete;

  /// No description provided for @driver_profile_steps_progress.
  ///
  /// In en, this message translates to:
  /// **'Step progress'**
  String get driver_profile_steps_progress;

  /// No description provided for @driver_vehicle_type_car_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ideal for larger and multiple orders'**
  String get driver_vehicle_type_car_subtitle;

  /// No description provided for @driver_vehicle_type_bike_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Faster in dense city routes'**
  String get driver_vehicle_type_bike_subtitle;

  /// No description provided for @driver_vehicle_type_motorcycle_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Balanced speed and carrying capacity for urban delivery'**
  String get driver_vehicle_type_motorcycle_subtitle;

  /// No description provided for @driver_vehicle_type_scooter_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Light and efficient for quick neighborhood routes'**
  String get driver_vehicle_type_scooter_subtitle;

  /// No description provided for @driver_vehicle_type_van_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Best for bulk loads and medium-sized shipments'**
  String get driver_vehicle_type_van_subtitle;

  /// No description provided for @driver_vehicle_type_bicycle_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Best for short eco-friendly trips in tight streets'**
  String get driver_vehicle_type_bicycle_subtitle;

  /// No description provided for @driver_vehicle_type_truck_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Suitable for heavy loads and large deliveries'**
  String get driver_vehicle_type_truck_subtitle;

  /// No description provided for @auth_section_badge_default.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get auth_section_badge_default;

  /// No description provided for @auth_phone_hint_compact.
  ///
  /// In en, this message translates to:
  /// **'5xxxxxxxx'**
  String get auth_phone_hint_compact;

  /// No description provided for @auth_pending_title.
  ///
  /// In en, this message translates to:
  /// **'Your account is under review'**
  String get auth_pending_title;

  /// No description provided for @auth_pending_description.
  ///
  /// In en, this message translates to:
  /// **'Your details were received successfully. Our team will review and activate the account before you start receiving orders.'**
  String get auth_pending_description;

  /// No description provided for @auth_pending_notification_hint.
  ///
  /// In en, this message translates to:
  /// **'You will receive a new notification as soon as the account is approved, and you can track all alerts from the notifications button above.'**
  String get auth_pending_notification_hint;

  /// No description provided for @auth_pending_eta_hint.
  ///
  /// In en, this message translates to:
  /// **'Account review usually happens shortly after the submitted data is confirmed as complete.'**
  String get auth_pending_eta_hint;

  /// No description provided for @auth_pending_update_required.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get auth_pending_update_required;

  /// No description provided for @auth_pending_under_review_badge.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get auth_pending_under_review_badge;

  /// No description provided for @auth_pending_update_short_description.
  ///
  /// In en, this message translates to:
  /// **'Some details or documents need updating.'**
  String get auth_pending_update_short_description;

  /// No description provided for @auth_pending_review_short_description.
  ///
  /// In en, this message translates to:
  /// **'Your details are being reviewed.'**
  String get auth_pending_review_short_description;

  /// No description provided for @auth_pending_note_title.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get auth_pending_note_title;

  /// No description provided for @auth_pending_notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get auth_pending_notifications_title;

  /// No description provided for @auth_pending_notifications_update_message.
  ///
  /// In en, this message translates to:
  /// **'Check notifications for update requests.'**
  String get auth_pending_notifications_update_message;

  /// No description provided for @auth_pending_notifications_review_message.
  ///
  /// In en, this message translates to:
  /// **'You will be notified once reviewed.'**
  String get auth_pending_notifications_review_message;

  /// No description provided for @auth_pending_support_title.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get auth_pending_support_title;

  /// No description provided for @auth_pending_support_message.
  ///
  /// In en, this message translates to:
  /// **'If you need to ask about your account status or send an appeal, you can contact support directly from here.'**
  String get auth_pending_support_message;

  /// No description provided for @driver_account_support_title.
  ///
  /// In en, this message translates to:
  /// **'Driver account support'**
  String get driver_account_support_title;

  /// No description provided for @driver_account_support_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a direct support appeal about review, suspension, bans, or any issue preventing account access.'**
  String get driver_account_support_subtitle;

  /// No description provided for @driver_account_support_identifier_label.
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get driver_account_support_identifier_label;

  /// No description provided for @driver_account_support_identifier_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter email or phone'**
  String get driver_account_support_identifier_hint;

  /// No description provided for @driver_account_support_reason_label.
  ///
  /// In en, this message translates to:
  /// **'Request reason'**
  String get driver_account_support_reason_label;

  /// No description provided for @driver_account_support_message_label.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get driver_account_support_message_label;

  /// No description provided for @driver_account_support_message_hint.
  ///
  /// In en, this message translates to:
  /// **'Explain the issue or request clearly'**
  String get driver_account_support_message_hint;

  /// No description provided for @driver_account_support_attach_files.
  ///
  /// In en, this message translates to:
  /// **'Attach files'**
  String get driver_account_support_attach_files;

  /// No description provided for @driver_account_support_attach_more_files.
  ///
  /// In en, this message translates to:
  /// **'Attach more files'**
  String get driver_account_support_attach_more_files;

  /// No description provided for @driver_account_support_submit.
  ///
  /// In en, this message translates to:
  /// **'Send support request'**
  String get driver_account_support_submit;

  /// No description provided for @driver_account_support_reason_required.
  ///
  /// In en, this message translates to:
  /// **'Choose a support request reason'**
  String get driver_account_support_reason_required;

  /// No description provided for @driver_account_support_empty_reasons.
  ///
  /// In en, this message translates to:
  /// **'No reasons are available right now. Pull to refresh and try again.'**
  String get driver_account_support_empty_reasons;

  /// No description provided for @driver_account_support_pick_files_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the image picker. Please try again.'**
  String get driver_account_support_pick_files_error;

  /// No description provided for @driver_account_support_upload_files_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to upload the attached files. Please try again.'**
  String get driver_account_support_upload_files_error;

  /// No description provided for @driver_support_case_entry_title.
  ///
  /// In en, this message translates to:
  /// **'Support case'**
  String get driver_support_case_entry_title;

  /// No description provided for @driver_support_case_entry_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry loading support case'**
  String get driver_support_case_entry_retry;

  /// No description provided for @driver_support_cases_title.
  ///
  /// In en, this message translates to:
  /// **'Cases and disputes'**
  String get driver_support_cases_title;

  /// No description provided for @driver_support_cases_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No support requests yet'**
  String get driver_support_cases_empty_title;

  /// No description provided for @driver_support_cases_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Any issue, dispute, or account support request you submit will appear here.'**
  String get driver_support_cases_empty_subtitle;

  /// No description provided for @driver_support_case_order_number.
  ///
  /// In en, this message translates to:
  /// **'Order number'**
  String get driver_support_case_order_number;

  /// No description provided for @driver_support_case_reference.
  ///
  /// In en, this message translates to:
  /// **'Case reference'**
  String get driver_support_case_reference;

  /// No description provided for @driver_support_case_type_report.
  ///
  /// In en, this message translates to:
  /// **'Operational report'**
  String get driver_support_case_type_report;

  /// No description provided for @driver_support_case_type_dispute.
  ///
  /// In en, this message translates to:
  /// **'Financial dispute'**
  String get driver_support_case_type_dispute;

  /// No description provided for @driver_support_case_type_account.
  ///
  /// In en, this message translates to:
  /// **'Account support'**
  String get driver_support_case_type_account;

  /// No description provided for @driver_support_case_status_submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get driver_support_case_status_submitted;

  /// No description provided for @driver_support_case_status_in_review.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get driver_support_case_status_in_review;

  /// No description provided for @driver_support_case_status_awaiting_evidence.
  ///
  /// In en, this message translates to:
  /// **'Awaiting evidence'**
  String get driver_support_case_status_awaiting_evidence;

  /// No description provided for @driver_support_case_status_approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get driver_support_case_status_approved;

  /// No description provided for @driver_support_case_status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get driver_support_case_status_rejected;

  /// No description provided for @driver_support_case_status_resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get driver_support_case_status_resolved;

  /// No description provided for @driver_support_case_details_title.
  ///
  /// In en, this message translates to:
  /// **'Case details'**
  String get driver_support_case_details_title;

  /// No description provided for @driver_support_case_description_title.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get driver_support_case_description_title;

  /// No description provided for @driver_support_case_admin_note_title.
  ///
  /// In en, this message translates to:
  /// **'Admin note'**
  String get driver_support_case_admin_note_title;

  /// No description provided for @driver_support_case_decision_notes_title.
  ///
  /// In en, this message translates to:
  /// **'Decision notes'**
  String get driver_support_case_decision_notes_title;

  /// No description provided for @driver_support_case_attachments_title.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get driver_support_case_attachments_title;

  /// No description provided for @driver_support_case_recent_activity_title.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get driver_support_case_recent_activity_title;

  /// No description provided for @driver_support_case_add_follow_up_title.
  ///
  /// In en, this message translates to:
  /// **'Add follow-up'**
  String get driver_support_case_add_follow_up_title;

  /// No description provided for @driver_support_follow_up_reason.
  ///
  /// In en, this message translates to:
  /// **'Follow-up reason'**
  String get driver_support_follow_up_reason;

  /// No description provided for @driver_support_follow_up_message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get driver_support_follow_up_message;

  /// No description provided for @driver_support_follow_up_message_hint.
  ///
  /// In en, this message translates to:
  /// **'Add any new details or clarification'**
  String get driver_support_follow_up_message_hint;

  /// No description provided for @driver_support_attach_files.
  ///
  /// In en, this message translates to:
  /// **'Attach files'**
  String get driver_support_attach_files;

  /// No description provided for @driver_support_attach_more_files.
  ///
  /// In en, this message translates to:
  /// **'Attach more files'**
  String get driver_support_attach_more_files;

  /// No description provided for @driver_support_send_follow_up.
  ///
  /// In en, this message translates to:
  /// **'Send follow-up'**
  String get driver_support_send_follow_up;

  /// No description provided for @driver_support_follow_up_required_error.
  ///
  /// In en, this message translates to:
  /// **'Choose a follow-up reason and enter a message'**
  String get driver_support_follow_up_required_error;

  /// No description provided for @driver_support_pick_files_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the image picker. Please try again.'**
  String get driver_support_pick_files_error;

  /// No description provided for @driver_support_attachment_file_name.
  ///
  /// In en, this message translates to:
  /// **'attachment.jpg'**
  String get driver_support_attachment_file_name;

  /// No description provided for @driver_support_upload_files_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to upload attachments. Please try again.'**
  String get driver_support_upload_files_error;

  /// No description provided for @driver_support_open_attachment_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the attachment.'**
  String get driver_support_open_attachment_error;

  /// No description provided for @driver_support_not_available.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get driver_support_not_available;

  /// No description provided for @driver_support_case_reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get driver_support_case_reason;

  /// No description provided for @driver_support_case_last_update.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get driver_support_case_last_update;

  /// No description provided for @driver_support_case_queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get driver_support_case_queue;

  /// No description provided for @driver_support_case_priority_low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get driver_support_case_priority_low;

  /// No description provided for @driver_support_case_priority_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get driver_support_case_priority_medium;

  /// No description provided for @driver_support_case_priority_high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get driver_support_case_priority_high;

  /// No description provided for @driver_support_case_priority_critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get driver_support_case_priority_critical;

  /// No description provided for @driver_support_reason_customer_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Customer unavailable'**
  String get driver_support_reason_customer_unavailable;

  /// No description provided for @driver_support_reason_wrong_address.
  ///
  /// In en, this message translates to:
  /// **'Wrong address'**
  String get driver_support_reason_wrong_address;

  /// No description provided for @driver_support_reason_payout_issue.
  ///
  /// In en, this message translates to:
  /// **'Payout issue'**
  String get driver_support_reason_payout_issue;

  /// No description provided for @driver_support_reason_damaged_package.
  ///
  /// In en, this message translates to:
  /// **'Damaged package'**
  String get driver_support_reason_damaged_package;

  /// No description provided for @driver_support_follow_up_reason_general.
  ///
  /// In en, this message translates to:
  /// **'General follow-up'**
  String get driver_support_follow_up_reason_general;

  /// No description provided for @driver_support_follow_up_reason_additional_info.
  ///
  /// In en, this message translates to:
  /// **'Additional info'**
  String get driver_support_follow_up_reason_additional_info;

  /// No description provided for @driver_support_follow_up_reason_proof_submitted.
  ///
  /// In en, this message translates to:
  /// **'Proof submitted'**
  String get driver_support_follow_up_reason_proof_submitted;

  /// No description provided for @driver_support_attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get driver_support_attachment;

  /// No description provided for @driver_support_activity_case_opened.
  ///
  /// In en, this message translates to:
  /// **'Case opened'**
  String get driver_support_activity_case_opened;

  /// No description provided for @driver_support_activity_follow_up_added.
  ///
  /// In en, this message translates to:
  /// **'Follow-up added'**
  String get driver_support_activity_follow_up_added;

  /// No description provided for @driver_support_activity_driver_replied.
  ///
  /// In en, this message translates to:
  /// **'Driver replied'**
  String get driver_support_activity_driver_replied;

  /// No description provided for @auth_pending_update_details.
  ///
  /// In en, this message translates to:
  /// **'Update details'**
  String get auth_pending_update_details;

  /// No description provided for @auth_pending_review_details.
  ///
  /// In en, this message translates to:
  /// **'Review details'**
  String get auth_pending_review_details;

  /// No description provided for @driver_account_status_title.
  ///
  /// In en, this message translates to:
  /// **'Account status'**
  String get driver_account_status_title;

  /// No description provided for @driver_account_status_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track each document review, missing requirements, and the next action needed to complete your account.'**
  String get driver_account_status_subtitle;

  /// No description provided for @profile_rejection_policy_title.
  ///
  /// In en, this message translates to:
  /// **'Offer rejection policy'**
  String get profile_rejection_policy_title;

  /// No description provided for @profile_rejection_policy_tracking_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Backend-tracked daily and weekly rejection limits'**
  String get profile_rejection_policy_tracking_subtitle;

  /// No description provided for @profile_rejection_policy_frozen_badge.
  ///
  /// In en, this message translates to:
  /// **'Offer receiving is temporarily frozen'**
  String get profile_rejection_policy_frozen_badge;

  /// No description provided for @profile_rejection_policy_status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profile_rejection_policy_status_active;

  /// No description provided for @profile_rejection_policy_status_frozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get profile_rejection_policy_status_frozen;

  /// No description provided for @profile_rejection_policy_summary_active.
  ///
  /// In en, this message translates to:
  /// **'Track daily and weekly rejection limits live'**
  String get profile_rejection_policy_summary_active;

  /// No description provided for @profile_rejection_policy_summary_frozen.
  ///
  /// In en, this message translates to:
  /// **'Offer receiving is temporarily paused by policy'**
  String get profile_rejection_policy_summary_frozen;

  /// No description provided for @profile_rejection_today_label.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get profile_rejection_today_label;

  /// No description provided for @profile_rejection_today_remaining_label.
  ///
  /// In en, this message translates to:
  /// **'Remaining today'**
  String get profile_rejection_today_remaining_label;

  /// No description provided for @profile_rejection_week_label.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get profile_rejection_week_label;

  /// No description provided for @profile_rejection_week_remaining_label.
  ///
  /// In en, this message translates to:
  /// **'Remaining this week'**
  String get profile_rejection_week_remaining_label;

  /// No description provided for @driver_account_status_completion_label.
  ///
  /// In en, this message translates to:
  /// **'Profile completion'**
  String get driver_account_status_completion_label;

  /// No description provided for @driver_account_status_account_label.
  ///
  /// In en, this message translates to:
  /// **'Account status'**
  String get driver_account_status_account_label;

  /// No description provided for @driver_account_status_portrait_ready.
  ///
  /// In en, this message translates to:
  /// **'Personal photo uploaded'**
  String get driver_account_status_portrait_ready;

  /// No description provided for @driver_account_status_portrait_missing.
  ///
  /// In en, this message translates to:
  /// **'Personal photo missing'**
  String get driver_account_status_portrait_missing;

  /// No description provided for @driver_account_status_files_label.
  ///
  /// In en, this message translates to:
  /// **'Uploaded files'**
  String get driver_account_status_files_label;

  /// No description provided for @driver_account_status_files_count.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s)'**
  String driver_account_status_files_count(int count);

  /// No description provided for @driver_account_status_edit_details.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get driver_account_status_edit_details;

  /// No description provided for @driver_account_status_update_files.
  ///
  /// In en, this message translates to:
  /// **'Update files'**
  String get driver_account_status_update_files;

  /// No description provided for @driver_account_status_edit_personal.
  ///
  /// In en, this message translates to:
  /// **'Edit personal info'**
  String get driver_account_status_edit_personal;

  /// No description provided for @driver_account_status_edit_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit vehicle and dates'**
  String get driver_account_status_edit_vehicle;

  /// No description provided for @driver_account_status_edit_documents.
  ///
  /// In en, this message translates to:
  /// **'Edit uploaded documents'**
  String get driver_account_status_edit_documents;

  /// No description provided for @driver_account_status_document_valid.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get driver_account_status_document_valid;

  /// No description provided for @driver_account_status_document_review.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get driver_account_status_document_review;

  /// No description provided for @driver_account_status_document_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get driver_account_status_document_rejected;

  /// No description provided for @driver_account_status_document_expiring.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get driver_account_status_document_expiring;

  /// No description provided for @driver_account_status_verification_approved.
  ///
  /// In en, this message translates to:
  /// **'Verification approved'**
  String get driver_account_status_verification_approved;

  /// No description provided for @driver_account_status_verification_needs_documents.
  ///
  /// In en, this message translates to:
  /// **'Documents required'**
  String get driver_account_status_verification_needs_documents;

  /// No description provided for @driver_account_status_verification_under_review.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get driver_account_status_verification_under_review;

  /// No description provided for @driver_account_status_account_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get driver_account_status_account_active;

  /// No description provided for @driver_account_status_account_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get driver_account_status_account_pending;

  /// No description provided for @driver_account_status_missing_personal_info.
  ///
  /// In en, this message translates to:
  /// **'Missing personal info'**
  String get driver_account_status_missing_personal_info;

  /// No description provided for @driver_account_status_missing_vehicle_info.
  ///
  /// In en, this message translates to:
  /// **'Missing vehicle info'**
  String get driver_account_status_missing_vehicle_info;

  /// No description provided for @driver_account_status_missing_documents.
  ///
  /// In en, this message translates to:
  /// **'Missing documents'**
  String get driver_account_status_missing_documents;

  /// No description provided for @driver_account_status_expired_documents.
  ///
  /// In en, this message translates to:
  /// **'Expired documents'**
  String get driver_account_status_expired_documents;

  /// No description provided for @driver_account_status_rejected_documents.
  ///
  /// In en, this message translates to:
  /// **'Rejected documents'**
  String get driver_account_status_rejected_documents;

  /// No description provided for @driver_account_status_missing_region_city.
  ///
  /// In en, this message translates to:
  /// **'Region and city missing'**
  String get driver_account_status_missing_region_city;

  /// No description provided for @driver_account_status_document_rejected_banner.
  ///
  /// In en, this message translates to:
  /// **'A document needs your attention'**
  String get driver_account_status_document_rejected_banner;

  /// No description provided for @driver_account_status_document_approved_banner.
  ///
  /// In en, this message translates to:
  /// **'A document was approved'**
  String get driver_account_status_document_approved_banner;

  /// No description provided for @driver_account_status_request_docs_banner.
  ///
  /// In en, this message translates to:
  /// **'More documents are required'**
  String get driver_account_status_request_docs_banner;

  /// No description provided for @auth_blocked_title.
  ///
  /// In en, this message translates to:
  /// **'Account temporarily blocked'**
  String get auth_blocked_title;

  /// No description provided for @auth_blocked_description.
  ///
  /// In en, this message translates to:
  /// **'Access to your account is currently suspended. If you believe this action was taken by mistake, contact support to review your case.'**
  String get auth_blocked_description;

  /// No description provided for @auth_blocked_access_hint.
  ///
  /// In en, this message translates to:
  /// **'You will not be able to receive orders or use app features until the block is lifted or the account is reviewed by the admin team.'**
  String get auth_blocked_access_hint;

  /// No description provided for @auth_blocked_support_hint.
  ///
  /// In en, this message translates to:
  /// **'You can return to support and help to send an inquiry or follow up on the reason for the block and the account recovery steps.'**
  String get auth_blocked_support_hint;

  /// No description provided for @auth_blocked_rejection_policy_hint.
  ///
  /// In en, this message translates to:
  /// **'This daily block clears automatically tomorrow based on the server day, unless an admin clears it earlier.'**
  String get auth_blocked_rejection_policy_hint;

  /// No description provided for @auth_blocked_rejection_policy_reset_note.
  ///
  /// In en, this message translates to:
  /// **'Daily rejection freezes are cleared automatically on the next server day. Admins can also clear the restriction earlier.'**
  String get auth_blocked_rejection_policy_reset_note;

  /// No description provided for @auth_contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get auth_contact_support;

  /// No description provided for @auth_logout_account.
  ///
  /// In en, this message translates to:
  /// **'Log out of account'**
  String get auth_logout_account;

  /// No description provided for @auth_session_parse_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to read session data from the sign-in response.'**
  String get auth_session_parse_error;

  /// No description provided for @driver_home_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get driver_home_accept;

  /// No description provided for @driver_home_reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get driver_home_reject;

  /// No description provided for @driver_home_pickup_label.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get driver_home_pickup_label;

  /// No description provided for @driver_home_delivery_label.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get driver_home_delivery_label;

  /// No description provided for @driver_home_distance_unit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get driver_home_distance_unit;

  /// No description provided for @driver_home_accept_order_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Accept order confirmation'**
  String get driver_home_accept_order_dialog_title;

  /// No description provided for @driver_home_accept_order_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to accept {orderTitle} from {vendorName} and continue to the order details?'**
  String driver_home_accept_order_dialog_message(
    Object orderTitle,
    Object vendorName,
  );

  /// No description provided for @driver_home_accept_order_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm acceptance'**
  String get driver_home_accept_order_dialog_confirm;

  /// No description provided for @driver_home_reject_order_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Reject order confirmation'**
  String get driver_home_reject_order_dialog_title;

  /// No description provided for @driver_home_reject_order_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reject {orderTitle} from {vendorName} and wait for the next offer?'**
  String driver_home_reject_order_dialog_message(
    Object orderTitle,
    Object vendorName,
  );

  /// No description provided for @driver_home_reject_order_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm rejection'**
  String get driver_home_reject_order_dialog_confirm;

  /// No description provided for @driver_home_connection_online_title.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get driver_home_connection_online_title;

  /// No description provided for @driver_home_connection_offline_title.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get driver_home_connection_offline_title;

  /// No description provided for @driver_home_connection_online_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for orders'**
  String get driver_home_connection_online_subtitle;

  /// No description provided for @driver_home_connection_offline_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Temporarily paused'**
  String get driver_home_connection_offline_subtitle;

  /// No description provided for @driver_profile_mock_address.
  ///
  /// In en, this message translates to:
  /// **'Al Narjis, Riyadh'**
  String get driver_profile_mock_address;

  /// No description provided for @driver_profile_mock_national_id.
  ///
  /// In en, this message translates to:
  /// **'29801011234567'**
  String get driver_profile_mock_national_id;

  /// No description provided for @driver_profile_mock_license_number.
  ///
  /// In en, this message translates to:
  /// **'C-452188'**
  String get driver_profile_mock_license_number;

  /// No description provided for @driver_profile_mock_vehicle_brand.
  ///
  /// In en, this message translates to:
  /// **'Yamaha'**
  String get driver_profile_mock_vehicle_brand;

  /// No description provided for @driver_profile_mock_vehicle_model.
  ///
  /// In en, this message translates to:
  /// **'NMAX 2023'**
  String get driver_profile_mock_vehicle_model;

  /// No description provided for @driver_profile_mock_plate_number.
  ///
  /// In en, this message translates to:
  /// **'STR 2486'**
  String get driver_profile_mock_plate_number;

  /// No description provided for @completed_orders_title.
  ///
  /// In en, this message translates to:
  /// **'Completed Orders'**
  String get completed_orders_title;

  /// No description provided for @completed_orders_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Review delivered, cancelled, and failed delivery orders in one organized history.'**
  String get completed_orders_subtitle;

  /// No description provided for @completed_orders_history_badge.
  ///
  /// In en, this message translates to:
  /// **'History Archive'**
  String get completed_orders_history_badge;

  /// No description provided for @completed_orders_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by order id, merchant, customer, or address'**
  String get completed_orders_search_hint;

  /// No description provided for @completed_orders_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get completed_orders_filter_all;

  /// No description provided for @completed_orders_merchant_label.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get completed_orders_merchant_label;

  /// No description provided for @completed_orders_customer_label.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get completed_orders_customer_label;

  /// No description provided for @completed_orders_customer_name_label.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get completed_orders_customer_name_label;

  /// No description provided for @completed_orders_delivery_address_label.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get completed_orders_delivery_address_label;

  /// No description provided for @completed_orders_summary_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get completed_orders_summary_orders;

  /// No description provided for @completed_orders_summary_distance.
  ///
  /// In en, this message translates to:
  /// **'Distance km'**
  String get completed_orders_summary_distance;

  /// No description provided for @completed_orders_distance_label.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get completed_orders_distance_label;

  /// No description provided for @completed_orders_order_total_label.
  ///
  /// In en, this message translates to:
  /// **'Order total'**
  String get completed_orders_order_total_label;

  /// No description provided for @completed_orders_view_details_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get completed_orders_view_details_hint;

  /// No description provided for @completed_orders_customer_section_title.
  ///
  /// In en, this message translates to:
  /// **'Customer information'**
  String get completed_orders_customer_section_title;

  /// No description provided for @completed_orders_order_details_section_title.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get completed_orders_order_details_section_title;

  /// No description provided for @completed_orders_items_section_title.
  ///
  /// In en, this message translates to:
  /// **'Items & quantities'**
  String get completed_orders_items_section_title;

  /// No description provided for @completed_orders_date_label.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get completed_orders_date_label;

  /// No description provided for @completed_orders_time_label.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get completed_orders_time_label;

  /// No description provided for @completed_orders_order_number_prefix.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get completed_orders_order_number_prefix;

  /// No description provided for @completed_orders_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No completed orders yet'**
  String get completed_orders_empty_title;

  /// No description provided for @completed_orders_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Finished driver trips will appear here once an order is delivered, cancelled, or marked as failed.'**
  String get completed_orders_empty_subtitle;

  /// No description provided for @completed_orders_no_results_title.
  ///
  /// In en, this message translates to:
  /// **'No matching orders found'**
  String get completed_orders_no_results_title;

  /// No description provided for @completed_orders_no_results_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another search term or clear the active status filter.'**
  String get completed_orders_no_results_subtitle;

  /// No description provided for @order_delivery_failed.
  ///
  /// In en, this message translates to:
  /// **'Delivery Failed'**
  String get order_delivery_failed;

  /// No description provided for @completed_orders_card_title.
  ///
  /// In en, this message translates to:
  /// **'Your Order'**
  String get completed_orders_card_title;

  /// No description provided for @nav_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get nav_wallet;

  /// No description provided for @wallet_title.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet_title;

  /// No description provided for @wallet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your live balance, payout readiness, incentives, and every movement in one premium dashboard.'**
  String get wallet_subtitle;

  /// No description provided for @wallet_subtitle_secure.
  ///
  /// In en, this message translates to:
  /// **'Review your live balance, recent activity, and payout readiness in one secure wallet hub.'**
  String get wallet_subtitle_secure;

  /// No description provided for @wallet_subtitle_ready.
  ///
  /// In en, this message translates to:
  /// **'Your net withdrawable balance is ready now.'**
  String get wallet_subtitle_ready;

  /// No description provided for @wallet_subtitle_add_primary.
  ///
  /// In en, this message translates to:
  /// **'Add a primary payout method to start withdrawing.'**
  String get wallet_subtitle_add_primary;

  /// No description provided for @wallet_subtitle_cod_blocked.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal is blocked until COD dues are settled.'**
  String get wallet_subtitle_cod_blocked;

  /// No description provided for @wallet_subtitle_no_withdrawable.
  ///
  /// In en, this message translates to:
  /// **'There is no net withdrawable balance right now.'**
  String get wallet_subtitle_no_withdrawable;

  /// No description provided for @wallet_preview_state.
  ///
  /// In en, this message translates to:
  /// **'Preview state'**
  String get wallet_preview_state;

  /// No description provided for @wallet_state_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get wallet_state_success;

  /// No description provided for @wallet_state_empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get wallet_state_empty;

  /// No description provided for @wallet_state_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get wallet_state_error;

  /// No description provided for @wallet_current_balance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get wallet_current_balance;

  /// No description provided for @wallet_available_to_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Available to withdraw'**
  String get wallet_available_to_withdraw;

  /// No description provided for @wallet_pending_balance.
  ///
  /// In en, this message translates to:
  /// **'Pending balance'**
  String get wallet_pending_balance;

  /// No description provided for @wallet_cod_owed_balance.
  ///
  /// In en, this message translates to:
  /// **'COD due'**
  String get wallet_cod_owed_balance;

  /// No description provided for @wallet_withdraw_cta.
  ///
  /// In en, this message translates to:
  /// **'Withdraw now'**
  String get wallet_withdraw_cta;

  /// No description provided for @wallet_withdraw_success.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request created successfully.'**
  String get wallet_withdraw_success;

  /// No description provided for @wallet_earnings_summary.
  ///
  /// In en, this message translates to:
  /// **'Earnings summary'**
  String get wallet_earnings_summary;

  /// No description provided for @wallet_metric_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get wallet_metric_today;

  /// No description provided for @wallet_metric_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get wallet_metric_week;

  /// No description provided for @wallet_metric_month.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get wallet_metric_month;

  /// No description provided for @wallet_transaction_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get wallet_transaction_history;

  /// No description provided for @wallet_payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get wallet_payment_methods;

  /// No description provided for @wallet_bonuses.
  ///
  /// In en, this message translates to:
  /// **'Bonuses & incentives'**
  String get wallet_bonuses;

  /// No description provided for @wallet_alerts.
  ///
  /// In en, this message translates to:
  /// **'Wallet alerts'**
  String get wallet_alerts;

  /// No description provided for @wallet_primary_method.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get wallet_primary_method;

  /// No description provided for @wallet_unverified_method.
  ///
  /// In en, this message translates to:
  /// **'Needs verification'**
  String get wallet_unverified_method;

  /// No description provided for @wallet_bonus_progress.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get wallet_bonus_progress;

  /// No description provided for @wallet_bonus_unlock_before.
  ///
  /// In en, this message translates to:
  /// **'Unlock before'**
  String get wallet_bonus_unlock_before;

  /// No description provided for @wallet_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Your wallet is ready for the first payout'**
  String get wallet_empty_title;

  /// No description provided for @wallet_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete a few delivery trips and your earnings, history, and payout options will appear here.'**
  String get wallet_empty_subtitle;

  /// No description provided for @wallet_error_title.
  ///
  /// In en, this message translates to:
  /// **'Unable to load wallet right now'**
  String get wallet_error_title;

  /// No description provided for @wallet_error_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We could not fetch the latest wallet snapshot. Try again in a moment.'**
  String get wallet_error_subtitle;

  /// No description provided for @wallet_retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get wallet_retry;

  /// No description provided for @wallet_status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get wallet_status_completed;

  /// No description provided for @wallet_status_ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get wallet_status_ready;

  /// No description provided for @wallet_status_blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get wallet_status_blocked;

  /// No description provided for @wallet_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get wallet_status_pending;

  /// No description provided for @wallet_status_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get wallet_status_failed;

  /// No description provided for @wallet_transaction_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery earnings'**
  String get wallet_transaction_delivery;

  /// No description provided for @wallet_transaction_withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal paid'**
  String get wallet_transaction_withdrawal;

  /// No description provided for @wallet_transaction_bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus payout'**
  String get wallet_transaction_bonus;

  /// No description provided for @wallet_transaction_refund.
  ///
  /// In en, this message translates to:
  /// **'Refund/reversal'**
  String get wallet_transaction_refund;

  /// No description provided for @wallet_transaction_settlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get wallet_transaction_settlement;

  /// No description provided for @wallet_transaction_adjustment.
  ///
  /// In en, this message translates to:
  /// **'Wallet adjustment'**
  String get wallet_transaction_adjustment;

  /// No description provided for @wallet_transaction_cash_collected.
  ///
  /// In en, this message translates to:
  /// **'COD collection/remittance'**
  String get wallet_transaction_cash_collected;

  /// No description provided for @wallet_transaction_hold.
  ///
  /// In en, this message translates to:
  /// **'Held balance'**
  String get wallet_transaction_hold;

  /// No description provided for @wallet_transaction_release.
  ///
  /// In en, this message translates to:
  /// **'Released balance'**
  String get wallet_transaction_release;

  /// No description provided for @wallet_transaction_credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get wallet_transaction_credit;

  /// No description provided for @wallet_transaction_debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get wallet_transaction_debit;

  /// No description provided for @wallet_transaction_generic.
  ///
  /// In en, this message translates to:
  /// **'Wallet transaction'**
  String get wallet_transaction_generic;

  /// No description provided for @wallet_direction_in.
  ///
  /// In en, this message translates to:
  /// **'IN'**
  String get wallet_direction_in;

  /// No description provided for @wallet_direction_out.
  ///
  /// In en, this message translates to:
  /// **'OUT'**
  String get wallet_direction_out;

  /// No description provided for @wallet_payment_bank_account.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get wallet_payment_bank_account;

  /// No description provided for @wallet_payment_mobile_wallet.
  ///
  /// In en, this message translates to:
  /// **'Mobile wallet'**
  String get wallet_payment_mobile_wallet;

  /// No description provided for @wallet_payment_debit_card.
  ///
  /// In en, this message translates to:
  /// **'Debit card'**
  String get wallet_payment_debit_card;

  /// No description provided for @wallet_payment_instant_transfer.
  ///
  /// In en, this message translates to:
  /// **'Instant transfer'**
  String get wallet_payment_instant_transfer;

  /// No description provided for @wallet_withdrawal_requests.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal requests'**
  String get wallet_withdrawal_requests;

  /// No description provided for @wallet_pending_requests.
  ///
  /// In en, this message translates to:
  /// **'Pending requests'**
  String get wallet_pending_requests;

  /// No description provided for @wallet_pending_requests_amount.
  ///
  /// In en, this message translates to:
  /// **'Pending amount'**
  String get wallet_pending_requests_amount;

  /// No description provided for @wallet_total_requests.
  ///
  /// In en, this message translates to:
  /// **'Total requests'**
  String get wallet_total_requests;

  /// No description provided for @wallet_view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get wallet_view_all;

  /// No description provided for @wallet_transactions_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No wallet transactions yet'**
  String get wallet_transactions_empty_title;

  /// No description provided for @wallet_transactions_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed deliveries and wallet movements will appear here.'**
  String get wallet_transactions_empty_subtitle;

  /// No description provided for @wallet_withdrawals_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No withdrawal requests yet'**
  String get wallet_withdrawals_empty_title;

  /// No description provided for @wallet_withdrawals_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your withdrawal history will appear here after the first payout request.'**
  String get wallet_withdrawals_empty_subtitle;

  /// No description provided for @wallet_load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get wallet_load_more;

  /// No description provided for @wallet_add_method.
  ///
  /// In en, this message translates to:
  /// **'Add method'**
  String get wallet_add_method;

  /// No description provided for @wallet_methods_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No payout methods added'**
  String get wallet_methods_empty_title;

  /// No description provided for @wallet_methods_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a secure payout method to start withdrawing your wallet balance.'**
  String get wallet_methods_empty_subtitle;

  /// No description provided for @wallet_withdraw_title.
  ///
  /// In en, this message translates to:
  /// **'Create withdrawal request'**
  String get wallet_withdraw_title;

  /// No description provided for @wallet_withdraw_info_hint.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals are processed securely using your selected payout method.'**
  String get wallet_withdraw_info_hint;

  /// No description provided for @wallet_withdraw_amount_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you want to transfer from your wallet balance.'**
  String get wallet_withdraw_amount_subtitle;

  /// No description provided for @wallet_withdraw_method_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose whether to use the primary payout method or select another saved method.'**
  String get wallet_withdraw_method_subtitle;

  /// No description provided for @wallet_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get wallet_amount_label;

  /// No description provided for @wallet_amount_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get wallet_amount_hint;

  /// No description provided for @wallet_amount_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get wallet_amount_invalid;

  /// No description provided for @wallet_amount_exceeds_balance.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds available balance.'**
  String get wallet_amount_exceeds_balance;

  /// No description provided for @wallet_use_primary_method.
  ///
  /// In en, this message translates to:
  /// **'Use primary payout method'**
  String get wallet_use_primary_method;

  /// No description provided for @wallet_no_primary_method.
  ///
  /// In en, this message translates to:
  /// **'No primary method available'**
  String get wallet_no_primary_method;

  /// No description provided for @wallet_withdraw_blocked_no_primary.
  ///
  /// In en, this message translates to:
  /// **'Add a primary payout method before requesting a withdrawal.'**
  String get wallet_withdraw_blocked_no_primary;

  /// No description provided for @wallet_withdraw_blocked_cod.
  ///
  /// In en, this message translates to:
  /// **'Settle outstanding COD cash before requesting a withdrawal.'**
  String get wallet_withdraw_blocked_cod;

  /// No description provided for @wallet_withdraw_blocked_no_balance.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal amount exceeds net available balance after COD obligations.'**
  String get wallet_withdraw_blocked_no_balance;

  /// No description provided for @wallet_select_method.
  ///
  /// In en, this message translates to:
  /// **'Select a payout method.'**
  String get wallet_select_method;

  /// No description provided for @wallet_method_saved.
  ///
  /// In en, this message translates to:
  /// **'Payout method added successfully.'**
  String get wallet_method_saved;

  /// No description provided for @wallet_method_updated.
  ///
  /// In en, this message translates to:
  /// **'Payout method updated successfully.'**
  String get wallet_method_updated;

  /// No description provided for @wallet_method_deleted.
  ///
  /// In en, this message translates to:
  /// **'Payout method deleted successfully.'**
  String get wallet_method_deleted;

  /// No description provided for @wallet_method_pending_approval.
  ///
  /// In en, this message translates to:
  /// **'Payout method change is pending admin approval.'**
  String get wallet_method_pending_approval;

  /// No description provided for @wallet_make_primary.
  ///
  /// In en, this message translates to:
  /// **'Make primary'**
  String get wallet_make_primary;

  /// No description provided for @wallet_primary_updated.
  ///
  /// In en, this message translates to:
  /// **'Primary payout method updated.'**
  String get wallet_primary_updated;

  /// No description provided for @wallet_delete_method_title.
  ///
  /// In en, this message translates to:
  /// **'Delete payout method?'**
  String get wallet_delete_method_title;

  /// No description provided for @wallet_delete_method_message.
  ///
  /// In en, this message translates to:
  /// **'This action removes the payout method if it is not linked to withdrawal history.'**
  String get wallet_delete_method_message;

  /// No description provided for @wallet_edit_method_title.
  ///
  /// In en, this message translates to:
  /// **'Edit payout method'**
  String get wallet_edit_method_title;

  /// No description provided for @wallet_type_label.
  ///
  /// In en, this message translates to:
  /// **'Method type'**
  String get wallet_type_label;

  /// No description provided for @wallet_account_holder_label.
  ///
  /// In en, this message translates to:
  /// **'Account holder name'**
  String get wallet_account_holder_label;

  /// No description provided for @wallet_provider_name_label.
  ///
  /// In en, this message translates to:
  /// **'Provider name'**
  String get wallet_provider_name_label;

  /// No description provided for @wallet_account_identifier_label.
  ///
  /// In en, this message translates to:
  /// **'Account identifier'**
  String get wallet_account_identifier_label;

  /// No description provided for @wallet_identifier_reentry_hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter the full identifier to keep this payment method secure.'**
  String get wallet_identifier_reentry_hint;

  /// No description provided for @wallet_identifier_secure_hint.
  ///
  /// In en, this message translates to:
  /// **'The full identifier is sent securely and never shown back in the wallet UI.'**
  String get wallet_identifier_secure_hint;

  /// No description provided for @wallet_save_action.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get wallet_save_action;

  /// No description provided for @wallet_status_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get wallet_status_processing;

  /// No description provided for @wallet_status_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get wallet_status_paid;

  /// No description provided for @wallet_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get wallet_status_cancelled;

  /// No description provided for @wallet_transfer_reference.
  ///
  /// In en, this message translates to:
  /// **'Transfer ref'**
  String get wallet_transfer_reference;

  /// No description provided for @wallet_bonus_weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend challenge'**
  String get wallet_bonus_weekend;

  /// No description provided for @wallet_bonus_consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency streak'**
  String get wallet_bonus_consistency;

  /// No description provided for @wallet_bonus_peak_hours.
  ///
  /// In en, this message translates to:
  /// **'Peak hours boost'**
  String get wallet_bonus_peak_hours;

  /// No description provided for @wallet_alert_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Verify your payout account'**
  String get wallet_alert_verification_title;

  /// No description provided for @wallet_alert_verification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick account verification keeps withdrawals smooth and secure.'**
  String get wallet_alert_verification_subtitle;

  /// No description provided for @wallet_alert_payout_title.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal is being processed'**
  String get wallet_alert_payout_title;

  /// No description provided for @wallet_alert_payout_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your latest payout request is queued and should arrive within the expected settlement window.'**
  String get wallet_alert_payout_subtitle;

  /// No description provided for @wallet_cod_block_title.
  ///
  /// In en, this message translates to:
  /// **'Outstanding COD cash blocks withdrawal'**
  String get wallet_cod_block_title;

  /// No description provided for @wallet_cod_block_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Admin must reconcile your COD remittance before you can withdraw from the wallet.'**
  String get wallet_cod_block_subtitle;

  /// No description provided for @wallet_alert_incentive_title.
  ///
  /// In en, this message translates to:
  /// **'New incentive unlocked'**
  String get wallet_alert_incentive_title;

  /// No description provided for @wallet_alert_incentive_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You are close to unlocking an extra driver reward during peak delivery hours.'**
  String get wallet_alert_incentive_subtitle;

  /// No description provided for @wallet_alert_action_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get wallet_alert_action_verify;

  /// No description provided for @wallet_alert_action_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get wallet_alert_action_view;

  /// No description provided for @wallet_alert_action_claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get wallet_alert_action_claim;

  /// No description provided for @profile_edit_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profile_edit_profile_title;

  /// No description provided for @profile_edit_profile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal, vehicle, and attachment details'**
  String get profile_edit_profile_subtitle;

  /// No description provided for @profile_language_subtitle.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profile_language_subtitle;

  /// No description provided for @profile_notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Open notifications and manage alert preferences'**
  String get profile_notifications_subtitle;

  /// No description provided for @profile_change_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Open security settings to manage your password'**
  String get profile_change_password_subtitle;

  /// No description provided for @profile_update_action.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get profile_update_action;

  /// No description provided for @profile_support_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reach us or browse help resources'**
  String get profile_support_subtitle;

  /// No description provided for @profile_privacy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn about data collection, storage, and usage'**
  String get profile_privacy_subtitle;

  /// No description provided for @profile_logout_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out from this device securely'**
  String get profile_logout_subtitle;

  /// No description provided for @profile_logout_success.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get profile_logout_success;

  /// No description provided for @profile_language_info.
  ///
  /// In en, this message translates to:
  /// **'Language settings are currently available in English'**
  String get profile_language_info;

  /// No description provided for @profile_default_name.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get profile_default_name;

  /// No description provided for @profile_default_email.
  ///
  /// In en, this message translates to:
  /// **'example@zadana.com'**
  String get profile_default_email;

  /// No description provided for @profile_default_phone.
  ///
  /// In en, this message translates to:
  /// **'+20 100 000 0000'**
  String get profile_default_phone;

  /// No description provided for @profile_security_documents_title.
  ///
  /// In en, this message translates to:
  /// **'Security and documents'**
  String get profile_security_documents_title;

  /// No description provided for @profile_documents_uploaded_count.
  ///
  /// In en, this message translates to:
  /// **'Uploaded documents: {count}/5'**
  String profile_documents_uploaded_count(Object count);

  /// No description provided for @profile_current_documents.
  ///
  /// In en, this message translates to:
  /// **'Current documents'**
  String get profile_current_documents;

  /// No description provided for @profile_not_uploaded_yet.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded yet'**
  String get profile_not_uploaded_yet;

  /// No description provided for @profile_personal_info_saved.
  ///
  /// In en, this message translates to:
  /// **'Personal information saved successfully'**
  String get profile_personal_info_saved;

  /// No description provided for @profile_vehicle_info_saved.
  ///
  /// In en, this message translates to:
  /// **'Vehicle information saved successfully'**
  String get profile_vehicle_info_saved;

  /// No description provided for @profile_security_documents_saved.
  ///
  /// In en, this message translates to:
  /// **'Security and documents saved successfully'**
  String get profile_security_documents_saved;

  /// No description provided for @profile_change_pending_approval.
  ///
  /// In en, this message translates to:
  /// **'Your changes have been submitted for review. They will be applied after admin approval.'**
  String get profile_change_pending_approval;

  /// No description provided for @order_details_title.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get order_details_title;

  /// No description provided for @order_details_distance_label.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get order_details_distance_label;

  /// No description provided for @order_details_accept_order.
  ///
  /// In en, this message translates to:
  /// **'Accept order'**
  String get order_details_accept_order;

  /// No description provided for @order_details_reject_order.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get order_details_reject_order;

  /// No description provided for @order_details_show_pickup_code.
  ///
  /// In en, this message translates to:
  /// **'Show pickup code from store'**
  String get order_details_show_pickup_code;

  /// No description provided for @order_details_start_delivery.
  ///
  /// In en, this message translates to:
  /// **'Start delivery to customer'**
  String get order_details_start_delivery;

  /// No description provided for @order_details_confirm_delivery_with_code.
  ///
  /// In en, this message translates to:
  /// **'Confirm delivery with customer code'**
  String get order_details_confirm_delivery_with_code;

  /// No description provided for @order_details_order_delivered.
  ///
  /// In en, this message translates to:
  /// **'Order delivered'**
  String get order_details_order_delivered;

  /// No description provided for @order_details_customer_details_title.
  ///
  /// In en, this message translates to:
  /// **'Customer details'**
  String get order_details_customer_details_title;

  /// No description provided for @order_details_customer_name_label.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get order_details_customer_name_label;

  /// No description provided for @order_details_customer_address_label.
  ///
  /// In en, this message translates to:
  /// **'Customer address'**
  String get order_details_customer_address_label;

  /// No description provided for @order_details_pickup_details_title.
  ///
  /// In en, this message translates to:
  /// **'Pickup details'**
  String get order_details_pickup_details_title;

  /// No description provided for @order_details_store_label.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get order_details_store_label;

  /// No description provided for @order_details_store_address_label.
  ///
  /// In en, this message translates to:
  /// **'Store address'**
  String get order_details_store_address_label;

  /// No description provided for @order_details_open_customer_location.
  ///
  /// In en, this message translates to:
  /// **'Open customer location'**
  String get order_details_open_customer_location;

  /// No description provided for @order_details_open_customer_location_hint.
  ///
  /// In en, this message translates to:
  /// **'Opens the customer\'s location in maps'**
  String get order_details_open_customer_location_hint;

  /// No description provided for @order_details_open_store_location.
  ///
  /// In en, this message translates to:
  /// **'Open store location'**
  String get order_details_open_store_location;

  /// No description provided for @order_details_open_store_location_hint.
  ///
  /// In en, this message translates to:
  /// **'Opens the store location in maps'**
  String get order_details_open_store_location_hint;

  /// No description provided for @order_details_customer_otp_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer\'s delivery code'**
  String get order_details_customer_otp_hint;

  /// No description provided for @order_details_customer_otp_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm order delivery'**
  String get order_details_customer_otp_title;

  /// No description provided for @order_details_customer_otp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Take the delivery code from the customer and enter it here to complete delivery'**
  String get order_details_customer_otp_subtitle;

  /// No description provided for @order_details_confirm_delivery.
  ///
  /// In en, this message translates to:
  /// **'Confirm delivery'**
  String get order_details_confirm_delivery;

  /// No description provided for @order_details_resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get order_details_resend_otp;

  /// No description provided for @order_details_resend_otp_in.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String order_details_resend_otp_in(int seconds);

  /// No description provided for @order_details_pickup_code_title.
  ///
  /// In en, this message translates to:
  /// **'Order pickup code'**
  String get order_details_pickup_code_title;

  /// No description provided for @order_details_pickup_code_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Show this code to the store so the order can be handed to you'**
  String get order_details_pickup_code_subtitle;

  /// No description provided for @order_details_pickup_code_copied.
  ///
  /// In en, this message translates to:
  /// **'Pickup code copied'**
  String get order_details_pickup_code_copied;

  /// No description provided for @order_details_waiting_for_merchant_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for merchant confirmation...'**
  String get order_details_waiting_for_merchant_confirmation;

  /// No description provided for @order_details_confirm_pickup.
  ///
  /// In en, this message translates to:
  /// **'Confirm pickup from store'**
  String get order_details_confirm_pickup;

  /// No description provided for @order_details_arrived_at_vendor.
  ///
  /// In en, this message translates to:
  /// **'Arrived at vendor'**
  String get order_details_arrived_at_vendor;

  /// No description provided for @order_details_arrived_at_customer.
  ///
  /// In en, this message translates to:
  /// **'Arrived at customer'**
  String get order_details_arrived_at_customer;

  /// No description provided for @order_details_order_items_title.
  ///
  /// In en, this message translates to:
  /// **'Order items'**
  String get order_details_order_items_title;

  /// No description provided for @order_details_items_unit.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get order_details_items_unit;

  /// No description provided for @order_details_pieces_unit.
  ///
  /// In en, this message translates to:
  /// **'pieces'**
  String get order_details_pieces_unit;

  /// No description provided for @order_details_route_map_title.
  ///
  /// In en, this message translates to:
  /// **'Route map'**
  String get order_details_route_map_title;

  /// No description provided for @order_details_map_hint.
  ///
  /// In en, this message translates to:
  /// **'Drag and zoom the map'**
  String get order_details_map_hint;

  /// No description provided for @order_details_items_details_title.
  ///
  /// In en, this message translates to:
  /// **'Received order details'**
  String get order_details_items_details_title;

  /// No description provided for @order_details_total_pieces_label.
  ///
  /// In en, this message translates to:
  /// **'Total pieces'**
  String get order_details_total_pieces_label;

  /// No description provided for @order_details_items_count_label.
  ///
  /// In en, this message translates to:
  /// **'Items count'**
  String get order_details_items_count_label;

  /// No description provided for @order_details_view_products.
  ///
  /// In en, this message translates to:
  /// **'View products'**
  String get order_details_view_products;

  /// No description provided for @order_details_status_accepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted'**
  String get order_details_status_accepted;

  /// No description provided for @order_details_status_picked_up.
  ///
  /// In en, this message translates to:
  /// **'Picked up from store'**
  String get order_details_status_picked_up;

  /// No description provided for @order_details_status_on_the_way.
  ///
  /// In en, this message translates to:
  /// **'On the way to customer'**
  String get order_details_status_on_the_way;

  /// No description provided for @order_details_status_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get order_details_status_delivered;

  /// No description provided for @order_details_sheet_hint.
  ///
  /// In en, this message translates to:
  /// **'In the demo build, any 4 digits will work for confirmation'**
  String get order_details_sheet_hint;

  /// No description provided for @order_details_enter_otp_snackbar.
  ///
  /// In en, this message translates to:
  /// **'Enter the code so we can confirm delivery'**
  String get order_details_enter_otp_snackbar;

  /// No description provided for @order_details_package_note_fallback.
  ///
  /// In en, this message translates to:
  /// **'Review the item count and make sure the package is sealed before moving.'**
  String get order_details_package_note_fallback;

  /// No description provided for @order_details_accept_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Accept order confirmation'**
  String get order_details_accept_dialog_title;

  /// No description provided for @order_details_accept_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to accept {orderTitle} and start working on the order now?'**
  String order_details_accept_dialog_message(Object orderTitle);

  /// No description provided for @order_details_accept_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm acceptance'**
  String get order_details_accept_dialog_confirm;

  /// No description provided for @order_details_pickup_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm pickup from store'**
  String get order_details_pickup_dialog_title;

  /// No description provided for @order_details_pickup_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm picking up the order from {vendorName} and that all items are ready with you?'**
  String order_details_pickup_dialog_message(Object vendorName);

  /// No description provided for @order_details_pickup_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm pickup'**
  String get order_details_pickup_dialog_confirm;

  /// No description provided for @order_details_arrived_vendor_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm arrival at store'**
  String get order_details_arrived_vendor_dialog_title;

  /// No description provided for @order_details_arrived_vendor_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm that you have arrived at {vendorName}?'**
  String order_details_arrived_vendor_dialog_message(String vendorName);

  /// No description provided for @order_details_arrived_vendor_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm arrival'**
  String get order_details_arrived_vendor_dialog_confirm;

  /// No description provided for @order_details_start_delivery_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Start delivery confirmation'**
  String get order_details_start_delivery_dialog_title;

  /// No description provided for @order_details_start_delivery_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to start heading to the customer now?'**
  String get order_details_start_delivery_dialog_message;

  /// No description provided for @order_details_start_delivery_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Start delivery'**
  String get order_details_start_delivery_dialog_confirm;

  /// No description provided for @order_details_arrived_customer_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm arrival at customer'**
  String get order_details_arrived_customer_dialog_title;

  /// No description provided for @order_details_arrived_customer_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm that you have arrived at the customer\'s location?'**
  String get order_details_arrived_customer_dialog_message;

  /// No description provided for @order_details_arrived_customer_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm arrival'**
  String get order_details_arrived_customer_dialog_confirm;

  /// No description provided for @order_details_delivered_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm order delivery'**
  String get order_details_delivered_dialog_title;

  /// No description provided for @order_details_delivered_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm that the order has been delivered successfully?'**
  String get order_details_delivered_dialog_message;

  /// No description provided for @order_details_delivered_dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm delivery'**
  String get order_details_delivered_dialog_confirm;

  /// No description provided for @order_delivery_success_title.
  ///
  /// In en, this message translates to:
  /// **'Order delivered successfully'**
  String get order_delivery_success_title;

  /// No description provided for @order_delivery_success_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Nice work. This trip is complete and you can head back to check new orders now.'**
  String get order_delivery_success_subtitle;

  /// No description provided for @order_delivery_success_button.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get order_delivery_success_button;

  /// No description provided for @order_details_call_failure.
  ///
  /// In en, this message translates to:
  /// **'Could not open the calling app on this device'**
  String get order_details_call_failure;

  /// No description provided for @order_details_maps_failure.
  ///
  /// In en, this message translates to:
  /// **'Could not open the maps app on this device'**
  String get order_details_maps_failure;

  /// No description provided for @order_details_status_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Order status updated successfully'**
  String get order_details_status_updated_success;

  /// No description provided for @order_details_status_updated_title.
  ///
  /// In en, this message translates to:
  /// **'Order status updated'**
  String get order_details_status_updated_title;

  /// No description provided for @order_details_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get order_details_ok;

  /// No description provided for @order_support_composer_title.
  ///
  /// In en, this message translates to:
  /// **'Create support case'**
  String get order_support_composer_title;

  /// No description provided for @order_support_composer_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue and attach files before sending the case.'**
  String get order_support_composer_subtitle;

  /// No description provided for @order_support_mode_issue_title.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get order_support_mode_issue_title;

  /// No description provided for @order_support_mode_issue_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get order_support_mode_issue_subtitle;

  /// No description provided for @order_support_mode_dispute_title.
  ///
  /// In en, this message translates to:
  /// **'Dispute'**
  String get order_support_mode_dispute_title;

  /// No description provided for @order_support_mode_dispute_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Objection'**
  String get order_support_mode_dispute_subtitle;

  /// No description provided for @order_support_reason_label.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get order_support_reason_label;

  /// No description provided for @order_support_message_label_required.
  ///
  /// In en, this message translates to:
  /// **'Required note'**
  String get order_support_message_label_required;

  /// No description provided for @order_support_message_label_optional.
  ///
  /// In en, this message translates to:
  /// **'Additional note'**
  String get order_support_message_label_optional;

  /// No description provided for @order_support_message_hint.
  ///
  /// In en, this message translates to:
  /// **'Write what happened'**
  String get order_support_message_hint;

  /// No description provided for @order_support_message_helper.
  ///
  /// In en, this message translates to:
  /// **'This reason requires a note before submission.'**
  String get order_support_message_helper;

  /// No description provided for @order_support_submit_issue.
  ///
  /// In en, this message translates to:
  /// **'Send case'**
  String get order_support_submit_issue;

  /// No description provided for @order_support_submit_dispute.
  ///
  /// In en, this message translates to:
  /// **'Send dispute'**
  String get order_support_submit_dispute;

  /// No description provided for @order_support_attach_files.
  ///
  /// In en, this message translates to:
  /// **'Attach files'**
  String get order_support_attach_files;

  /// No description provided for @order_support_attach_more_files.
  ///
  /// In en, this message translates to:
  /// **'Attach more files'**
  String get order_support_attach_more_files;

  /// No description provided for @order_support_error_reasons_loading.
  ///
  /// In en, this message translates to:
  /// **'Unable to load reasons right now. Please retry first.'**
  String get order_support_error_reasons_loading;

  /// No description provided for @order_support_error_no_reasons.
  ///
  /// In en, this message translates to:
  /// **'No reasons are available for this type right now.'**
  String get order_support_error_no_reasons;

  /// No description provided for @order_support_error_choose_reason.
  ///
  /// In en, this message translates to:
  /// **'Choose a reason'**
  String get order_support_error_choose_reason;

  /// No description provided for @order_support_error_message_required.
  ///
  /// In en, this message translates to:
  /// **'Enter a message to clarify the reason'**
  String get order_support_error_message_required;

  /// No description provided for @order_support_error_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Unable to upload the selected images. Please try again.'**
  String get order_support_error_upload_failed;

  /// No description provided for @order_support_error_picker_failed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the image picker. Please try again.'**
  String get order_support_error_picker_failed;

  /// No description provided for @order_support_reasons_empty.
  ///
  /// In en, this message translates to:
  /// **'No reasons are available right now. Please try again later.'**
  String get order_support_reasons_empty;

  /// No description provided for @order_support_stage_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get order_support_stage_pending;

  /// No description provided for @order_support_stage_accepted.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get order_support_stage_accepted;

  /// No description provided for @order_support_stage_arrived_at_vendor.
  ///
  /// In en, this message translates to:
  /// **'Arrived at store'**
  String get order_support_stage_arrived_at_vendor;

  /// No description provided for @order_support_stage_picked_up.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get order_support_stage_picked_up;

  /// No description provided for @order_support_stage_on_the_way.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get order_support_stage_on_the_way;

  /// No description provided for @order_support_stage_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get order_support_stage_delivered;

  /// No description provided for @profile_section_under_review_title.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get profile_section_under_review_title;

  /// No description provided for @profile_section_under_review_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your changes have been submitted and are pending admin approval. The displayed data is the currently approved version.'**
  String get profile_section_under_review_subtitle;

  /// No description provided for @profile_section_rejected_title.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get profile_section_rejected_title;

  /// No description provided for @profile_section_rejected_default_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your last update request was rejected. You can re-submit.'**
  String get profile_section_rejected_default_subtitle;
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
