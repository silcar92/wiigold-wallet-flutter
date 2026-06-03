class ApiEndpoints {
  //? Login
  static const String login = '/auth/login/';
  static const String forgot_password = "/auth/forgot-password/";

  //? Register
  static const String register = '/auth/register/';
  static const String session_url = '/veriff/session/';

  //? SumSub KYC/KYB
  static const String sumsub_access_token = '/sumsub/access-token/';

  //? Recovery
  static const String request_otp = "/auth/password-recovery/request/";
  static const String verify_otp = "/auth/password-recovery/verify/";
  static const String change_password = "/auth/password-recovery/complete/";

  //? Auth
  static const String kyc_data = '/accounts/auth-data/';
  static const String validate_password = '/auth/validate-password/';

  //? Home

  //? Wallet
  static const String transaction_send = 'transactions/';
  static const String balance = 'accounts/wallet/balance/';
  static const String get_user_wallet = 'accounts/wallet/';
  static const String comission = 'transactions/quotation/';
  static const String exchange = '/exchange/execute/';
  static const String exchange_comission = '/exchange/calculate-tokens/';
  static const String transaction_history = 'transactions';
  static const String token_price_history = "accounts/assets/";

  //? sell
  static const String sell_comission = '/exchange/offramp/calculate/';
  static const String sell = '/exchange/offramp/execute/';

  //? buy
  static const String buy_comission = '/exchange/onramp/calculate/';
  static const String buy = '/exchange/onramp/execute/';

  //? Transactions
  static const String transaction_detail = 'transactions/';

  //? Notifications
  static const String get_notifications = 'accounts/notifications/';

  //? Cards
  static const String card_activate = '/cards/activate/';
  static const String card_details = '/cards/details/';
  static const String card_freeze = '/cards/freeze/';
  static const String card_block = '/cards/block/';
  static const String card_transactions = '/cards/transactions/';
  static const String card_requestPhysical = '/cards/request-physical/';

  //? Claim
  static const String claimCategories = '/support/categories';
  static const String createClaim = 'support/tickets/';

  //? Loan
  static const String loan = '/loans/';
  static const String loan_active = '/loans/active/';
  static const String loan_detail = '/loans/detail/';

  static const String loan_term = 'loans/terms/';
  static const String loan_data = '/loans/capacity/';
  static const String loan_payment = '/loans/payments/';
  static const String loan_collateral = '/loans/calculate-tokens/';

  //? Redeem
  static const String redeem = '/mineral-withdrawal/execute/';
  static const String redeem_list = '/mineral-withdrawal/requests/';
  static const String redeem_detail = '/mineral-withdrawal/requests/';
  static const String redeem_decision = '/mineral-withdrawal/requests/';

  static const String redeem_term = '';

  static const String redeem_payment = '';
  static const String redeem_calculate = '/mineral-withdrawal/calculate/';

  //? Financial
  static const String payment_method_types = "/payments/payment-method-types/";
  static const String payment_methods = "/payments/payment-methods/";

  static const String terms_and_conditions_document =
      '/support/terms-and-conditions/latest/';

  static const String privacy_policy_document =
      '/support/privacy-policy/latest/';

  //? Profile
  static const String profile = "/accounts/profile/";
  static const String change_email = '/auth/change-email/';
  static const String change_fcm_token = '/accounts/token-fcm/';

  //? 2FA / TOTP
  static const String totp_setup = '/auth/2fa/setup/';
  static const String totp_verify_setup = '/auth/2fa/verify-setup/';
  static const String totp_disable = '/auth/2fa/disable/';
  static const String totp_verify = '/auth/2fa/verify/';

  //? KYB (persona jurídica)
  static const String kyb_company_info = '/kyb/company-info/';
  static const String kyb_ubo_list = '/kyb/ubo/';
  static const String kyb_ubo_detail = '/kyb/ubo/'; // + <id>/
  static const String kyb_ubo_complete = '/kyb/ubo/complete/';
  static const String kyb_documents = '/kyb/documents/';
  static const String kyb_documents_detail = '/kyb/documents/'; // + <id>/
  static const String kyb_submit = '/kyb/submit/';
  static const String kyb_status = '/kyb/status/';
  static const String kyb_resubmit = '/kyb/resubmit/';

  //? Logout
  static const String logout = '/auth/logout/';

  //? Others
  static const String avilable_email = "auth/check-email/";
  static const String countries = '/locations/countries/';
  static const String regions = '/locations/regions/';
}
