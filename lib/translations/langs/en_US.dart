const Map<String, String> enUS = {
  'initializated_app': 'Loading...',

  //? /modules/login
  'login.title': 'Log in to your account',
  'login.subtitle': 'Enter your email address and password to log in.',

  'login.form.emailInput': 'Email address',
  'login.form.passwordInput': 'Password',
  'login.form.submit': 'Log in',

  'login.recovery': 'Forgot your password?',

  'login.sing_up.link1': 'Don\'t have an account?',
  'login.sing_up.link2': 'Sign up',

  'login.error.wrong_credentials_title': 'Incorrect password',
  'login.error.wrong_credentials_attempts': 'You have @remaining attempt(s) left before your account is locked.',
  'login.error.wrong_credentials_last_attempt': 'Your account has been locked. Contact support to unlock it.',
  'login.error.wrong_credentials_generic': 'The email or password is incorrect.',
  'login.error.account_locked_title': 'Account locked',
  'login.error.account_locked_description': 'Your account was locked due to multiple failed attempts. Contact support to unlock it.',

  //? /modules/recovery
  'recovery.recovery_view.title_part1': 'Reset',
  'recovery.recovery_view.title_part2': 'Password',
  'recovery.recovery_view.subtitle':
      'Enter your email address to reset your password',
  'recovery.recovery_view.form.email_input': 'Email address',
  'recovery.recovery_view.form.submit': 'Continue',

  'recovery.recovery_validation_view.title_part1': 'OTP',
  'recovery.recovery_validation_view.title_part2': 'Validation',
  'recovery.recovery_validation_view.subtitle':
      'We sent an OTP code to your email to validate this operation',
  'recovery.recovery_validation_view.form.submit': 'Continue',
  'recovery.recovery_validation_view.resend_code': 'Resend code ',

  'recovery.new_pass_view.title_part1': 'Change',
  'recovery.new_pass_view.title_part2': 'password',
  'recovery.new_pass_view.subtitle':
      'Your password is yours alone! Do not share it with anyone.',
  'recovery.new_pass_view.form.password_input': 'New password',

  'recovery.new_pass_view.form.password_repeat_input':
      'Repeat your new password',

  'recovery.new_pass_view.form.submit': 'Continue',

  //? /modules/recovery/controller
  'recovery.controller.error_title': 'Error',
  'recovery.controller.resend_wait_title': 'Wait a moment',
  'recovery.controller.resend_wait_description':
      'You must wait for the counter to reach zero to resend the code.',
  'recovery.controller.resend_success_message':
      'A new OTP code has been sent to your email',
  'recovery.controller.passwords_do_not_match':
      'Your password must match in both fields',
  'recovery.controller.password_recovered_success':
      'Password recovered successfully!',

  //? /modules/register
  'register.person_type.title': 'Person type',
  'register.person_type.subtitle': 'Select how you want to register on WiiGold.',
  'register.person_type.natural_title': 'Individual',
  'register.person_type.natural_description': 'Individual registration for natural persons.',
  'register.person_type.juridica_title': 'Legal Entity',
  'register.person_type.juridica_description': 'Registration for companies and organizations.',
  'register.person_type.continue_button': 'Continue',

  'register.register_view.title': 'Sign Up',
  'register.register_view.subtitle': 'Please enter your basic details',

  'register.register_view.form.emailInput': 'Email address',
  'register.register_view.form.passwordInput': 'Password',

  'register.register_view.form.submit_button': 'Continue',

  'register.terms_view.terms_checkbox':
      'I have read and accept the privacy policies and terms of service',
  'register.terms_view.accept_prefix': 'Accept ',
  'register.terms_view.accept_link': 'terms and conditions',
  'register.terms_view.privacy_prefix': 'Accept ',
  'register.terms_view.privacy_link': 'privacy policy',

  'register.register_view.login_link_part1': 'Already have an account?',
  'register.register_view.login_link_part2': 'Login',

  'register.verification_view.sent_link_message':
      'We have sent a verification link to\n',
  'register.verification_view.check_inbox_message':
      'Check your inbox (including the spam folder) and verify your email to gain access.',

  //? /modules/auth
  'auth.appbar.title': 'Verification',

  'auth.auth_view.title_part1': 'Identity \n',
  'auth.auth_view.title_part2_highlight': 'verification',

  'auth.auth_view.subtitle': 'Location',
  'auth.auth_view.form.country_input': 'Country',
  'auth.auth_view.form.region_input': 'State/Region',
  'auth.auth_view.form.address_input': 'Address',
  'auth.auth_view.form.zipcode_input': 'Postal Code',

  'auth.auth_view.terms_checkbox':
      'I have read and accept the privacy policies and terms of service',

  'auth.auth_view.terms_privacy_link': 'Privacy Policies',
  'auth.auth_view.terms_conditions_link': 'Terms and Conditions',

  'auth.auth_view.submit_button': 'Verify',

  'auth.kyc_view.placeholder.loading_text': 'Initializing camera...',

  'auth.kyc_view.snackbar.gallery_error_title': 'Error',
  'auth.kyc_view.snackbar.gallery_error_message': 'Could not retrieve image',

  'auth.support_view.title_part1': 'Contact\n',
  'auth.support_view.title_part2': 'support',

  'auth.support_view.subtitle':
      'It seems we\'re having trouble verifying your identity. Don\'t worry! Let us help you resolve this issue.',

  'auth.support_view.contact_button': 'Contact support',
  'auth.support_view.retry_button': 'Retry',

  'auth.successfull_view.validated_message': 'Identity successfully validated!',

  'auth.successfull_view.title_part1': 'Verification\n',
  'auth.successfull_view.title_part2_highlight': 'Selfie',

  'auth.successfull_view.instructions':
      'Please take a photo of yourself in a well-lit place, without accessories on your face. This will help us confirm it\'s really you.',

  'auth.successfull_view.continue_button': 'Continue',

  'auth.photos_controller.snackbar.camera_error_title': 'Camera Error',
  'auth.photos_controller.snackbar.camera_error_message':
      'Could not initialize camera',

  'auth.photos_controller.error.no_image_selected': 'No image selected',
  'auth.photos_controller.error.base64_parse': 'Error processing image',
  'auth.photos_controller.subtitle.preview': 'Review the photo taken',

  'auth.photos_controller.subtitle.selfie': 'Take a selfie of your face (2/2)',
  'auth.photos_controller.subtitle.document_base':
      'Take a @position photo of your ID (1/2)',

  'auth.photos_controller.subtitle.document_position_front': 'front photo',
  'auth.photos_controller.subtitle.document_position_back': 'back photo',

  'auth.auth_controller.form.success_title': "Successful verification",
  'auth.auth_controller.form.success_message':
      "Check your verification status in Profile/ KYC Status",

  //? /modules/profile
  'profile.data_view.title': 'My data',
  'profile.data_view.full_name_label': 'Full name',
  'profile.data_view.document_number_label': 'Document number',
  'profile.data_view.email_label': 'Email address',
  'profile.data_view.phone_number_label': 'Phone number',
  'profile.data_view.birth_date_label': 'Date of Birth',
  'profile.data_view.birth_date_hint': 'Select a date',
  'profile.data_view.address_label': 'Address',
  'profile.data_view.country_label': 'Country',
  'profile.data_view.country_hint': 'Select your country...',
  'profile.data_view.region_label': 'State/Region',
  'profile.data_view.postal_code_label': 'Postal Code',
  'profile.data_view.password_prompt':
      'Enter your password to validate this action',
  'profile.data_view.validate_button': 'Validate',
  'profile.data_view.cancel_button': 'Cancel',

  'profile.kyc_view.title': 'KYC Status',
  'profile.kyc_view.subtitle':
      'Your security comes first. KYC helps us protect your identity and your funds.',
  'profile.kyc_view.status_label': 'Status: ',
  'profile.kyc_view.verify_button': 'Verify',

  'profile.view.title': 'My profile',
  'profile.view.my_data_button': 'My Data',
  'profile.view.kyc_status_button': 'KYC Status',
  'profile.view.privacy_policy_button': 'Privacy Policy',
  'profile.view.terms_and_conditions_button': 'Terms and conditions',
  'profile.view.about_button': 'About WiiGold',
  'profile.view.security_button': 'Security (2FA)',
  'profile.view.settings_button': 'Settings',
  'profile.view.logout_button': 'Log out',

  //? /modules/profile/controller
  'profile.controller.load_profile_error': 'Error loading user profile',
  'profile.controller.status_not_started': 'Not started',
  'profile.controller.status_started': 'Started',
  'profile.controller.status_in_process': 'In process',
  'profile.controller.status_approved': 'Approved',
  'profile.controller.status_manual_review': 'Manual review',
  'profile.controller.status_rejected': 'Rejected',
  'profile.controller.status_resubmission_required': 'Resubmission required',
  'profile.controller.status_pending_identity_verification':
      'Pending identity verification',
  'profile.controller.status_pending_watchlist_verification':
      'Pending watchlist verification',
  'profile.controller.status_unknown': 'Unknown status',
  'profile.controller.error_title': 'Error',
  'profile.controller.update_data_error': 'Error updating data',
  'profile.controller.confirm_dialog_title': 'Confirm',
  'profile.controller.confirm_dialog_password_message':
      'This action requires password validation',
  'profile.controller.change_email_error': 'Error changing email',

  //? /modules/settings
  'settings.settings_view.title': 'Settings',
  'settings.settings_view.notifications_toggle_label': 'Allow notifications',

  'settings.language_selector.title': 'Language',

  //? /modules/home
  'home.balance_card.view_card_button': 'View card',
  'home.balance_card.copy_button': 'Copy',
  'home.balance_card.my_address_label': 'My address',
  'home.home_controller.snackbar_copied': 'Copied to clipboard',
  'home.home_controller.snackbar_copy_error': 'Error copying',
  'home.home_controller.username_placeholder': 'Waiting...',
  'home.home_controller.verification_error': 'Error in identity verification',
  'home.home_controller.verification_incomplete':
      'Incomplete identity verification',
  'home.home_controller.verification_success':
      'Identity verification successful',
  'home.home_view.welcome_message': 'Welcome \n',
  'home.tab_tokens.no_tokens_found': 'No tokens found',
  'home.tab_transactions.data_error': 'Data error',
  'home.tab_transactions.no_transactions_found': 'No transactions found',
  'home.tab_transactions.operation_exchange': 'Exchange',
  'home.tab_transactions.operation_sell': 'Sell',
  'home.tab_transactions.operation_buy': 'Buy',
  'home.tab_transactions.status_completed': 'Completed',
  'home.tab_transactions.status_failed': 'Failed',
  'home.tab_transactions.status_pending': 'Pending',
  'home.tab_transactions.status_under_review': 'Under Review',
  'home.tab_transactions.status_unknown': 'Unknown',
  'home.tab_transactions.unknown_recipient': 'Unknown recipient',
  'home.transactions_tab_controller.tab_tokens': 'Portfolio',
  'home.transactions_tab_controller.tab_transactions': 'Transactions',
  'home.verification_alert.continue_button': 'Continue',
  'home.verification_alert.welcome_title': 'Welcome to WiiGold',
  'home.verification_alert.welcome_subtitle':
      'Before starting, you must complete the identity verification process (KYC)',

  //? /module/send
  'send.view.appbar_title': 'Send',

  'send.selector_view.title_part1': 'Select the\n',
  'send.selector_view.title_part2': 'token',
  'send.selector_view.unknown_token': 'Unknown Token',

  'send.view.title_part1': 'Enter the \namount to ',
  'send.view.title_part2': 'send',
  'send.view.amount_hint': '0.00',
  'send.view.available_balance': 'Available balance: ',
  'send.view.commission_message':
      'The commission for this transaction is @commission @tokenName',
  'send.view.continue_button': 'Continue',

  'send.insert_target_view.title_part1': 'Enter \naddress or\n',
  'send.insert_target_view.title_part2': 'email',
  'send.insert_target_view.target_label': 'Target',
  'send.insert_target_view.paste_button': 'Paste',
  'send.insert_target_view.return_button': 'Return',
  'send.insert_target_view.scan_qr_button': 'Scan QR',
  'send.insert_target_view.continue_button': 'Continue',

  'send.confirm_view.title': 'You are going\nto send ',
  'send.confirm_view.to_wallet': 'To the wallet of:\n',
  'send.confirm_view.transaction_fee': 'Transaction fee\n',
  'send.confirm_view.enter_pin_message':
      'Enter your pin to confirm the payment',
  'send.confirm_view.continue_button': 'Continue',
  'send.confirm_view.modify_button': 'Modify',

  'send.controller.amount_not_available': 'Amount not available',
  'send.controller.token_not_available': 'Token not available',

  'send.controller.enter_or_scan_address': 'Please enter or scan an address',
  'send.controller.enter_valid_address': 'Please enter or scan a valid address',
  'send.controller.incorrect_password': 'Incorrect password',
  'send.controller.unexpected_error_title': 'Unexpected Error',
  'send.controller.transaction_processing_error':
      'An error occurred while processing the transaction: @error',

  //? /modules/request
  'request.view.appbar_title': 'Request',

  'request.selector_view.title_part1': 'Select the\n',
  'request.selector_view.title_part2': 'token',
  'request.selector_view.unknown_token': 'Unknown Token',

  'request.view.title_part1': 'Enter the \namount to ',
  'request.view.title_part2': 'request',
  'request.view.amount_hint': '0.00',
  'request.view.continue_button': 'Continue',

  'request.share_view.title_part1': 'Choose\n',
  'request.share_view.title_part2': 'how to\n',
  'request.share_view.title_part3': 'request your:',
  'request.share_view.generate_qr_button': 'Generate QR code',
  'request.share_view.copy_link_button': 'Copy payment link',
  'request.share_view.share_link_button': 'Share payment link',
  'request.share_view.qr_title': 'Payment \ncode',
  'request.share_view.qr_instruction_part1': 'Ask them to scan \n',
  'request.share_view.qr_instruction_part2': 'this QR code to \n',
  'request.share_view.qr_instruction_part3': 'collect your:',
  'request.share_view.return_button': 'Return',
  'request.share_view.back_to_home_button': 'Back to home',

  'request.controller.error_generating_link': 'Error generating payment link',
  'request.controller.link_copied': 'Payment link copied to clipboard',
  'request.controller.error_copying_link': 'Error copying payment link',
  'request.controller.share_link_text':
      'Here is the payment link for @amount @tokenName: @link',
  'request.controller.share_link_subject': 'Payment link - @amount @tokenName',

  //? /modules/exchange
  'exchange.view.appbar_title': 'Exchange',

  'exchange.view.value_in_usd': 'Value @value USD',
  'exchange.view.commission': 'Commission @commission @tokenName',
  'exchange.view.rate': 'Rate @rate',
  'exchange.view.title_part1': 'I want to ',
  'exchange.view.title_part2': 'exchange ',
  'exchange.view.title_part3': 'my:',
  'exchange.view.available_balance': 'Available balance: ',
  'exchange.view.for_label': 'For:',
  'exchange.view.continue_button': 'Continue',

  'exchange.confirm_view.title': 'Confirm',
  'exchange.confirm_view.from_label': 'You are going to exchange your:',
  'exchange.confirm_view.to_label': 'For:',
  'exchange.confirm_view.continue_button': 'Continue',
  'exchange.confirm_view.return_button': 'Return',

  //? /modules/token

  //? /modules/token/sell
  'sell.selector_view.title_part1': 'Select the\n',
  'sell.selector_view.title_part2': 'token',
  'sell.selector_view.unknown_token': 'Unknown Token',

  'sell.sell_view.title_part1': 'Sell \n',
  'sell.sell_view.title_part2_highlight': 'Crypto',
  'sell.sell_view.progress_label': '1/2',
  'sell.sell_view.form.sell_label': 'You are selling:',
  'sell.sell_view.form.available_balance_label': 'Available balance: ',
  'sell.sell_view.form.receive_label': 'You receive:',
  'sell.sell_view.form.submit_button': 'Continue',

  'sell.sell_data_view.title': 'Consignment data',
  'sell.sell_data_view.progress_label': '2/2',
  'sell.sell_data_view.form.account_holder_name_label':
      'Account holder\'s name',
  'sell.sell_data_view.form.document_type_label': 'Document type',
  'sell.sell_data_view.form.document_type_dni': 'ID Card',
  'sell.sell_data_view.form.document_type_passport': 'Passport',
  'sell.sell_data_view.form.document_type_drivers_license': 'Driver\'s License',
  'sell.sell_data_view.form.document_number_label': 'Document number',
  'sell.sell_data_view.form.bank_account_number_label': 'Bank account number',
  'sell.sell_data_view.form.bank_name_label': 'Bank',
  'sell.sell_data_view.form.swift_code_label': 'SWIFT Code',
  'sell.sell_data_view.form.submit_button': 'Continue',
  'sell.sell_data_view.form.back_button': 'Go back',

  'sell.confirm_sell_view.title': 'Confirm',
  'sell.confirm_sell_view.sell_label': 'You are selling:',
  'sell.confirm_sell_view.receive_label': 'You receive:',
  'sell.confirm_sell_view.submit_button': 'Continue',
  'sell.confirm_sell_view.back_button': 'Go back',

  'sell.sell_info.rate_label': 'Rate @rate USD',
  'sell.sell_info.commission_label': 'Commission @commission @tokenName',

  'sell.appbar.title': 'Sell',

  //? /modules/token/buy
  'buy.selector_view.title_part1': 'Select the\n',
  'buy.selector_view.title_part2': 'token',
  'buy.selector_view.unknown_token': 'Unknown Token',

  'buy.buy_controller.snackbar_min_amount_title':
      'Minimum purchase amount (10 USD) not reached',
  'buy.buy_controller.snackbar_insufficient_tokens_title':
      'Not enough tokens in treasury',
  'buy.buy_controller.snackbar_unexpected_error_title': 'Unexpected Error',
  'buy.buy_controller.snackbar_unexpected_error_message':
      'An error occurred while processing the transaction.',
  'buy.buy_data_view.title_part1': 'Payment \n',
  'buy.buy_data_view.title_part2_highlight': 'details',
  'buy.buy_data_view.progress_label': '3/3',
  'buy.buy_data_view.form.payment_data_title': 'Payment \ndata \nof WiiGold \n',
  'buy.buy_data_view.form.amount_to_pay_label': 'Amount to pay: \n',
  'buy.buy_data_view.form.payment_proof_label': 'Proof of payment',
  'buy.buy_data_view.form.payment_reference_label': 'Payment reference',
  'buy.buy_data_view.form.submit_button': 'Continue',
  'buy.buy_data_view.form.back_button': 'Go back',

  'buy.buy_view.title_part1': 'I want to ',
  'buy.buy_view.title_part2_highlight': 'buy',
  'buy.buy_view.progress_label': 'Amount and payment method',
  'buy.buy_view.form.payment_methods_label': 'Available payment methods',
  'buy.buy_view.form.available_methods_title': 'Available Methods',
  'buy.buy_view.form.for_label': 'For:',
  'buy.buy_view.form.you_will_pay_label': 'You will pay:',
  'buy.buy_view.form.submit_button': 'Continue',

  'buy.confirm_buy_view.title_part1': 'Confirm \n',
  'buy.confirm_buy_view.title_part2_highlight': 'Purchase',
  'buy.confirm_buy_view.progress_label': '2/3',
  'buy.confirm_buy_view.pay_label': 'You will pay:',
  'buy.confirm_buy_view.for_label': 'For:',
  'buy.confirm_buy_view.submit_button': 'Continue',
  'buy.confirm_buy_view.back_button': 'Go back',

  'buy.appbar.title': 'Buy',

  'buy.buy_info.rate_label': 'Rate @rate USD',
  'buy.buy_info.commission_label': 'Commission @commission @tokenName',

  //? /modules/loan
  'loan.view.no_active_loans_title': 'No active loans',
  'loan.view.no_active_loans_description':
      'You will see your loans here when you have an active one.',
  'loan.view.request_loan_button': 'Request loan',
  'loan.view.new_loan_button': 'New loan',
  'loan.view.active_loans_title': 'Active loans',
  'loan.view.loan_card_title': 'Loan #@reference',
  'loan.view.requested_amount_label': 'Requested amount:',
  'loan.view.due_date_label': 'Due date:',
  'loan.view.locked_collateral_label': 'Locked collateral:',
  'loan.view.payment_progress_label': 'Payment progress',
  'loan.view.remaining_balance_label': 'Remaining balance:',

  'loan.balance_card.your_balance': 'Your balance',
  'loan.balance_card.grams_abbreviation': 'g',
  'loan.balance_card.gold_equivalent': 'Mineral equivalent',
  'loan.balance_card.dollar_equivalent': 'Dollar equivalent',

  'loan.request_view.title_part1': 'Request \n',
  'loan.request_view.title_part2': 'loan',
  'loan.request_view.security_notice':
      'For your security and ours, deposits will only be made to bank accounts whose holder exactly matches the name registered in our system.',
  'loan.request_view.enter_amount_label': 'Enter the amount to request',
  'loan.request_view.request_limit_label':
      'With your current balance,\nyou can request up to:',
  'loan.request_view.deposit_time_notice':
      'The requested amount will be deposited into your account one day after completing your application.',
  'loan.request_view.collateral_required_label': 'Requires freezing: ',

  'loan.request_view.accept_terms.prefix': 'Accept ',
  'loan.request_view.accept_terms.link': 'terms and conditions',

  'loan.request_view.continue_button': 'Continue',

  'loan.data_view.title_part1': 'Deposit details of the ',
  'loan.data_view.title_part2_highlight': 'loan',
  'loan.data_view.security_notice':
      'Deposits will only be made to bank accounts whose holder exactly matches the name registered in our system.',
  'loan.data_view.account_holder_name_label': 'Account holder name',
  'loan.data_view.account_number_label': 'Bank account number',
  'loan.data_view.bank_name_label': 'Bank',
  'loan.data_view.swift_code_label': 'SWIFT Code',
  'loan.data_view.interest_term_label': 'Interest Term',
  'loan.data_view.term_option_label': '@days days / @rate% APY',
  'loan.data_view.select_term_hint': 'Select a term...',
  'loan.data_view.continue_button': 'Continue',
  'loan.data_view.modify_button': 'Modify',

  'loan.loan_payment_info.pay_button': 'I have already paid.',

  'loan.finish_view.title_part1_highlight': 'Thank you! ',
  'loan.finish_view.title_part2':
      'Your request has been processed successfully.',
  'loan.finish_view.subtitle':
      'The deposit will be made the next business day to the account you selected. You will receive an email with the transaction details.',
  'loan.finish_view.back_button': 'Go back',

  'loan.detail_view.loan_amount_label': 'Loan amount',
  'loan.detail_view.interest_rate_label': 'Interest rate',
  'loan.detail_view.accrued_interest_label': 'Accrued interest',
  'loan.detail_view.total_paid_label': 'Total paid',
  'loan.detail_view.current_debt_label': 'Current debt',
  'loan.detail_view.due_date_label': 'Due date',
  'loan.detail_view.collateral_label': 'Collateral',
  'loan.detail_view.title_part1': 'Loan in progress \n',
  'loan.detail_view.make_payment_button': 'Make payment',
  'loan.detail_view.back_button': 'Go back',

  'loan.payment_view.amount_form.title_part1': 'Payment ',
  'loan.payment_view.amount_form.title_part2_highlight': 'amount',
  'loan.payment_view.amount_form.amount_hint': '0.00',
  'loan.payment_view.amount_form.max_button': 'Max',
  'loan.payment_view.amount_form.remaining_debt_label': 'Remaining debt: ',
  'loan.payment_view.amount_form.continue_button': 'Continue',
  'loan.payment_view.amount_form.back_button': 'Return',

  'loan.payment_view.method_form.title_part1': 'Proof of ',
  'loan.payment_view.method_form.title_part2_highlight': 'payment',
  'loan.payment_view.method_form.payment_methods_label':
      'Available payment methods',
  'loan.payment_view.method_form.available_methods_title': 'Available Methods',
  'loan.payment_view.method_form.payment_proof_label': 'Proof of payment',
  'loan.payment_view.method_form.payment_reference_label': 'Payment reference',
  'loan.payment_view.method_form.payment_date_label': 'Payment date',
  'loan.payment_view.method_form.email_label': 'Email address',
  'loan.payment_view.method_form.pay_button': 'Pay',
  'loan.payment_view.method_form.back_button': 'Return',

  'loan.data_controller.invalid_swift_code': 'Invalid Swift code',
  'loan.data_controller.biometric_reason':
      'Confirm your identity to request the loan.',
  'loan.data_controller.biometric_cancelled_title': 'Cancelled',
  'loan.data_controller.biometric_cancelled_description':
      'The loan request has been cancelled.',

  'loan.request_controller.unexpected_error': 'An unexpected error occurred.',
  'loan.request_controller.invalid_server_response':
      'The server response is not valid.',
  'loan.request_controller.load_info_error':
      'Could not load the information. Please try again.',
  'loan.request_controller.insufficient_funds': 'Insufficient funds',

  'loan.payment_controller.biometric_reason':
      'Confirm your identity to register your payment.',
  'loan.payment_controller.biometric_cancelled_title': 'Cancelled',
  'loan.payment_controller.biometric_cancelled_description':
      'The payment registration has been cancelled.',
  'loan.payment_controller.payment_successful':
      'Payment registered successfully',

  'loan.payment_list.no_payments_found': 'No payments found',
  'loan.payment_list.payments_made_title': 'Payments made',
  'loan.payment_list.amount_in_usd': '@amount USD',

  'loan.appbar_title.title': 'Loan',

  //? /modules/redeem
  'redeem.appbar_title.title': 'Redeem',

  'redeem.balance_card.your_balance': 'Your balance',
  'redeem.balance_card.grams_abbreviation': 'g',
  'redeem.balance_card.gold_equivalent': 'Mineral equivalent',
  'redeem.balance_card.dollar_equivalent': 'Dollar equivalent',

  'redeem.view.no_active_requests_title': 'No active requests',
  'redeem.view.no_active_requests_description':
      'You will see your requests here when you have an active one.',
  'redeem.view.request_physical_gold_button': 'Request physical mineral',
  'redeem.view.new_request_button': 'New request',
  'redeem.view.active_requests_title': 'Active requests',
  'redeem.view.date_completed': 'Completed on:',
  'redeem.view.date_shipped': 'Shipped on:',
  'redeem.view.date_accepted': 'Accepted on:',
  'redeem.view.date_quoted': 'Quoted on:',
  'redeem.view.date_requested': 'Requested on:',
  'redeem.view.request_card_title': 'Request #@reference',
  'redeem.view.asset_requested_label': 'Asset requested:',
  'redeem.view.shipping_address_label': 'Shipping address:',
  'redeem.view.shipping_cost_label': 'Shipping cost:',
  'redeem.view.tracking_number_label': 'Tracking number:',
  'redeem.view.carrier_label': 'Carrier:',

  'redeem.states.pendingQuote': 'Pending quote',
  'redeem.states.quoted': 'Quoted',
  'redeem.states.accepted': 'Accepted',
  'redeem.states.paymentPending': 'Payment received',
  'redeem.states.paymentVerified': 'Payment verified',
  'redeem.states.processing': 'Processing',
  'redeem.states.shipped': 'Shipped',
  'redeem.states.delivered': 'Delivered',
  'redeem.states.completed': 'Completed',
  'redeem.states.cancelled': 'Cancelled',
  'redeem.states.rejected': 'Rejected',
  'redeem.states.default': 'Unknown',

  'redeem.selector_view.title_part1': 'Select the\n',
  'redeem.selector_view.title_part2': 'token',
  'redeem.selector_view.unknown_token': 'Unknown Token',

  'redeem.request_view.title_part1': 'Receive ',
  'redeem.request_view.title_part2_highlight': 'physical \n',
  'redeem.request_view.title_part3_highlight': 'mineral',
  'redeem.request_view.subtitle':
      'Turn your investment into a tangible asset with just a few clicks.',
  'redeem.request_view.enter_amount_label': 'Enter the amount to request',
  'redeem.request_view.request_limit_label':
      'With your current balance,\nyou can request up to:',
  'redeem.request_view.grams_abbreviation': 'g',
  'redeem.request_view.reminder_note':
      'Remember that one Token is equivalent to one gram of mineral.',
  'redeem.request_view.commission_label': 'Commission: ',
  'redeem.request_view.accept_terms_checkbox': 'Accept terms and conditions',
  'redeem.request_view.continue_button': 'Continue',

  'redeem.data_view.title_part1': 'Shipping details for the ',
  'redeem.data_view.title_part2_highlight': 'mineral',
  'redeem.data_view.grams_abbreviation': 'g',
  'redeem.data_view.full_name_label': 'Full name',
  'redeem.data_view.country_label': 'Country',
  'redeem.data_view.country_hint': 'Select your country...',
  'redeem.data_view.region_label': 'State/Region',
  'redeem.data_view.address_label': 'Address',
  'redeem.data_view.postal_code_label': 'Postal Code',
  'redeem.data_view.phone_number_label': 'Phone number',
  'redeem.data_view.continue_button': 'Continue',
  'redeem.data_view.modify_button': 'Modify',

  'redeem.finish_view.title_part1_highlight': 'Thank you! ',
  'redeem.finish_view.title_part2':
      'Your request has been processed successfully.',
  'redeem.finish_view.subtitle':
      'You will soon receive an email with the shipping cost quote and the next steps to complete your redemption.',
  'redeem.finish_view.back_button': 'Go back',

  'redeem.controller.load_data_error':
      'An error occurred while loading the data.',
  'redeem.controller.unexpected_response': 'Unexpected server response.',
  'redeem.controller.amount_not_available_title': 'Amount not available',
  'redeem.controller.amount_not_available_description':
      'You do not have enough balance of this asset to redeem.',

  'redeem.detail_controller.step_pending_quote': 'Pending Quote',
  'redeem.detail_controller.step_payment_pending': 'Payment Pending',
  'redeem.detail_controller.step_payment_verified': 'Payment Verified',
  'redeem.detail_controller.step_shipped': 'Shipped',
  'redeem.detail_controller.warning_dialog_title': 'Warning',
  'redeem.detail_controller.cancel_dialog_message':
      'Do you want to cancel this withdrawal request?',
  'redeem.detail_controller.confirm_button': 'Confirm',
  'redeem.detail_controller.cancel_button': 'Cancel',
  'redeem.detail_controller.error_title': 'Error',
  'redeem.detail_controller.tracking_error_title': 'Tracking Error',
  'redeem.detail_controller.tracking_error_description':
      'Could not get the shipping details.',
  'redeem.detail_controller.quote_error_title': 'Quotation Error',
  'redeem.detail_controller.quote_error_description':
      'Could not get the exchange rate for @tokenName.',
  'redeem.detail_controller.the_token': 'the token',
  'redeem.detail_controller.insufficient_balance_title': 'Insufficient Balance',
  'redeem.detail_controller.insufficient_balance_description':
      'Your balance of @tokenName is not sufficient.',
  'redeem.detail_controller.step_content_pending_quote':
      'We have received your request and are generating the quote.',
  'redeem.detail_controller.step_content_payment_pending_action':
      'Your quote has been processed. The total amount to pay is @amount @currency. Please make the payment to continue.',
  'redeem.detail_controller.step_content_payment_pending_verification':
      'We received your proof of payment. Our team is verifying it.',
  'redeem.detail_controller.step_content_payment_form_total':
      'Total to pay: @amount @currency.\nUpload your proof and payment reference.',
  'redeem.detail_controller.pay_with_tokens_checkbox': 'Pay with tokens',
  'redeem.detail_controller.payment_token_label': 'Payment token',
  'redeem.detail_controller.confirm_payment_button': 'Confirm payment',
  'redeem.detail_controller.available_payment_methods_label':
      'Available payment methods',
  'redeem.detail_controller.available_methods_title': 'Available Methods',
  'redeem.detail_controller.payment_proof_label': 'Proof of payment',
  'redeem.detail_controller.payment_reference_label': 'Payment reference',
  'redeem.detail_controller.send_proof_button': 'Send Proof',
  'redeem.detail_controller.accept_button': 'Accept',
  'redeem.detail_controller.step_content_payment_verified':
      'Payment verified! We are preparing your order for shipment.',

  'redeem.payment_controller.biometric_reason':
      'Confirm your identity to register your payment.',
  'redeem.payment_controller.biometric_cancelled_title': 'Cancelled',
  'redeem.payment_controller.biometric_cancelled_description':
      'The payment registration has been cancelled.',
  'redeem.payment_controller.payment_successful':
      'Payment registered successfully',

  'redeem.request_controller.insufficient_balance_error':
      'Insufficient balance',
  'redeem.request_controller.unknown_error': 'Unknown error',
  'redeem.request_controller.insufficient_funds_error': 'Insufficient funds',

  'redeem.detail_view.title': 'Request Details \n',
  'redeem.detail_view.loading': 'Loading...',
  'redeem.detail_view.back_button': 'Go back',
  'redeem.detail_view.status_cancelled_message':
      'This request was cancelled and cannot continue.',
  'redeem.detail_view.status_rejected_message':
      'This request was rejected by our team.',
  'redeem.detail_view.copied_toast_title': 'Copied',
  'redeem.detail_view.copied_toast_description': '@label copied to clipboard',
  'redeem.detail_view.link_error_title': 'Error',
  'redeem.detail_view.link_error_description':
      'Could not open the tracking link',
  'redeem.detail_view.fetch_data_error': 'Error fetching data. Tap to retry.',
  'redeem.detail_view.delivered_status': 'Delivered!',
  'redeem.detail_view.carrier_label': 'Carrier: @carrier',
  'redeem.detail_view.tracking_label': 'Tracking: @trackingCode',
  'redeem.detail_view.tracking_number_label_for_copy': 'Tracking number',
  'redeem.detail_view.shipping_history_label': 'Shipment History:',
  'redeem.detail_view.view_on_carrier_website_button':
      'View on carrier website',

  //? /modules/qr
  'qr.view.appbar_title': 'My address',
  'qr.view.scan_qr_title_part1': 'Scan this code to ',
  'qr.view.scan_qr_title_part2': 'start your transaction ',

  'qr.view.change_mode_button': 'Scan a QR code',
  'qr.view.change_mode_button_2': 'Show my QR code',

  //? /modules/token
  'token.main_chart.value_label': 'Value: ',
  'token.main_chart.date_label': 'Date: ',

  'token.view.today': ' TODAY',
  'token.view.current_balance': 'Current balance',
  'token.view.buy_button': 'Buy',
  'token.view.sell_button': 'Sell',
  'token.view.send_button': 'Send',
  'token.view.request_button': 'Request',
  'token.view.exchange_button': 'Exchange',

  'token.view.no_balance_available': 'No available balance',
  'token.view.market_indicators': 'Market indicators',
  'token.view.current_price': 'Current price',
  'token.view.daily_change': 'Daily change',
  'token.view.data_updated_every_minute': 'Data updated periodically',
  'token.view.last_update': 'Last update: ',

  //? clain
  'claim.claim_view.title': 'Contact us',
  'claim.claim_view.caption':
      'For any questions about your account or transactions, please use the options listed below. We are ready to assist you.',

  'claim.claim_view.form.name_label': 'Full name',
  'claim.claim_view.form.email_label': 'Email address',
  'claim.claim_view.form.phone_label': 'Phone number',
  'claim.claim_view.form.message_label': 'Message',

  'claim.claim_view.form.claim_category': 'Type of inquiry',
  'claim.claim_view.form.claim_category_placeholder': 'Select a category...',

  'claim.claim_view.form.claim': 'Specific inquiry',
  'claim.claim_view.form.claim_placeholder': 'Select a type of inquiry...',

  'claim.claim_view.form.submit': 'Send',

  'claim.claim_view.success_title': 'Support ticket successfully created',
  'claim.claim_view.success_message': 'We will contact you shortly.',

  //? card
  "card.view.blocked_card_label": "Card blocked",
  "card.view.unfreeze_button": "Unfreeze",
  "card.view.freeze_button": "Freeze",
  "card.view.block_button": "Block",
  "card.view.request_physical_card_button": "Request physical card",
  "card.view.recent_movements_title": "Recent movements",
  "card.activate_page.no_card_title": "You don't have a card yet",
  "card.activate_page.activate_subtitle":
      "Activate your virtual card to start operating.",
  "card.activate_page.activate_button": "Activate my virtual card",
  "card.credit_card.card_number_label": "Card number",
  "card.credit_card.valid_until_label": "Valid until",
  "card.credit_card.cvv_label": "CVV",
  "card.transaction_list.status_completed": "Completed",
  "card.transaction_list.status_pending": "Pending",
  "card.transaction_list.status_failed": "Failed",
  "card.transaction_list.status_unknown": "Unknown",
  "card.transaction_list.no_transactions_found":
      "No transactions found for this card.",
  "card.transaction_list.card_purchase_title": "Card purchase",
  "card.controller.confirm_dialog_title": "Confirm",
  "card.controller.activate_dialog_message":
      "Do you want to activate your virtual card? Once active, it will be permanently linked to your account.",
  "card.controller.confirm_button": "Confirm",
  "card.controller.activation_error_title": "Error activating",
  "card.controller.activation_success_title": "Success!",
  "card.controller.activation_success_description":
      "Your virtual card has been activated.",
  "card.controller.toggle_freeze_error_title": "Error",
  "card.controller.toggle_freeze_success_title": "Success",
  "card.controller.card_frozen_message": "Card frozen successfully.",
  "card.controller.card_unfrozen_message": "Card unfrozen successfully.",
  "card.controller.block_dialog_title": "Block Card",
  "card.controller.block_dialog_message":
      "This action is irreversible by the user. Are you sure you want to permanently block your card?",
  "card.controller.block_dialog_confirm_button": "Yes, block",
  "card.controller.block_dialog_cancel_button": "Cancel",
  "card.controller.block_success_message": "Card blocked successfully.",
  "card.controller.request_physical_error_title": "Error",
  "card.controller.request_physical_success_title": "Request Sent",
  "card.controller.request_physical_success_description":
      "Your physical card has been requested successfully.",

  //? widgets
  'widgets.dynamic_app_scaffold.logout_title': 'Log Out?',
  'widgets.dynamic_app_scaffold.logout_message':
      'Are you sure you want to log out?',
  'widgets.dynamic_app_scaffold.exit_title': 'Exit',
  'widgets.dynamic_app_scaffold.exit_message':
      'Do you want to exit the application?',
  'widgets.dynamic_app_scaffold.confirm_back_title': 'Go Back?',
  'widgets.dynamic_app_scaffold.confirm_back_message':
      'Do you want to return to the previous page?',

  'widgets.dynamic_app_scaffold.confirm': 'Confirm',
  'widgets.dynamic_app_scaffold.cancel': 'Cancel',

  'widgets.dynamic_app_scaffold.go_back_title': 'Go Back',
  'widgets.dynamic_app_scaffold.to_home_message':
      'Do you want to return to the home screen?',
  'widgets.dynamic_app_scaffold.go_back_button': 'Go Back',
  'widgets.dynamic_app_scaffold.to_login_message':
      'Do you want to return to the login screen?',

  'widgets.payment_methods_list.no_methods_available':
      'No payment methods available.',
  'widgets.payment_methods_list.bank_label': 'Bank',
  'widgets.payment_methods_list.holder_label': 'Holder',
  'widgets.payment_methods_list.account_number_label': 'Account No.',
  'widgets.payment_methods_list.swift_code_label': 'Swift Code',
  'widgets.payment_methods_list.currency_label': 'Currency',
  'widgets.payment_methods_list.document_label': 'Document',
  'widgets.payment_methods_list.email_label': 'Email',
  'widgets.payment_methods_list.copied_success':
      'Payment data copied to clipboard',
  'widgets.payment_methods_list.copy_error': 'Error copying data',

  'widgets.dynamic_show_payment_method.default_title': 'Payment Information',
  'widgets.dynamic_show_payment_method.close_button': 'Ok',
  'widgets.dynamic_show_payment_method.no_methods_available':
      'No payment methods available.',
  'widgets.dynamic_show_payment_method.bank_label': 'Bank',
  'widgets.dynamic_show_payment_method.holder_label': 'Holder',
  'widgets.dynamic_show_payment_method.account_number_label': 'Account No.',
  'widgets.dynamic_show_payment_method.swift_code_label': 'Swift Code',
  'widgets.dynamic_show_payment_method.currency_label': 'Currency',
  'widgets.dynamic_show_payment_method.document_label': 'Document',
  'widgets.dynamic_show_payment_method.email_label': 'Email',
  'widgets.dynamic_show_payment_method.copied_success':
      'Payment data copied to clipboard',
  'widgets.dynamic_show_payment_method.copy_error': 'Error copying data',

  'widgets.phone_input.placeholder': 'Select a country code',
  'widgets.phone_input.code.placeholder': 'Code',
  'widgets.phone_input.code.search_placeholder': 'Search for code...',
  'widgets.phone_input.label': 'Phone number',

  'widgets.dynamic_bottom_navigation.send': 'Send',
  'widgets.dynamic_bottom_navigation.request': 'Request',
  'widgets.dynamic_bottom_navigation.exchange': 'Exchange',
  'widgets.dynamic_bottom_navigation.buy': 'Buy',
  'widgets.dynamic_bottom_navigation.sell': 'Sell',

  'widgets.dynamic_bottom_navigation.card': 'Card',
  'widgets.dynamic_bottom_navigation.qr': 'QR',
  'widgets.dynamic_bottom_navigation.coming_soon': 'Coming soon',

  'widgets.dynamic_qrscanner.default_permission_text':
      'Camera permission is required to scan QR codes.',
  'widgets.dynamic_qrscanner.default_resume_button': 'Scan Again',
  'widgets.dynamic_qrscanner.grant_permission_button': 'Grant Permission',

  'widgets.term_and_conditions.failed':
      'The document could not be retrieved. Please try again',
  'widgets.term_and_conditions.error': 'The link could not be opened',

  'widgets.redirect_clain_form.part_1': 'Experiencing any errors? ',
  'widgets.redirect_clain_form.part_2': 'Contact us',

  //? /modules/screens
  'screens.transaction_status_badge.completed': 'Completed',
  'screens.transaction_status_badge.pending': 'Pending',
  'screens.transaction_status_badge.failed': 'Failed',
  'screens.transaction_status_badge.cancelled': 'Cancelled',
  'screens.transaction_status_badge.under_review': 'Under Review',
  'screens.transaction_status_badge.unknown': 'Unknown',

  'screens.transaction_detail.null_transaction': 'Null transaction',
  'screens.transaction_detail.transaction_id': 'Transaction ID: \n ',
  'screens.transaction_detail.copy_transaction_id': 'Copy Transaction ID',
  'screens.transaction_detail.go_to_home': 'Go to Home',

  'screens.transaction_detail.controller.default_appbar_title':
      'Transaction Detail',
  'screens.transaction_detail.controller.commission_label': 'Transaction fee\n',
  'screens.transaction_detail.controller.loading_details': 'Loading details...',
  'screens.transaction_detail.controller.status_completed':
      'Transaction Completed!',
  'screens.transaction_detail.controller.status_pending': 'Transaction Pending',
  'screens.transaction_detail.controller.status_failed': 'Transaction Failed',
  'screens.transaction_detail.controller.status_cancelled':
      'Transaction Cancelled',
  'screens.transaction_detail.controller.movement_details_title':
      'Movement Details',
  'screens.transaction_detail.controller.operation_transferred':
      'You transferred',
  'screens.transaction_detail.controller.operation_transferred_external':
      'You transferred (External)',
  'screens.transaction_detail.controller.operation_deposited': 'You deposited',
  'screens.transaction_detail.controller.operation_exchanged': 'You exchanged',
  'screens.transaction_detail.controller.operation_default': 'Operation',
  'screens.transaction_detail.controller.for_label': 'For',
  'screens.transaction_detail.controller.to_your_account_label':
      'To your account',
  'screens.transaction_detail.controller.received_label': 'You received',
  'screens.transaction_detail.controller.amount_label': 'Amount',
  'screens.transaction_detail.controller.net_amount_label': 'Net Amount',
  'screens.transaction_detail.controller.commission_label_short': 'Commission',
  'screens.transaction_detail.controller.you_sent_to': 'You sent to:',
  'screens.transaction_detail.controller.to_the_wallet': 'To the wallet:',
  'screens.transaction_detail.controller.you_received_from':
      'You received from:',
  'screens.transaction_detail.controller.operation_sold': 'You sold',
  'screens.transaction_detail.controller.operation_bought': 'You bought',
  'screens.transaction_detail.controller.copied_toast_title': 'Copied',
  'screens.transaction_detail.controller.copied_toast_description':
      'Transaction ID copied to clipboard.',

  //? /modules/drawer
  'drawer.view.home': 'Home',
  'drawer.view.send': 'Send',
  'drawer.view.request': 'Request',
  'drawer.view.scan_qr': 'Scan QR',
  'drawer.view.request_loan': 'Request Loan',
  'drawer.view.receive_physical_mineral': 'Receive physical mineral',
  'drawer.view.my_profile': 'My Profile',
  'drawer.view.contact': 'Contact',
  'drawer.view.logout': 'Log Out',

  //? /utils/validation
  'validation.empty_field': 'Field cannot be empty',

  'validation.password_complexity':
      'Password must include at least 3 of: lowercase, uppercase, numbers, and special characters',

  'validation.pass_condition_min_length': 'At least 8 characters',
  'validation.pass_condition_lowercase': 'Lowercase letters (a-z)',
  'validation.pass_condition_uppercase': 'Uppercase letters (A-Z)',
  'validation.pass_condition_numbers': 'Numbers (0-9)',
  'validation.pass_condition_special': 'Special characters (!@#\$%...)',

  'validation.min_length': 'Minimum @count characters',
  'validation.max_length': 'Maximum @count characters',

  'validation.min_value': 'Minimum value not reached',
  'validation.max_value': 'Maximum value exceeded',

  'validation.invalid_email': 'Invalid email address',
  'validation.invalid_chars': 'Invalid field',
  'validation.only_numbers': 'Only numbers are allowed',

  "validation.invalid_number": 'Invalid numeric value',
  'validation.zero_not_allowed': 'Invalid numeric value',

  "validation.no_spaces_allowed": "No spaces allowed",
  "validation.invalid_name_chars":
      "Only letters, spaces and hyphens/apostrophes allowed",
  "validation.only_letters": "Only letters allowed",
  "validation.no_double_spaces": "No consecutive spaces allowed",
  "validation.consecutive_special_chars":
      "Consecutive hyphens or apostrophes are not allowed.",

  "validation.swift_length": "SWIFT must be 8 or 11 characters long",
  "validation.swift_invalid": "Invalid SWIFT",

  "validation.only_digits": "Only numbers allowed",
  "validation.only_alphanumeric": "Only letters and numbers allowed",
  "validation.invalid_country_code": "Invalid country code",
  "validation.invalid_control_digits": "Invalid control digits",
  "validation.invalid_checksum": "Invalid account number",

  'validation.invalid_format': "Invalid format",
  'validation.invalid_month': "Invalid month",
  'validation.invalid_year': "Invalid year",

  'validation.invalid_card_length': "Invalid card length",
  'validation.invalid_card_number': "Invalid card number",

  //? generals/forms
  'form.invalidForm_title': 'Error',
  'form.invalidForm_message': 'Invalid form',

  'form.invalidForm_unknown': 'Unknown error: @message',

  //? dictionaries
  'errors.AUTH0_EMAIL_ALREADY_REGISTERED': 'The email is already registered',
  'errors.AUTH0_EMAIL_UPDATED_ERROR': 'Error updating email',
  'errors.AUTH0_ERROR_REGISTERING_USER': 'Error registering user',
  'errors.AUTH_DATA_UPDATE_ERROR': 'Error updating authentication data',
  'errors.AUTH_USER_NOT_FOUND': 'Authentication user not found',
  'errors.CONNECTION_ERROR': 'Connection error',
  'errors.EMAIL_UNAVAILABLE': 'Email unavailable',
  'errors.EMAIL_UNAVAILABLE_LOGIN': 'Email not associated with an account',
  'errors.EMAIL_UNAVAILABLE_REGISTER':
      'Email associated with an existing account',
  'errors.ERROR_CHECK_EMAIL': 'Error verifying email',
  'errors.ERROR_DELETING_USER': 'Error deleting user',
  'errors.ERROR_REGISTERING_USER': 'Error registering user',
  'errors.INVALID_CHECK_EMAIL_DATA': 'Invalid email verification data',
  'errors.INVALID_DELETE_ACTION': 'You must specify at least one delete action',
  'errors.INVALID_DELETE_USER_DATA': 'Invalid user deletion data',
  'errors.INVALID_REGISTRATION_DATA': 'Invalid registration data',
  'errors.LOGOUT_ERROR': 'Error logging out',
  'errors.BALANCE_DATA_ERROR': 'Error getting balance data',
  'errors.BALANCE_DATA_NOT_FOUND': 'Balance data not found',
  'errors.BALANCE_DATA_RETRIEVAL_ERROR': 'Error retrieving balance data',
  'errors.INVALID_CHANGE_EMAIL_DATA': 'Invalid email change data',
  'errors.INVALID_CHANGE_PASSWORD_DATA': 'Invalid password change data',
  'errors.PASSWORD_CHANGE_ERROR': 'Error changing password',
  'errors.PASSWORD_CHANGE_OTP_ERROR':
      'Error in the password change process with OTP',
  'errors.PASSWORD_CHANGE_OTP_EXPIRED': 'OTP code expired',
  'errors.PASSWORD_CHANGE_OTP_INVALID': 'Invalid or expired OTP code',
  'errors.PASSWORD_CHANGE_OTP_NOT_FOUND': 'Password change request not found',
  'errors.INSUFFICIENT_LIQUIDITY_IN_TREASURY':
      'There is not enough liquidity of {code_asset_to} at the moment',
  'errors.TOKEN_CONVERSION_ERROR': 'Error converting tokens',
  'errors.TOKEN_CONVERSION_ERROR_INVALID_ASSETS':
      'The source or destination asset is not valid',
  'errors.TOKEN_CONVERSION_ERROR_SAME_ASSETS':
      'The source and destination asset cannot be the same',
  'errors.TOKEN_FCM_UPDATE_ERROR': 'Error updating FCM token',
  'errors.INVALID_RECOVERY_DATA': 'Invalid recovery data',
  'errors.PASSWORD_RECOVERY_ERROR': 'Error sending password recovery email',
  'errors.PASSWORD_RECOVERY_OTP_EXPIRED': 'Password recovery OTP code expired',
  'errors.PASSWORD_RECOVERY_OTP_INVALID': 'Invalid password recovery OTP code',
  'errors.PASSWORD_RECOVERY_OTP_NOT_FOUND':
      'Password recovery OTP code not found',
  'errors.USER_NOT_FOUND': 'User not found',
  'errors.GENERAL_ERROR': 'General error',
  'errors.UNKNOWN_ERROR': 'Unknown error',
  'errors.ACTIVE_LOAN_ERROR': 'Error getting active loan information',
  'errors.ALL_LOANS_ERROR': 'Error getting all user loans',
  'errors.ASSET_NOT_FOUND': 'The specified asset was not found',
  'errors.INSUFFICIENT_BALANCE': 'Insufficient balance',
  'errors.INSUFFICIENT_COLLATERAL':
      'Insufficient collateral for the requested loan',
  'errors.INVALID_LOAN_AMOUNT_DATA': 'Invalid loan amount data',
  'errors.INVALID_LOAN_DATA': 'Invalid loan data',
  'errors.INVALID_PAYMENT_DATA': 'Invalid payment data',
  'errors.LIQUIDATION_HISTORY_ERROR': 'Error getting liquidation history',
  'errors.LOAN_ACCESS_DENIED': 'Access to loan denied',
  'errors.LOAN_CAPACITY_CALCULATION_ERROR': 'Error calculating loan capacity',
  'errors.LOAN_CREATION_ERROR': 'Error creating loan',
  'errors.LOAN_DETAIL_ERROR': 'Error getting loan detail',
  'errors.LOAN_LIQUIDATION_ERROR': 'Error liquidating loan',
  'errors.LOAN_NOT_FOUND':
      'The specified loan does not exist or does not belong to this user',
  'errors.LOAN_TERMS_ERROR': 'Error getting payment terms',
  'errors.MISSING_LOAN_REFERENCE':
      'You must specify the reference of the loan to which the payment will be applied',
  'errors.MISSING_PAYMENT_PROOF': 'Proof of payment is required',
  'errors.PAYMENT_CREATION_ERROR': 'Error creating payment',
  'errors.REQUIRED_TOKENS_CALCULATION_ERROR':
      'Error calculating required tokens',
  'errors.USER_DEBT_STATUS_ERROR': 'Error getting user debt status',
  'errors.USER_HAS_ACTIVE_LOAN':
      'The user already has an active or pending loan',
  'errors.USER_HAS_OVERDUE_DEBT':
      'The user has overdue debt and limited access',
  'errors.VAULT_NOT_CONFIGURED': 'No vault associated with this wallet',
  'errors.INVALID_LOGIN_DATA': 'Invalid login data',
  'errors.LOGIN_EMAIL_NOT_VERIFIED': 'The email is not verified.',
  'errors.LOGIN_ERROR': 'Error logging in',
  'errors.LOGIN_WRONG_CREDENTIALS': 'Invalid credentials.',
  'errors.INVALID_MINERAL_DATA': 'Invalid mineral data',
  'errors.MINERAL_CREATION_ERROR': 'Error creating mineral',
  'errors.MINERAL_DATA_RETRIEVAL_ERROR': 'Error retrieving mineral data',
  'errors.ASSET_NOT_WITHDRAWABLE': 'The token is not withdrawable',
  'errors.INVALID_MINERAL_WITHDRAWAL_DATA': 'Invalid mineral withdrawal data',
  'errors.MINERAL_WITHDRAWAL_CALCULATION_ERROR':
      'Error calculating mineral withdrawal cost',
  'errors.MINERAL_WITHDRAWAL_REQUEST_CREATION_ERROR':
      'Error creating mineral withdrawal request',
  'errors.MINERAL_WITHDRAWAL_REQUEST_DECISION_ERROR':
      'Error making a decision on the mineral withdrawal request',
  'errors.MINERAL_WITHDRAWAL_REQUEST_DECISION_NOT_QUOTED':
      'The request is not quoted',
  'errors.MINERAL_WITHDRAWAL_REQUEST_DETAIL_ERROR':
      'Error getting mineral withdrawal request',
  'errors.MINERAL_WITHDRAWAL_REQUEST_LIST_ERROR':
      'Error getting mineral withdrawal requests',
  'errors.MINERAL_WITHDRAWAL_REQUEST_NOT_FOUND':
      'Mineral withdrawal request not found',
  'errors.NOTIFICATIONS_RETRIEVAL_ERROR': 'Error retrieving notifications',
  'errors.OFFRAMP_CALCULATION_ERROR': 'Error calculating off-ramp',
  'errors.OFFRAMP_INSUFFICIENT_BALANCE': 'Insufficient balance for token sale',
  'errors.OFFRAMP_INVALID_ASSET': 'Invalid asset for off-ramp',
  'errors.OFFRAMP_INVALID_DATA': 'Invalid off-ramp data',
  'errors.OFFRAMP_INVALID_PAYMENT_METHOD': 'Invalid payment method',
  'errors.OFFRAMP_RATE_NOT_FOUND': 'Exchange rate not found',
  'errors.OFFRAMP_REQUEST_ERROR': 'Error creating off-ramp request',
  'errors.OFFRAMP_REQUEST_NOT_FOUND': 'Off-ramp request not found',
  'errors.ONRAMP_CALCULATION_ERROR': 'Error calculating on-ramp',
  'errors.ONRAMP_INSUFFICIENT_TREASURY_TOKENS': 'Not enough tokens in treasury',
  'errors.ONRAMP_INVALID_ASSET': 'Invalid asset for on-ramp',
  'errors.ONRAMP_INVALID_DATA': 'Invalid on-ramp data',
  'errors.ONRAMP_REQUEST_ERROR': 'Error creating on-ramp request',
  'errors.ONRAMP_REQUEST_NOT_FOUND': 'On-ramp request not found',
  'errors.INVALID_OTP_DATA': 'Invalid OTP data',
  'errors.OTP_ERROR': 'Error sending OTP',
  'errors.OTP_INVALID': 'Invalid OTP code',
  'errors.ERROR_VALIDATING_PASSWORD': 'Error validating password',
  'errors.INVALID_PASSWORD_DATA': 'Invalid password data',
  'errors.PASSWORD_INVALID': 'Invalid password',
  'errors.PAYMENT_METHOD_BANK_LIST_ERROR':
      'Error getting payment method bank list',
  'errors.PAYMENT_METHOD_BANK_NOT_FOUND': 'Payment method bank not found',
  'errors.PAYMENT_METHOD_CURRENCY_LIST_ERROR':
      'Error getting payment method currency list',
  'errors.PAYMENT_METHOD_LIST_ERROR': 'Error getting payment method list',
  'errors.PAYMENT_METHOD_NOT_FOUND': 'Payment method not found',
  'errors.PAYMENT_METHOD_TYPE_LIST_ERROR':
      'Error getting payment method type list',
  'errors.PROFILE_DATA_RETRIEVAL_ERROR': 'Error retrieving profile data',
  'errors.PROFILE_NOT_FOUND': 'User profile not found',
  'errors.PROFILE_UPDATE_ERROR': 'Error updating profile data',
  'errors.TOKEN_EXPIRED': 'Authentication token expired',
  'errors.TOKEN_UNAUTHORIZED': 'Unauthorized or invalid token',
  'errors.INVALID_DATE_FORMAT': 'Invalid date format. Use YYYY-MM-DD',
  'errors.INVALID_PAGE_SIZE': 'Page size must be a positive integer',
  'errors.INVALID_QUOTATION_DATA': 'Invalid quotation data',
  'errors.INVALID_STATUS_FILTER': 'Invalid status filter',
  'errors.INVALID_TRANSACTION_DATA': 'Invalid transaction data',
  'errors.TRANSACTION_CREATION_ERROR': 'Error creating transaction',
  'errors.TRANSACTION_HISTORY_ERROR': 'Error retrieving transaction history',
  'errors.TRANSACTION_NOT_FOUND': 'Transaction not found',
  'errors.TRANSACTION_QUOTATION_ERROR':
      'Error calculating transaction quotation',
  'errors.VERIFF_ATTEMPTS_EXCEEDED': 'Verification attempts exceeded',
  'errors.VERIFF_SESSION_CREATION_ERROR': 'Error creating verification session',
  'errors.VERIFF_SESSION_UPDATE_ERROR': 'Error updating verification session',
  'errors.WAREHOUSE_CREATION_ERROR': 'Error creating warehouse',
  'errors.INVALID_WALLET_QUERY_PARAMS':
      'You must provide an email or a wallet address',
  'errors.WALLET_ASSET_NOT_FOUND': 'Wallet asset not found',
  'errors.WALLET_NOT_FOUND': 'No wallet found with the provided data',
  'errors.WALLET_VALIDATION_ERROR': 'Error validating wallet',
  'errors.unknown_error_with_key': 'Unknown error ({key})',

  'success.ACTIVE_LOAN_FOUND': 'Active loan found',
  'success.ALL_LOANS_FOUND': 'All user loans successfully retrieved',
  'success.AUTH0_EMAIL_UPDATED_SUCCESSFULLY': 'Email updated successfully',
  'success.AUTH_DATA_UPDATED': 'Authentication data updated successfully',
  'success.EMAIL_AVAILABLE': 'Email available',
  'success.EMAIL_UNAVAILABLE': 'Email unavailable',
  'success.BALANCE_DATA_RETRIEVED': 'Wallet balance successfully retrieved',
  'success.LOGOUT_SUCCESS': 'Logout successful',
  'success.SUCCESS': 'Operation successful',
  'success.LIQUIDATION_HISTORY_FOUND': 'Liquidation history found successfully',
  'success.LOAN_CAPACITY_CALCULATED': 'Loan capacity calculated successfully',
  'success.LOAN_CREATED_SUCCESSFULLY': 'Loan created successfully',
  'success.LOAN_DETAIL_FOUND': 'Loan detail found successfully',
  'success.LOAN_LIQUIDATED_SUCCESSFULLY': 'Loan liquidated successfully',
  'success.LOAN_TERMS_FOUND': 'Payment terms found successfully',
  'success.NO_ACTIVE_LOAN': 'The user has no active loans',
  'success.NO_LOANS_FOUND': 'The user has no registered loans',
  'success.LOGIN_SUCCESS': 'Login successful',
  'success.MINERAL_CREATED': 'Mineral created successfully',
  'success.MINERAL_DATA_RETRIEVED': 'Mineral data successfully retrieved',
  'success.MINERAL_WITHDRAWAL_CALCULATION_SUCCESS':
      'Mineral withdrawal cost calculated successfully',
  'success.MINERAL_WITHDRAWAL_REQUEST_CREATED':
      'Mineral withdrawal request created successfully',
  'success.MINERAL_WITHDRAWAL_REQUEST_DECISION_ACCEPTED':
      'Mineral withdrawal request accepted successfully',
  'success.MINERAL_WITHDRAWAL_REQUEST_DECISION_REJECTED':
      'Mineral withdrawal request rejected successfully',
  'success.MINERAL_WITHDRAWAL_REQUEST_DETAIL_SUCCESS':
      'Mineral withdrawal request successfully retrieved',
  'success.MINERAL_WITHDRAWAL_REQUEST_LIST_EMPTY':
      'No mineral withdrawal requests',
  'success.MINERAL_WITHDRAWAL_REQUEST_LIST_SUCCESS':
      'Mineral withdrawal requests successfully retrieved',
  'success.NOTIFICATIONS_RETRIEVED': 'Notifications successfully retrieved',
  'success.OFFRAMP_CALCULATION_SUCCESS':
      'Off-ramp calculation successfully performed',
  'success.OFFRAMP_REQUEST_APPROVED': 'Off-ramp request approved successfully',
  'success.OFFRAMP_REQUEST_CREATED': 'Off-ramp request created successfully',
  'success.OFFRAMP_REQUEST_PAID': 'Off-ramp payment processed successfully',
  'success.OFFRAMP_REQUEST_REJECTED': 'Off-ramp request rejected',
  'success.ONRAMP_CALCULATION_SUCCESS':
      'On-ramp calculation successfully performed',
  'success.ONRAMP_PAYMENT_RECEIVED': 'On-ramp payment received successfully',
  'success.ONRAMP_REQUEST_COMPLETED': 'On-ramp request completed successfully',
  'success.ONRAMP_REQUEST_CREATED': 'On-ramp request created successfully',
  'success.ONRAMP_REQUEST_REJECTED': 'On-ramp request rejected',
  'success.OTP_SENT_SUCCESSFULLY': 'OTP sent successfully',
  'success.OTP_VERIFIED_SUCCESSFULLY': 'OTP code verified successfully',
  'success.PASSWORD_CHANGED_SUCCESSFULLY': 'Password updated successfully',
  'success.PASSWORD_CHANGE_COMPLETED': 'Password changed successfully',
  'success.PASSWORD_CHANGE_OTP_REQUESTED': 'OTP code sent for password change',
  'success.PASSWORD_CHANGE_OTP_VERIFIED': 'OTP code verified successfully',
  'success.PASSWORD_RECOVERY_COMPLETED':
      'Password recovery completed successfully',
  'success.PASSWORD_RECOVERY_OTP_VERIFIED':
      'Password recovery OTP code verified successfully',
  'success.PASSWORD_RECOVERY_SENT': 'A password recovery email has been sent',
  'success.PASSWORD_VALID': 'Password is valid',
  'success.PAYMENT_CREATED_SUCCESSFULLY':
      'Payment created successfully and is pending confirmation',
  'success.PAYMENT_METHOD_BANK_LIST_SUCCESS':
      'Payment method bank list successfully retrieved',
  'success.PAYMENT_METHOD_CURRENCY_LIST_SUCCESS':
      'Payment method currency list successfully retrieved',
  'success.PAYMENT_METHOD_LIST_SUCCESS':
      'Payment method list successfully retrieved',
  'success.PAYMENT_METHOD_TYPE_LIST_SUCCESS':
      'Payment method type list successfully retrieved',
  'success.PROFILE_DATA_RETRIEVED': 'Profile data successfully retrieved',
  'success.PROFILE_UPDATED': 'Profile data updated successfully',
  'success.REQUIRED_TOKENS_CALCULATED':
      'Required tokens calculated successfully',
  'success.TOKEN_FCM_UPDATED': 'FCM token updated successfully',
  'success.TOKEN_CONVERSION_SUCCESS': 'Token exchange completed successfully',
  'success.TOKEN_CONVERSION_SUCCESSFULLY_CALCULATED':
      'Token conversion successful',
  'success.TRANSACTION_CREATED_SUCCESSFULLY':
      'Transaction created successfully',
  'success.TRANSACTION_HISTORY_RETRIEVED':
      'Transaction history successfully retrieved',
  'success.TRANSACTION_QUOTATION_CALCULATED':
      'Transaction quotation calculated successfully',
  'success.TRANSACTION_RETRIEVED': 'Transaction successfully retrieved',
  'success.USER_CREATED_SUCCESSFULLY':
      'User created successfully. Please verify your email',
  'success.USER_DELETED_FROM_AUTH0': 'User successfully deleted from Auth0',
  'success.USER_DELETED_FROM_LOCAL':
      'User successfully deleted from local database',
  'success.USER_DELETED_SUCCESSFULLY': 'User deleted successfully',
  'success.USER_DEBT_STATUS_FOUND': 'User debt status successfully retrieved',
  'success.VERIFF_SESSION_CREATED': 'Verification session created successfully',
  'success.VERIFF_SESSION_UPDATED': 'Verification session updated successfully',
  'success.WALLET_FOUND': 'Wallet found successfully',
  'success.WAREHOUSE_CREATED': 'Warehouse created successfully',
  'success.process_completed': 'Process completed',

  //? Security / 2FA
  'security.setup_2fa.title': 'Two-Factor Authentication',
  'security.setup_2fa.subtitle': 'Protect your transactions with an authenticator app (Google Authenticator, Authy, etc.).',
  'security.setup_2fa.open_in_app': 'Open in my authenticator app',
  'security.setup_2fa.manual_entry': 'Manual entry (if you can\'t scan the QR):',
  'security.setup_2fa.enter_code': 'Enter the 6-digit code from your app to activate:',
  'security.setup_2fa.activate_button': 'Activate 2FA',
  'security.setup_2fa.enabled_title': '2FA Active',
  'security.setup_2fa.enabled_subtitle': 'Your transactions are protected.',
  'security.setup_2fa.disable_prompt': 'Enter your current code to disable 2FA:',
  'security.setup_2fa.disable_button': 'Disable 2FA',
  'security.totp_dialog.title': 'Security Verification',
  'security.totp_dialog.subtitle': 'Enter the 6-digit code from your authenticator app.',
  'security.totp_dialog.confirm_button': 'Confirm',
  'security.totp_dialog.cancel_button': 'Cancel',
  'security.totp_activated': '2FA activated successfully',
  'security.totp_disabled': '2FA disabled',
  'security.totp_code_invalid': 'Invalid code. Must be 6 digits.',
  'security.totp_secret_copied': 'Key copied to clipboard',
  'security.totp_open_app_error': 'Could not open the authenticator app',
  'security.error_loading': 'Error loading 2FA configuration',
  'security.error_generic': 'An error occurred. Please try again.',

  'document_viewer.tos_title': 'Terms and Conditions',
  'document_viewer.privacy_title': 'Privacy Policy',
  'document_viewer.open_external': 'Open in browser',
  'document_viewer.load_error': 'Could not load the document. You can open it in your browser.',
};
