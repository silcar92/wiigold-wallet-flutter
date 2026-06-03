class AppRoutes {
  static const SPLASH = '/splash';

  //? LogIn/SignIn
  static const LOGIN = '/login';

  //? Recovery
  static const RECOVERY = '/recovery';
  static const RECOVERY_VALIDATION = '/recovery_validation';
  static const RECOVERY_NEWPASS = '/recovery_newpass';

  //? Register/Auth
  static const REGISTER_TYPE = '/register_type';
  static const REGISTER = '/register';
  static const REGISTER_VERIFICATION = '/register_verification';

  static const AUTH = '/auth';
  static const AUTH_KYC = '/auth_kyc';

  //? Home
  static const HOME = '/home';

  //? Home / Token
  static const TOKEN = '/token';

  //? Home / Token / Buy
  static const BUY_SELECTOR = '/buy_selector';
  static const BUY = '/buy';
  static const BUY_INFO = '/buy_info';
  static const CONFIRM_BUY = '/confirm_buy';
  static const BUY_DATA = '/buy_data';
  static const BUY_PENDING = '/buy_pending';
  static const BUY_SUCCESS = '/buy_success';

  //? Home / Token / Sell
  static const SELL_SELECTOR = '/sell_selector';
  static const SELL = '/sell';
  static const SELL_DATA = '/sell_data';
  static const CONFIRM_SELL = '/confirm_sell';

  //? Send
  static const SEND_SELECTOR = '/send_selector';
  static const SEND = '/send';
  static const SEND_INSERT_TARGET = '/send_insert_target';
  static const SEND_CONFIRM = '/send_confirm';

  //? Request
  static const REQUEST_SELECTOR = '/request_selector';
  static const REQUEST = '/request';
  static const REQUEST_SHARE = '/request_share';

  //? Exchange
  static const EXCHANGE = '/exchange';
  static const EXCHANGE_CONFIRM = '/exchange_confirm';

  //? CARD
  static const CARD = '/card';

  //? Loan
  static const LOAN_SELECTOR = '/loan_selector';
  static const LOAN = '/loan';
  static const LOAN_REQUEST = '/loan_request';
  static const LOAN_DETAIL = '/loan_detail';
  static const LOAN_DATA = '/loan_data';
  static const LOAN_FINISH = '/loan_finish';

  static const LOAN_PAYMENT = '/loan_payment';
  static const LOAN_PAYMENT_INFO = '/loan_payment_info';
  static const LOAN_PAYMENT_DATA = '/loan_payment_data';

  //? Redeem
  static const REDEEM = '/redeem';
  static const REDEEM_SELECTOR = '/redeem_selector';
  static const REDEEM_REQUEST = '/redeem_request';
  static const REDEEM_DETAIL = '/redeem_detail';
  static const REDEEM_DATA = '/redeem_data';
  static const REDEEM_FINISH = '/redeem_finish';

  //? QR
  static const QR = '/qr';

  //? Profile
  static const PROFILE = '/profile';
  static const PROFILE_KYC = '/profile_kyc';
  static const PROFILE_DATA = '/profile_data';
  static const BENEFITS = '/benefits';
  static const SETTINGS = '/settings';

  static const CLAIM = '/claim';

  //? Security / 2FA
  static const SECURITY_2FA = '/security_2fa';

  //? KYB (persona jurídica)
  static const KYB_COMPANY_INFO = '/kyb_company_info';
  static const KYB_UBO_LIST = '/kyb_ubo_list';
  static const KYB_UBO_FORM = '/kyb_ubo_form';
  static const KYB_DOCUMENTS = '/kyb_documents';
  static const KYB_PENDING = '/kyb_pending';
  static const KYB_STATUS = '/kyb_status';

  //? Document viewer (ToS, privacy policy, etc.)
  static const DOCUMENT_VIEWER = '/document_viewer';

  //? Generic
  static const TRANSACTION_DETAIL = '/transaction_detail';
  static const NOTIFICATIONS = '/notifications';
}
