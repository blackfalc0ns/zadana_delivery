// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get name_is_required => 'Name is required!';

  @override
  String get name_is_not_valid => 'This name is not valid';

  @override
  String get email_is_required => 'Email is required!';

  @override
  String get email_is_not_valid => 'This email is not valid';

  @override
  String get password_is_required => 'Password is required!';

  @override
  String get password_is_not_valid => 'This password is not valid';

  @override
  String get password_must_be_at_least_6_characters =>
      'Password must be at least 6 characters';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get confirm_password_is_required => 'Confirm password is required!';

  @override
  String get confirm_password_is_not_valid =>
      'This confirm password is not valid';

  @override
  String get password_and_confirm_password_must_be_same =>
      'Password and confirm password must be same!';

  @override
  String get phone_number_is_required => 'Phone number is required!';

  @override
  String get phone_number_is_not_valid => 'This phone number is not valid';

  @override
  String get this_field_is_required => 'This field is required';

  @override
  String get error => 'Error';

  @override
  String get start_button => 'start now';

  @override
  String get location_service_disabled => 'Location service is disabled';

  @override
  String get location_service_disabled_message =>
      'Please enable location services and try again.';

  @override
  String get location_permission_denied => 'Location permission denied';

  @override
  String get location_permission_denied_message =>
      'Please allow location access to continue.';

  @override
  String get location_permission_denied_forever =>
      'Location permission permanently denied';

  @override
  String get location_permission_denied_forever_message =>
      'Location permission is permanently denied. Please enable it from your device settings.';

  @override
  String get error_no_internet_connection => 'No internet connection';

  @override
  String get error_no_internet_connection_desc =>
      'Please check your internet connection and try again.';

  @override
  String get error_connection_timeout_desc =>
      'The connection took too long. Please try again.';

  @override
  String get error_receive_timeout_desc =>
      'The server took too long to respond. Please try again.';

  @override
  String get error_send_timeout_desc =>
      'Failed to send data to the server. Please try again.';

  @override
  String get error_server_error => 'Server error';

  @override
  String get error_server_error_desc =>
      'A server error occurred. Please try again later.';

  @override
  String get error_internal_server_error => 'Internal server error';

  @override
  String get error_internal_server_error_desc =>
      'The server encountered an internal error. Please try again later.';

  @override
  String get error_bad_gateway => 'Bad gateway';

  @override
  String get error_bad_gateway_desc =>
      'The server received an invalid response. Please try again later.';

  @override
  String get error_service_unavailable => 'Service unavailable';

  @override
  String get error_service_unavailable_desc =>
      'The service is temporarily unavailable. Please try again later.';

  @override
  String get error_gateway_timeout => 'Gateway timeout';

  @override
  String get error_gateway_timeout_desc =>
      'The gateway timed out. Please try again later.';

  @override
  String get error_bad_request_desc =>
      'The request contains invalid data. Please check your input.';

  @override
  String get error_unauthorized_desc =>
      'You are not authorized to access this resource. Please sign in again.';

  @override
  String get error_forbidden_desc =>
      'You do not have permission to access this resource.';

  @override
  String get error_not_found_desc =>
      'The requested resource could not be found.';

  @override
  String get error_method_not_allowed => 'Method not allowed';

  @override
  String get error_method_not_allowed_desc =>
      'This method is not allowed for this resource.';

  @override
  String get error_not_acceptable => 'Not acceptable';

  @override
  String get error_not_acceptable_desc => 'The request is not acceptable.';

  @override
  String get error_request_timeout => 'Request timeout';

  @override
  String get error_request_timeout_desc =>
      'The request timed out. Please try again.';

  @override
  String get error_conflict_desc =>
      'There is a conflict with the current state of the resource.';

  @override
  String get error_gone => 'Resource unavailable';

  @override
  String get error_gone_desc =>
      'The requested resource is no longer available.';

  @override
  String get error_length_required => 'Length required';

  @override
  String get error_length_required_desc =>
      'The request must specify a content length.';

  @override
  String get error_precondition_failed => 'Precondition failed';

  @override
  String get error_precondition_failed_desc =>
      'One or more preconditions failed.';

  @override
  String get error_payload_too_large => 'Payload too large';

  @override
  String get error_payload_too_large_desc =>
      'The request payload is too large.';

  @override
  String get error_uri_too_long => 'URI too long';

  @override
  String get error_uri_too_long_desc => 'The request URI is too long.';

  @override
  String get error_unsupported_media_type => 'Unsupported media type';

  @override
  String get error_unsupported_media_type_desc =>
      'This media type is not supported.';

  @override
  String get error_range_not_satisfiable => 'Range not satisfiable';

  @override
  String get error_range_not_satisfiable_desc =>
      'The requested range cannot be satisfied.';

  @override
  String get error_expectation_failed => 'Expectation failed';

  @override
  String get error_expectation_failed_desc =>
      'The expectation in the request headers could not be met.';

  @override
  String get error_too_many_requests => 'Too many requests';

  @override
  String get error_too_many_requests_desc =>
      'You have sent too many requests. Please try again later.';

  @override
  String get error_unknown_desc =>
      'An unknown error occurred. Please try again.';

  @override
  String get error_cancelled => 'Request cancelled';

  @override
  String get error_cancelled_desc => 'The request was cancelled.';

  @override
  String get error_other => 'Something went wrong';

  @override
  String get error_other_desc => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get go_back => 'Go back';

  @override
  String get contact_support => 'Contact support';

  @override
  String get check_connection => 'Check connection';

  @override
  String get auth_title => 'Get Started Now';

  @override
  String get auth_subtitle_login => 'Welcome back! Log in to your account';

  @override
  String get auth_subtitle_signup => 'Create an account to explore our app';

  @override
  String get toggle_login => 'Log In';

  @override
  String get toggle_signup => 'Sign Up';

  @override
  String get label_full_name => 'Full Name';

  @override
  String get label_email => 'Email';

  @override
  String get label_phone => 'Phone';

  @override
  String get label_password => 'Password';

  @override
  String get hint_full_name => 'John Doe';

  @override
  String get hint_email => 'example@gmail.com ';

  @override
  String get hint_email_or_phone => 'example@email.com or 5xxxxxxxx';

  @override
  String get label_email_or_phone => 'Email or phone number';

  @override
  String get hint_phone => '(+966) 726-0592';

  @override
  String get hint_password => 'P@ssw0rd123';

  @override
  String get btn_login => 'Log In';

  @override
  String get btn_signup => 'Sign Up';

  @override
  String get btn_forgot_password => 'Forgot Password?';

  @override
  String get forget_password_title => 'Forgot Password';

  @override
  String get forget_password_description =>
      'Enter your phone number or email to receive a verification code';

  @override
  String get btn_send_verification_code => 'Send Verification Code';

  @override
  String get msg_verification_code_sent =>
      'Verification code sent successfully';

  @override
  String get reset_password_title => 'Reset Password';

  @override
  String get reset_password_description_prefix =>
      'Enter the verification code sent to';

  @override
  String get label_verification_code => 'Verification Code';

  @override
  String get hint_verification_code => 'Enter verification code';

  @override
  String get label_new_password => 'New Password';

  @override
  String get hint_new_password => 'Enter new password';

  @override
  String get btn_confirm => 'Confirm';

  @override
  String get msg_password_reset_success => 'Password changed successfully';

  @override
  String get verification_code_required => 'Please enter verification code';

  @override
  String get verification_code_invalid => 'Invalid verification code';

  @override
  String get otp_description => 'Enter the verification code sent to you';

  @override
  String get otp_code_sent_to => 'Code sent to';

  @override
  String get otp_verify_button => 'Verify';

  @override
  String get otp_complete_code_required =>
      'Please enter the complete verification code';

  @override
  String get otp_success_message => 'Account verified successfully';

  @override
  String get otp_screen_title => 'Verification Code';

  @override
  String get otp_screen_subtitle =>
      'Enter the verification code sent to you to confirm your account';

  @override
  String get social_divider => 'Or continue with';

  @override
  String get btn_login_google => 'Google';

  @override
  String get btn_login_apple => 'Apple';

  @override
  String get footer_have_account => 'Already have an account? ';

  @override
  String get footer_no_account => 'Don\'t have an account? ';

  @override
  String get footer_action_login => 'Log In';

  @override
  String get footer_action_signup => 'Sign Up';

  @override
  String get deliver_to => 'DELIVER TO';

  @override
  String get location => 'Downtown, New York';

  @override
  String get search_hint => 'Search for products, stores...';

  @override
  String get banner_tag => 'LIMITED OFFER';

  @override
  String get banner_title => 'Fresh Organic\nVegetables Up to 40% Off';

  @override
  String get banner_subtitle => 'Shop fresh, eat healthy every day';

  @override
  String get banner_action => 'Shop Now';

  @override
  String get section_special_offers => 'Special Offers';

  @override
  String get section_best_selling => 'Best Selling';

  @override
  String get section_featured => 'Featured Products';

  @override
  String get section_recommended => 'Recommended For You';

  @override
  String get section_explore => 'Explore More';

  @override
  String get see_all => 'See All';

  @override
  String get refresh => 'Refresh';

  @override
  String get add_to_cart => 'Add to Cart';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_categories => 'Categories';

  @override
  String get nav_cart => 'Cart';

  @override
  String get nav_orders => 'Orders';

  @override
  String get nav_profile => 'Profile';

  @override
  String get start_page_title => 'Order Everything You Need Easily';

  @override
  String get start_page_subtitle => 'Fast delivery for all your daily needs';

  @override
  String get start_page_button => 'Get Started Now';

  @override
  String get profile_title => 'Profile';

  @override
  String get edit_avatar => 'Edit Avatar';

  @override
  String get personal_info => 'Personal Information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get date_of_birth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get addresses => 'Addresses';

  @override
  String get add_address => 'Add New Address';

  @override
  String get change_address => 'Change';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get account => 'Account';

  @override
  String get change_password => 'Change Password';

  @override
  String get help_support => 'Help & Support';

  @override
  String get about_app => 'About App';

  @override
  String get developer => 'Developer';

  @override
  String get version => 'Version';

  @override
  String get contact_us => 'Contact Us';

  @override
  String get select_language => 'Select Language';

  @override
  String get arabic => 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©';

  @override
  String get english => 'English';

  @override
  String get about_app_title => 'About App';

  @override
  String get app_name => 'Zadana Smart Shopping App';

  @override
  String get version_label => 'Version';

  @override
  String get release_date => 'Release Date';

  @override
  String get app_description =>
      'A comprehensive e-commerce app that provides a distinctive and easy shopping experience.';

  @override
  String get ok => 'OK';

  @override
  String get login_success => 'Login successful';

  @override
  String get register_success =>
      'Account created successfully, please verify your email';

  @override
  String get legal => 'Legal';

  @override
  String get terms_conditions => 'Terms & Conditions';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get faq => 'FAQ';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirm => 'Are you sure you want to logout?';

  @override
  String get cart_title => 'My Cart';

  @override
  String cart_items_count(Object count) {
    return '$count items';
  }

  @override
  String get current_vendor => 'Current Vendor';

  @override
  String get change_vendor => 'Change Vendor';

  @override
  String get vendor_change_warning =>
      'Changing the vendor will affect all products in your cart. Do you want to continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get promo_code => 'Promo Code';

  @override
  String get apply => 'Apply';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Shipping';

  @override
  String get discount => 'Discount';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get cart_empty => 'Cart is Empty!';

  @override
  String get cart_empty_message =>
      'Start shopping and add products to your cart';

  @override
  String get shop_now => 'Shop Now';

  @override
  String get delete_item => 'Delete Item';

  @override
  String get delete_item_confirm =>
      'Do you want to remove this item from your cart?';

  @override
  String get available_vendors => 'Available Vendors';

  @override
  String get sar => 'SAR';

  @override
  String get free => 'Free';

  @override
  String get quantity => 'Quantity';

  @override
  String get error_connection_timeout => 'Connection timeout with server';

  @override
  String get error_send_timeout => 'Send timeout with server';

  @override
  String get error_receive_timeout => 'Receive timeout with server';

  @override
  String get error_bad_certificate => 'Invalid security certificate';

  @override
  String get error_request_cancelled => 'Request was cancelled';

  @override
  String get error_no_internet => 'No internet connection';

  @override
  String get error_unknown => 'Unexpected error occurred';

  @override
  String get error_no_response => 'No response received from server';

  @override
  String get error_bad_request => 'Bad request';

  @override
  String get error_unauthorized => 'Unauthorized, please sign in again';

  @override
  String get error_forbidden => 'You do not have permission';

  @override
  String get error_not_found => 'Resource not found';

  @override
  String get error_conflict => 'Data conflict occurred';

  @override
  String get error_validation => 'Invalid input data';

  @override
  String get error_server => 'Server error, please try again later';

  @override
  String get locationServicesDisabled => 'Location services are disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission permanently denied';

  @override
  String get unknownError => 'Something went wrong';

  @override
  String get product_details => 'Product Details';

  @override
  String get product_description => 'Product Description';

  @override
  String get product_description_text =>
      'This is a high-quality product with excellent features suitable for all uses.';

  @override
  String get quantity_label => 'Quantity:';

  @override
  String get add_to_cart_button => 'Add to Cart';

  @override
  String get added_to_favorites => 'Product added to favorites';

  @override
  String get removed_from_favorites => 'Product removed from favorites';

  @override
  String product_added_to_cart(Object quantity, Object name) {
    return 'Added $quantity of $name to cart';
  }

  @override
  String get buy_now => 'Buy Now';

  @override
  String get store_price_comparison => 'Store Price Comparison';

  @override
  String get fresh_products => 'Fresh Products';

  @override
  String get nutrition_info => 'Nutrition Info';

  @override
  String get high_fiber => 'High Fiber';

  @override
  String get high_protein => 'High Protein';

  @override
  String get natural_100 => '100% Natural';

  @override
  String get available => 'Available';

  @override
  String get not_available => 'Not Available';

  @override
  String get redirecting_to_checkout => 'Redirecting to checkout...';

  @override
  String get cart => 'Shopping Cart';

  @override
  String get product => 'product';

  @override
  String get clear_all => 'Clear All';

  @override
  String get delete_item_confirmation => 'Delete';

  @override
  String get delete => 'Delete';

  @override
  String get no => 'No';

  @override
  String get clear_cart => 'Clear Cart';

  @override
  String get clear_cart_confirmation =>
      'Are you sure you want to clear all items from cart?';

  @override
  String get start_shopping => 'Start Shopping';

  @override
  String get start_shopping_message =>
      'Start shopping and add products to cart';

  @override
  String get item => 'item';

  @override
  String get complete_from => 'Complete from';

  @override
  String get compare => 'Compare';

  @override
  String get select_vendor_to_show_price => 'Select vendor to show price';

  @override
  String get comparison_results => 'Comparison Results';

  @override
  String get save_amount => 'Save';

  @override
  String get if_buy_from => 'if you buy from';

  @override
  String get cheapest => 'Cheapest';

  @override
  String get more_expensive_by => 'More expensive by';

  @override
  String get currently_selected => 'Currently Selected';

  @override
  String get select_one_more_vendor => 'Select at least one more vendor';

  @override
  String get compare_prices => 'Compare Prices';

  @override
  String get select_cheapest => 'Select';

  @override
  String get select_vendors_to_compare => 'Select Vendors to Compare';

  @override
  String get select_2_to_3_vendors => 'Select 2 to 3 vendors to compare prices';

  @override
  String get category_vegetables => 'Vegetables';

  @override
  String get category_fruits => 'Fruits';

  @override
  String get category_meat => 'Meat';

  @override
  String get category_poultry => 'Poultry';

  @override
  String get category_dairy => 'Dairy';

  @override
  String get category_bakery => 'Bakery';

  @override
  String get category_beverages => 'Beverages';

  @override
  String get category_household => 'Household';

  @override
  String get category_personal_care => 'Personal Care';

  @override
  String get category_snacks => 'Snacks';

  @override
  String get sort_newest => 'Newest';

  @override
  String get sort_newest_desc => 'Recently added products';

  @override
  String get sort_price_low => 'Price Low to High';

  @override
  String get sort_price_low_desc => 'From cheapest to most expensive';

  @override
  String get sort_price_high => 'Price High to Low';

  @override
  String get sort_price_high_desc => 'From most expensive to cheapest';

  @override
  String get sort_best_selling => 'Best Selling';

  @override
  String get sort_best_selling_desc => 'Most purchased products';

  @override
  String get sort_highest_rated => 'Highest Rated';

  @override
  String get sort_highest_rated_desc => 'Based on customer ratings';

  @override
  String get sort_alphabetical => 'Alphabetical';

  @override
  String get sort_alphabetical_desc => 'From A to Z';

  @override
  String get filter_title => 'Filter Products';

  @override
  String get sort_title => 'Sort Products';

  @override
  String get search_hint_category => 'Search for vegetables, fruits, meat...';

  @override
  String get filter_button => 'Filter';

  @override
  String get sort_button => 'Sort';

  @override
  String get all_categories => 'All';

  @override
  String get select_product_type => 'Select Product Type';

  @override
  String get category => 'Category';

  @override
  String get price_range => 'Price Range';

  @override
  String get currency => 'SAR';

  @override
  String get filter_type => 'Type';

  @override
  String get filter_part => 'Part';

  @override
  String get filter_brand => 'Brand';

  @override
  String get filter_category_title => 'Category';

  @override
  String get filter_apply => 'Apply Filter';

  @override
  String get show_more => 'Show More';

  @override
  String get show_less => 'Show Less';

  @override
  String get favorites => 'Favorites';

  @override
  String get favorites_empty => 'No favorite products';

  @override
  String get favorites_empty_message =>
      'Start adding your favorite products for easy access';

  @override
  String get clear_favorites => 'Clear All Favorites';

  @override
  String get clear_favorites_confirmation =>
      'Are you sure you want to remove all products from favorites?';

  @override
  String get invoice_details => 'Invoice Details';

  @override
  String get processing => 'Processing...';

  @override
  String get order_success => 'Order Placed Successfully! ';

  @override
  String get order_number => 'Order Number';

  @override
  String get payment_successful => 'Payment Successful! ';

  @override
  String get payment_success_message =>
      'Thank you! Your order has been received and will be delivered soon';

  @override
  String get estimated_delivery => 'Estimated Delivery Time';

  @override
  String get minutes => 'minutes';

  @override
  String get track_order => 'Track Order ðŸ“';

  @override
  String get back_to_home => 'Back to Home';

  @override
  String get my_orders_title => 'My Orders';

  @override
  String get my_orders_subtitle =>
      'Track your current and previous orders easily';

  @override
  String get active_orders_tab => 'Active';

  @override
  String get completed_orders_tab => 'Completed';

  @override
  String get no_active_orders => 'No active orders';

  @override
  String get no_previous_orders => 'No previous orders';

  @override
  String get my_orders_order_date => 'Order Date';

  @override
  String get my_orders_items => 'Items';

  @override
  String get my_orders_view_details => 'View Details';

  @override
  String get my_orders_cancel_order => 'Cancel Order';

  @override
  String get my_orders_reorder => 'Reorder';

  @override
  String get my_orders_rate_order => 'Rate Order';

  @override
  String get order_pending => 'Pending';

  @override
  String get order_shipped => 'Shipped';

  @override
  String get order_delivered => 'Delivered';

  @override
  String get order_cancelled => 'Cancelled';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get credit_debit_card => 'Credit/Debit Card';

  @override
  String get credit_card_subtitle => 'Visa, Mastercard, Mada';

  @override
  String get apple_pay => 'Apple Pay';

  @override
  String get apple_pay_subtitle => 'Fast and secure payment';

  @override
  String get cash_on_delivery => 'Cash on Delivery';

  @override
  String get cash_on_delivery_subtitle => 'Pay cash when order arrives';

  @override
  String get bank_transfer => 'Bank Transfer';

  @override
  String get bank_transfer_subtitle => 'Direct transfer from bank';

  @override
  String get auth_driver_account_caption => 'Driver account';

  @override
  String get auth_login_description =>
      'Sign in to manage your trips and deliveries.';

  @override
  String get auth_login_error =>
      'Unable to sign in. Check your credentials and try again.';

  @override
  String get auth_forgot_password_pending =>
      'Forgot password will be connected in the next step.';

  @override
  String get auth_signup_caption => 'Create driver account';

  @override
  String get auth_signup_description =>
      'Enter your basic details to get started.';

  @override
  String get auth_continue => 'Continue';

  @override
  String get driver_profile_caption => 'Complete profile';

  @override
  String get driver_profile_title => 'Driver and vehicle details';

  @override
  String get driver_profile_subtitle =>
      'Add document photos and vehicle details to activate your account.';

  @override
  String get driver_profile_description =>
      'Upload the required images and fill in the basic information.';

  @override
  String get driver_profile_save => 'Save and continue';

  @override
  String get driver_profile_save_success =>
      'Initial profile data was saved successfully.';

  @override
  String get driver_profile_picker_restart_required =>
      'Image picking needs a full app restart after adding the plugin.';

  @override
  String get driver_profile_picker_error =>
      'Unable to open the image picker. Please try again.';

  @override
  String get driver_profile_identity_section => 'Identity images';

  @override
  String get driver_profile_vehicle_section => 'Vehicle details';

  @override
  String get driver_profile_vehicle_images_section => 'Vehicle images';

  @override
  String get driver_profile_vehicle_type => 'Vehicle type';

  @override
  String get driver_profile_vehicle_type_car => 'Car';

  @override
  String get driver_profile_vehicle_type_bike => 'Motorcycle';

  @override
  String get driver_profile_vehicle_type_scooter => 'Scooter';

  @override
  String get driver_profile_vehicle_type_van => 'Van';

  @override
  String get driver_profile_vehicle_type_bicycle => 'Bicycle';

  @override
  String get driver_profile_vehicle_type_truck => 'Truck';

  @override
  String get driver_profile_portrait_title => 'Driver portrait';

  @override
  String get driver_profile_portrait_subtitle =>
      'A clear personal photo of the driver.';

  @override
  String get driver_profile_id_front_title => 'ID front side';

  @override
  String get driver_profile_id_front_subtitle =>
      'Upload the front side of the ID.';

  @override
  String get driver_profile_id_back_title => 'ID back side';

  @override
  String get driver_profile_id_back_subtitle =>
      'Upload the back side of the ID.';

  @override
  String get driver_profile_license_title => 'Driver license';

  @override
  String get driver_profile_license_subtitle =>
      'Upload a clear image of the license.';

  @override
  String get driver_profile_vehicle_photo_title => 'Vehicle photo';

  @override
  String get driver_profile_vehicle_photo_subtitle =>
      'A full image of the delivery vehicle.';

  @override
  String get driver_profile_plate_photo_title => 'Plate image';

  @override
  String get driver_profile_plate_photo_subtitle =>
      'A clear image of the vehicle plate.';

  @override
  String get driver_profile_brand_label => 'Brand';

  @override
  String get driver_profile_brand_hint => 'Example: Toyota or Yamaha';

  @override
  String get driver_profile_model_label => 'Model';

  @override
  String get driver_profile_model_hint => 'Example: 2022 or NMAX';

  @override
  String get driver_profile_plate_label => 'Plate number';

  @override
  String get driver_profile_plate_hint => 'Enter plate number';

  @override
  String get auth_gate_ready_title => 'Ready to roll';

  @override
  String get auth_gate_ready_description =>
      'Preparing your driver session and routing you to the right next step.';

  @override
  String get auth_login_hero_badge => 'Ready to deliver';

  @override
  String get auth_login_hero_title => 'Driver sign in';

  @override
  String get auth_login_hero_subtitle =>
      'Access new delivery requests, manage your activity, and continue to the vehicle setup step.';

  @override
  String get auth_login_section_badge => 'Driver account';

  @override
  String get auth_signup_hero_badge => 'Join the driver team';

  @override
  String get auth_signup_hero_title => 'Create driver account';

  @override
  String get auth_signup_hero_subtitle =>
      'Start with your essential details, then move to sign in and continue to the vehicle profile step.';

  @override
  String get auth_signup_section_badge => 'New journey';

  @override
  String get auth_forgot_hero_badge => 'Quick recovery';

  @override
  String get auth_forgot_hero_subtitle =>
      'Enter the email or phone linked to the account and continue to the new password step.';

  @override
  String get auth_forgot_section_badge => 'Recover access';

  @override
  String get auth_reset_hero_badge => 'Account security';

  @override
  String get auth_reset_hero_subtitle =>
      'Enter the code and a new password, then return directly to sign in.';

  @override
  String get auth_reset_section_badge => 'New password';

  @override
  String get auth_confirm_password_label => 'Confirm password';

  @override
  String get auth_confirm_password_hint => 'Re-enter your password';

  @override
  String get auth_header_platform_caption => 'Delivery platform';

  @override
  String get driver_upload_status_done => 'Done';

  @override
  String get driver_upload_status_upload => 'Upload';

  @override
  String get driver_profile_step_identity_title => 'Identity';

  @override
  String get driver_profile_step_vehicle_title => 'Vehicle';

  @override
  String get driver_profile_step_uploads_title => 'Uploads';

  @override
  String get driver_profile_step_submit_title => 'Submit';

  @override
  String get driver_profile_step_identity_subtitle =>
      'Enter the driver official identity details.';

  @override
  String get driver_profile_step_vehicle_subtitle =>
      'Choose the vehicle and add its key details.';

  @override
  String get driver_profile_step_uploads_subtitle =>
      'Upload the required visuals and documents clearly.';

  @override
  String get driver_profile_step_submit_subtitle =>
      'Review everything and submit the final information.';

  @override
  String get driver_profile_page_subtitle =>
      'Complete the driver profile step by step with a clear guided flow.';

  @override
  String get driver_profile_step_back => 'Back';

  @override
  String get driver_profile_step_next => 'Next';

  @override
  String get driver_profile_submit_information => 'Submit information';

  @override
  String get driver_profile_images_required_error =>
      'Please upload all required images before continuing.';

  @override
  String get driver_profile_submit_success =>
      'Driver information submitted successfully.';

  @override
  String get driver_profile_identity_card_title =>
      'Personal and official details';

  @override
  String get driver_profile_identity_card_subtitle =>
      'Fill these details carefully because they anchor the rest of the profile.';

  @override
  String get driver_profile_address_label => 'Address';

  @override
  String get driver_profile_address_hint =>
      'Example: Nasr City, Abbas El Akkad Street';

  @override
  String get driver_profile_national_id_label => 'National ID';

  @override
  String get driver_profile_national_id_hint => 'Enter national ID';

  @override
  String get driver_profile_license_number_label => 'License number';

  @override
  String get driver_profile_license_number_hint => 'Enter license number';

  @override
  String get driver_profile_vehicle_card_title => 'Vehicle details';

  @override
  String get driver_profile_vehicle_card_subtitle =>
      'Choose the right vehicle for you, then complete its essential data.';

  @override
  String get driver_profile_zone_label => 'Working zone';

  @override
  String get driver_profile_zone_placeholder => 'Choose your main zone';

  @override
  String get driver_profile_zone_hint =>
      'Select the zone where you want to start receiving orders.';

  @override
  String get driver_profile_zone_loading => 'Loading available zones';

  @override
  String get driver_profile_zone_sheet_title => 'Choose your zone';

  @override
  String get driver_profile_zone_sheet_subtitle =>
      'This zone will be linked to your driver account during registration.';

  @override
  String get driver_profile_zone_required_error =>
      'Choose a working zone before continuing.';

  @override
  String get driver_profile_vehicle_required_error =>
      'Choose a vehicle type before continuing.';

  @override
  String driver_profile_zone_radius(String radius) {
    return 'Coverage $radius km';
  }

  @override
  String driver_profile_vehicle_selected_message(String vehicleType) {
    return '$vehicleType selected. Make sure the uploaded photo matches this vehicle type.';
  }

  @override
  String get driver_profile_vehicle_selected_bike_message =>
      'Bike selected. This setup emphasizes agility and faster movement in traffic.';

  @override
  String get driver_profile_vehicle_selected_car_message =>
      'Car selected. This setup is suitable for larger and more varied orders.';

  @override
  String get driver_profile_uploads_card_title => 'Images and attachments';

  @override
  String get driver_profile_uploads_card_subtitle =>
      'Each upload here makes the driver and vehicle data clearer.';

  @override
  String get driver_profile_review_card_title => 'Review and submit';

  @override
  String get driver_profile_review_card_subtitle =>
      'Review everything you entered before the final submission.';

  @override
  String get driver_profile_uploaded_images_label => 'Uploaded images';

  @override
  String get driver_profile_vehicle_type_label => 'Vehicle type';

  @override
  String get driver_profile_brand_review_label => 'Brand';

  @override
  String get driver_profile_model_review_label => 'Model';

  @override
  String get driver_profile_plate_review_label => 'Plate number';

  @override
  String get driver_profile_incomplete => 'Incomplete';

  @override
  String get driver_profile_steps_progress => 'Step progress';

  @override
  String get driver_vehicle_type_car_subtitle =>
      'Ideal for larger and multiple orders';

  @override
  String get driver_vehicle_type_bike_subtitle => 'Faster in dense city routes';

  @override
  String get driver_vehicle_type_motorcycle_subtitle =>
      'Balanced speed and carrying capacity for urban delivery';

  @override
  String get driver_vehicle_type_scooter_subtitle =>
      'Light and efficient for quick neighborhood routes';

  @override
  String get driver_vehicle_type_van_subtitle =>
      'Best for bulk loads and medium-sized shipments';

  @override
  String get driver_vehicle_type_bicycle_subtitle =>
      'Best for short eco-friendly trips in tight streets';

  @override
  String get driver_vehicle_type_truck_subtitle =>
      'Suitable for heavy loads and large deliveries';

  @override
  String get auth_section_badge_default => 'Member';

  @override
  String get auth_phone_hint_compact => '5xxxxxxxx';

  @override
  String get auth_pending_title => 'Your account is under review';

  @override
  String get auth_pending_description =>
      'Your details were received successfully. Our team will review and activate the account before you start receiving orders.';

  @override
  String get auth_pending_notification_hint =>
      'You will receive a new notification as soon as the account is approved, and you can track all alerts from the notifications button above.';

  @override
  String get auth_pending_eta_hint =>
      'Account review usually happens shortly after the submitted data is confirmed as complete.';

  @override
  String get auth_blocked_title => 'Account temporarily blocked';

  @override
  String get auth_blocked_description =>
      'Access to your account is currently suspended. If you believe this action was taken by mistake, contact support to review your case.';

  @override
  String get auth_blocked_access_hint =>
      'You will not be able to receive orders or use app features until the block is lifted or the account is reviewed by the admin team.';

  @override
  String get auth_blocked_support_hint =>
      'You can return to support and help to send an inquiry or follow up on the reason for the block and the account recovery steps.';

  @override
  String get auth_contact_support => 'Contact support';

  @override
  String get auth_logout_account => 'Log out of account';

  @override
  String get auth_session_parse_error =>
      'Unable to read session data from the sign-in response.';

  @override
  String get driver_home_accept => 'Accept';

  @override
  String get driver_home_reject => 'Reject';

  @override
  String get driver_home_pickup_label => 'Pickup';

  @override
  String get driver_home_delivery_label => 'Delivery';

  @override
  String get driver_home_distance_unit => 'km';

  @override
  String get driver_home_accept_order_dialog_title =>
      'Accept order confirmation';

  @override
  String driver_home_accept_order_dialog_message(
    Object orderTitle,
    Object vendorName,
  ) {
    return 'Do you want to accept $orderTitle from $vendorName and continue to the order details?';
  }

  @override
  String get driver_home_accept_order_dialog_confirm => 'Confirm acceptance';

  @override
  String get driver_home_connection_online_title => 'Online now';

  @override
  String get driver_home_connection_offline_title => 'Offline';

  @override
  String get driver_home_connection_online_subtitle => 'Ready for orders';

  @override
  String get driver_home_connection_offline_subtitle => 'Temporarily paused';

  @override
  String get driver_profile_mock_address => 'Nasr City, Cairo';

  @override
  String get driver_profile_mock_national_id => '29801011234567';

  @override
  String get driver_profile_mock_license_number => 'C-452188';

  @override
  String get driver_profile_mock_vehicle_brand => 'Yamaha';

  @override
  String get driver_profile_mock_vehicle_model => 'NMAX 2023';

  @override
  String get driver_profile_mock_plate_number => 'STR 2486';

  @override
  String get completed_orders_title => 'Completed Orders';

  @override
  String get completed_orders_subtitle =>
      'Review delivered, cancelled, and failed delivery orders in one organized history.';

  @override
  String get completed_orders_history_badge => 'History Archive';

  @override
  String get completed_orders_search_hint =>
      'Search by order id, merchant, customer, or address';

  @override
  String get completed_orders_filter_all => 'All';

  @override
  String get completed_orders_merchant_label => 'Merchant';

  @override
  String get completed_orders_customer_label => 'Customer';

  @override
  String get completed_orders_customer_name_label => 'Customer name';

  @override
  String get completed_orders_delivery_address_label => 'Delivery address';

  @override
  String get completed_orders_summary_orders => 'Orders';

  @override
  String get completed_orders_summary_distance => 'Distance km';

  @override
  String get completed_orders_distance_label => 'Distance';

  @override
  String get completed_orders_order_total_label => 'Order total';

  @override
  String get completed_orders_view_details_hint => 'Tap to view details';

  @override
  String get completed_orders_customer_section_title => 'Customer information';

  @override
  String get completed_orders_order_details_section_title => 'Order details';

  @override
  String get completed_orders_items_section_title => 'Items & quantities';

  @override
  String get completed_orders_date_label => 'Date';

  @override
  String get completed_orders_time_label => 'Time';

  @override
  String get completed_orders_order_number_prefix => 'Order';

  @override
  String get completed_orders_empty_title => 'No completed orders yet';

  @override
  String get completed_orders_empty_subtitle =>
      'Finished driver trips will appear here once an order is delivered, cancelled, or marked as failed.';

  @override
  String get completed_orders_no_results_title => 'No matching orders found';

  @override
  String get completed_orders_no_results_subtitle =>
      'Try another search term or clear the active status filter.';

  @override
  String get order_delivery_failed => 'Delivery Failed';

  @override
  String get completed_orders_card_title => 'Your Order';

  @override
  String get nav_wallet => 'Wallet';

  @override
  String get wallet_title => 'Wallet';

  @override
  String get wallet_subtitle =>
      'Track your live balance, payout readiness, incentives, and every movement in one premium dashboard.';

  @override
  String get wallet_preview_state => 'Preview state';

  @override
  String get wallet_state_success => 'Success';

  @override
  String get wallet_state_empty => 'Empty';

  @override
  String get wallet_state_error => 'Error';

  @override
  String get wallet_current_balance => 'Current balance';

  @override
  String get wallet_available_to_withdraw => 'Available to withdraw';

  @override
  String get wallet_pending_balance => 'Pending balance';

  @override
  String get wallet_withdraw_cta => 'Withdraw now';

  @override
  String get wallet_withdraw_success =>
      'Withdrawal request created successfully.';

  @override
  String get wallet_earnings_summary => 'Earnings summary';

  @override
  String get wallet_metric_today => 'Today';

  @override
  String get wallet_metric_week => 'This week';

  @override
  String get wallet_metric_month => 'This month';

  @override
  String get wallet_transaction_history => 'Transaction history';

  @override
  String get wallet_payment_methods => 'Payment methods';

  @override
  String get wallet_bonuses => 'Bonuses & incentives';

  @override
  String get wallet_alerts => 'Wallet alerts';

  @override
  String get wallet_primary_method => 'Primary';

  @override
  String get wallet_unverified_method => 'Needs verification';

  @override
  String get wallet_bonus_progress => 'completed';

  @override
  String get wallet_bonus_unlock_before => 'Unlock before';

  @override
  String get wallet_empty_title => 'Your wallet is ready for the first payout';

  @override
  String get wallet_empty_subtitle =>
      'Complete a few delivery trips and your earnings, history, and payout options will appear here.';

  @override
  String get wallet_error_title => 'Unable to load wallet right now';

  @override
  String get wallet_error_subtitle =>
      'We could not fetch the latest wallet snapshot. Try again in a moment.';

  @override
  String get wallet_retry => 'Try again';

  @override
  String get wallet_status_completed => 'Completed';

  @override
  String get wallet_status_pending => 'Pending';

  @override
  String get wallet_status_failed => 'Failed';

  @override
  String get wallet_transaction_delivery => 'Delivery earnings';

  @override
  String get wallet_transaction_withdrawal => 'Withdrawal request';

  @override
  String get wallet_transaction_bonus => 'Bonus payout';

  @override
  String get wallet_transaction_adjustment => 'Wallet adjustment';

  @override
  String get wallet_payment_bank_account => 'Bank account';

  @override
  String get wallet_payment_debit_card => 'Debit card';

  @override
  String get wallet_payment_instant_transfer => 'Instant transfer';

  @override
  String get wallet_bonus_weekend => 'Weekend challenge';

  @override
  String get wallet_bonus_consistency => 'Consistency streak';

  @override
  String get wallet_bonus_peak_hours => 'Peak hours boost';

  @override
  String get wallet_alert_verification_title => 'Verify your payout account';

  @override
  String get wallet_alert_verification_subtitle =>
      'A quick account verification keeps withdrawals smooth and secure.';

  @override
  String get wallet_alert_payout_title => 'Withdrawal is being processed';

  @override
  String get wallet_alert_payout_subtitle =>
      'Your latest payout request is queued and should arrive within the expected settlement window.';

  @override
  String get wallet_alert_incentive_title => 'New incentive unlocked';

  @override
  String get wallet_alert_incentive_subtitle =>
      'You are close to unlocking an extra driver reward during peak delivery hours.';

  @override
  String get wallet_alert_action_verify => 'Verify';

  @override
  String get wallet_alert_action_view => 'View';

  @override
  String get wallet_alert_action_claim => 'Claim';

  @override
  String get profile_edit_profile_title => 'Edit profile';

  @override
  String get profile_edit_profile_subtitle =>
      'Update your personal, vehicle, and attachment details';

  @override
  String get profile_language_subtitle => 'English';

  @override
  String get profile_notifications_subtitle =>
      'Open notifications and manage alert preferences';

  @override
  String get profile_change_password_subtitle =>
      'Open security settings to manage your password';

  @override
  String get profile_support_subtitle => 'Reach us or browse help resources';

  @override
  String get profile_privacy_subtitle =>
      'Learn about data collection, storage, and usage';

  @override
  String get profile_logout_subtitle => 'Sign out from this device securely';

  @override
  String get profile_logout_success => 'Logged out successfully';

  @override
  String get profile_language_info =>
      'Language settings are currently available in English';

  @override
  String get profile_default_name => 'User name';

  @override
  String get profile_default_email => 'example@zadana.com';

  @override
  String get profile_default_phone => '+20 100 000 0000';

  @override
  String get profile_security_documents_title => 'Security and documents';

  @override
  String profile_documents_uploaded_count(Object count) {
    return 'Uploaded documents: $count/5';
  }

  @override
  String get profile_current_documents => 'Current documents';

  @override
  String get profile_not_uploaded_yet => 'Not uploaded yet';

  @override
  String get profile_personal_info_saved =>
      'Personal information saved successfully';

  @override
  String get profile_vehicle_info_saved =>
      'Vehicle information saved successfully';

  @override
  String get profile_security_documents_saved =>
      'Security and documents saved successfully';

  @override
  String get order_details_title => 'Order details';

  @override
  String get order_details_distance_label => 'Distance';

  @override
  String get order_details_accept_order => 'Accept order';

  @override
  String get order_details_reject_order => 'Reject';

  @override
  String get order_details_show_pickup_code => 'Show pickup code from store';

  @override
  String get order_details_start_delivery => 'Start delivery to customer';

  @override
  String get order_details_confirm_delivery_with_code =>
      'Confirm delivery with customer code';

  @override
  String get order_details_order_delivered => 'Order delivered';

  @override
  String get order_details_customer_details_title => 'Customer details';

  @override
  String get order_details_customer_name_label => 'Customer name';

  @override
  String get order_details_customer_address_label => 'Customer address';

  @override
  String get order_details_pickup_details_title => 'Pickup details';

  @override
  String get order_details_store_label => 'Store';

  @override
  String get order_details_store_address_label => 'Store address';

  @override
  String get order_details_open_customer_location => 'Open customer location';

  @override
  String get order_details_open_customer_location_hint =>
      'Opens the customer\'s location in maps';

  @override
  String get order_details_open_store_location => 'Open store location';

  @override
  String get order_details_open_store_location_hint =>
      'Opens the store location in maps';

  @override
  String get order_details_customer_otp_hint =>
      'Enter the customer\'s delivery code';

  @override
  String get order_details_customer_otp_title => 'Confirm order delivery';

  @override
  String get order_details_customer_otp_subtitle =>
      'Take the delivery code from the customer and enter it here to complete delivery';

  @override
  String get order_details_confirm_delivery => 'Confirm delivery';

  @override
  String get order_details_pickup_code_title => 'Order pickup code';

  @override
  String get order_details_pickup_code_subtitle =>
      'Show this code to the store so the order can be handed to you';

  @override
  String get order_details_confirm_pickup => 'Confirm pickup from store';

  @override
  String get order_details_order_items_title => 'Order items';

  @override
  String get order_details_items_unit => 'items';

  @override
  String get order_details_pieces_unit => 'pieces';

  @override
  String get order_details_route_map_title => 'Route map';

  @override
  String get order_details_map_hint => 'Drag and zoom the map';

  @override
  String get order_details_items_details_title => 'Received order details';

  @override
  String get order_details_total_pieces_label => 'Total pieces';

  @override
  String get order_details_items_count_label => 'Items count';

  @override
  String get order_details_view_products => 'View products';

  @override
  String get order_details_status_accepted => 'Order accepted';

  @override
  String get order_details_status_picked_up => 'Picked up from store';

  @override
  String get order_details_status_on_the_way => 'On the way to customer';

  @override
  String get order_details_status_delivered => 'Delivered';

  @override
  String get order_details_sheet_hint =>
      'In the demo build, any 4 digits will work for confirmation';

  @override
  String get order_details_enter_otp_snackbar =>
      'Enter the code so we can confirm delivery';

  @override
  String get order_details_package_note_fallback =>
      'Review the item count and make sure the package is sealed before moving.';

  @override
  String get order_details_accept_dialog_title => 'Accept order confirmation';

  @override
  String order_details_accept_dialog_message(Object orderTitle) {
    return 'Do you want to accept $orderTitle and start working on the order now?';
  }

  @override
  String get order_details_accept_dialog_confirm => 'Confirm acceptance';

  @override
  String get order_details_pickup_dialog_title => 'Confirm pickup from store';

  @override
  String order_details_pickup_dialog_message(Object vendorName) {
    return 'Do you confirm picking up the order from $vendorName and that all items are ready with you?';
  }

  @override
  String get order_details_pickup_dialog_confirm => 'Confirm pickup';

  @override
  String get order_details_call_failure =>
      'Could not open the calling app on this device';

  @override
  String get order_details_maps_failure =>
      'Could not open the maps app on this device';
}
