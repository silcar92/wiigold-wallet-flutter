//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/core/services/notification/bindings/notification_bindings.dart';
import 'package:wiigold/app/core/services/notification/views/notification_view.dart';
import 'package:wiigold/app/core/services/transaction_detail/bindins/transaction_detail_bindins.dart';
import 'package:wiigold/app/core/services/transaction_detail/views/transaction_detail_view.dart';
import 'package:wiigold/app/modules/auth/views/auth_view.dart';
import 'package:wiigold/app/modules/buy/bindings/buy_bindings.dart';
import 'package:wiigold/app/modules/buy/views/buy_data_view.dart';
import 'package:wiigold/app/modules/buy/views/buy_payment_info_view.dart';
import 'package:wiigold/app/modules/buy/views/buy_selector_view.dart';
import 'package:wiigold/app/modules/buy/views/buy_view.dart';
import 'package:wiigold/app/modules/buy/views/buy_pending_view.dart';
import 'package:wiigold/app/modules/buy/views/buy_success_view.dart';
import 'package:wiigold/app/modules/buy/views/confirm_buy_view.dart';
import 'package:wiigold/app/modules/card/bindins/card_bindins.dart';
import 'package:wiigold/app/modules/card/views/card_view.dart';
import 'package:wiigold/app/modules/claim/bindings/claim_bindings.dart';
import 'package:wiigold/app/modules/claim/views/claim_view.dart';
import 'package:wiigold/app/modules/exchange/bindings/exchange_bindings.dart';
import 'package:wiigold/app/modules/exchange/views/confirm_exchange_view.dart';
import 'package:wiigold/app/modules/exchange/views/exchange_view.dart';
import 'package:wiigold/app/modules/home/bindings/home_bindings.dart';
import 'package:wiigold/app/modules/home/views/home_view.dart';
import 'package:wiigold/app/modules/loan/bindings/loan_binding.dart';
import 'package:wiigold/app/modules/loan/views/loan_data_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_detail_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_finish_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_payment_data_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_payment_info_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_payment_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_request_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_selector_view.dart';
import 'package:wiigold/app/modules/loan/views/loan_view.dart';
import 'package:wiigold/app/modules/profile/views/data_view.dart';
import 'package:wiigold/app/modules/profile/views/kyc_view.dart';
import 'package:wiigold/app/modules/profile/views/profile_view.dart';
import 'package:wiigold/app/modules/qr/bindins/qr_bindins.dart';
import 'package:wiigold/app/modules/qr/views/qr_view.dart';
import 'package:wiigold/app/modules/redeem/bindings/redeem_binding.dart';
import 'package:wiigold/app/modules/redeem/views/redeem_data_view.dart';
import 'package:wiigold/app/modules/redeem/views/redeem_detail_view.dart';
import 'package:wiigold/app/modules/redeem/views/redeem_finish_view.dart';
import 'package:wiigold/app/modules/redeem/views/redeem_request_view.dart';
import 'package:wiigold/app/modules/redeem/views/redeem_selector_view.dart';
import 'package:wiigold/app/modules/redeem/views/redeem_view.dart';
import 'package:wiigold/app/modules/request/bindings/request_binding.dart';
import 'package:wiigold/app/modules/request/views/request_selector_view.dart';
import 'package:wiigold/app/modules/request/views/request_share_view.dart';
import 'package:wiigold/app/modules/request/views/request_view.dart';
import 'package:wiigold/app/modules/sell/bindings/sell_bindings.dart';
import 'package:wiigold/app/modules/sell/views/confirm_sell_view.dart';
import 'package:wiigold/app/modules/sell/views/sell_data_view.dart';
import 'package:wiigold/app/modules/sell/views/sell_selector_view.dart';
import 'package:wiigold/app/modules/sell/views/sell_view.dart';
import 'package:wiigold/app/modules/send/bindings/send_binding.dart';
import 'package:wiigold/app/modules/send/views/send_confirm_view.dart';
import 'package:wiigold/app/modules/send/views/send_insert_target_view.dart';
import 'package:wiigold/app/modules/send/views/send_selector_view.dart';
import 'package:wiigold/app/modules/send/views/send_view.dart';
import 'package:wiigold/app/modules/security/bindings/security_bindings.dart';
import 'package:wiigold/app/modules/security/views/setup_2fa_view.dart';
import 'package:wiigold/app/common/widgets/layout/document_viewer_screen.dart';
import 'package:wiigold/app/modules/kyb/bindings/kyb_binding.dart';
import 'package:wiigold/app/modules/kyb/views/kyb_company_info_view.dart';
import 'package:wiigold/app/modules/kyb/views/kyb_documents_view.dart';
import 'package:wiigold/app/modules/kyb/views/kyb_pending_view.dart';
import 'package:wiigold/app/modules/kyb/views/kyb_status_view.dart';
import 'package:wiigold/app/modules/kyb/views/kyb_ubo_form_view.dart';
import 'package:wiigold/app/modules/kyb/views/kyb_ubo_list_view.dart';
import 'package:wiigold/app/modules/settings/bindings/settings_bindings.dart';
import 'package:wiigold/app/modules/settings/views/settings_view.dart';
import 'package:wiigold/app/modules/token/bindings/token_bindings.dart';
import 'package:wiigold/app/modules/token/views/token_view.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? splash
import 'package:wiigold/app/core/services/splash/bindings/splash_bindings.dart';
import 'package:wiigold/app/core/services/splash/views/splash_view.dart';

//? Login
import 'package:wiigold/app/modules/login/views/login_view.dart';
import 'package:wiigold/app/modules/login/bindings/login_bindings.dart';

//? Recovery
import 'package:wiigold/app/modules/recovery/bindings/recovery_bindings.dart'; // <- Binding
import 'package:wiigold/app/modules/recovery/views/recovery_view.dart';
import 'package:wiigold/app/modules/recovery/views/recovery_validation_view.dart';
import 'package:wiigold/app/modules/recovery/views/recovery_newpass_view.dart';

//? Register
import 'package:wiigold/app/modules/register/bindings/register_bindings.dart';
import 'package:wiigold/app/modules/register/views/person_type_selector_view.dart';
import 'package:wiigold/app/modules/register/views/verification_view.dart';

import '../modules/register/views/register_view.dart';

class AppPages {
  static const initial = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),

    //? Login
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    //? Recovery
    GetPage(
      name: AppRoutes.RECOVERY,
      page: () => RecoveryView(),
      binding: RecoveryBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.RECOVERY_VALIDATION,
      page: () => RecoveryValidationView(),
      binding: RecoveryBinding(),
    ),
    GetPage(
      name: AppRoutes.RECOVERY_NEWPASS,
      page: () => RecoveryNewpassView(),
      binding: RecoveryBinding(),
    ),

    //? Register
    GetPage(
      name: AppRoutes.REGISTER_TYPE,
      page: () => PersonTypeSelectorView(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: AppRoutes.REGISTER_VERIFICATION,
      page: () => VerificationView(),
      binding: RegisterBinding(),
    ),

    //? Home
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    //? Home / Token
    GetPage(
      name: AppRoutes.TOKEN,
      page: () => TokenView(),
      binding: TokenBinding(),
    ),

    //? Home / Token / Buy
    GetPage(
      name: AppRoutes.BUY_SELECTOR,
      page: () => BuySelectorView(),
      binding: BuyBinding(),
    ),
    GetPage(name: AppRoutes.BUY, page: () => BuyView(), binding: BuyBinding()),
    GetPage(
      name: AppRoutes.BUY_DATA,
      page: () => BuyDataView(),
      binding: BuyBinding(),
    ),

    GetPage(
      name: AppRoutes.BUY_INFO,
      page: () => BuyPaymentInfoView(),
      binding: BuyBinding(),
    ),

    GetPage(
      name: AppRoutes.CONFIRM_BUY,
      page: () => ConfirmBuyView(),
      binding: BuyBinding(),
    ),
    GetPage(
      name: AppRoutes.BUY_PENDING,
      page: () => const BuyPendingView(),
    ),
    GetPage(
      name: AppRoutes.BUY_SUCCESS,
      page: () => const BuySuccessView(),
    ),

    //? Home / Token / Sell
    GetPage(
      name: AppRoutes.SELL_SELECTOR,
      page: () => SellSelectorView(),
      binding: SellBinding(),
    ),
    GetPage(
      name: AppRoutes.SELL,
      page: () => SellView(),
      binding: SellBinding(),
    ),
    GetPage(
      name: AppRoutes.SELL_DATA,
      page: () => SellDataView(),
      binding: SellBinding(),
    ),
    GetPage(
      name: AppRoutes.CONFIRM_SELL,
      page: () => ConfirmSellView(),
      binding: SellBinding(),
    ),

    //? Send
    GetPage(
      name: AppRoutes.SEND_SELECTOR,
      page: () => SendSelectorView(),
      binding: SendBinding(),
    ),
    GetPage(
      name: AppRoutes.SEND,
      page: () => SendView(),
      binding: SendBinding(),
    ),
    GetPage(
      name: AppRoutes.SEND_INSERT_TARGET,
      page: () => SendInsertTargetView(),
      binding: SendBinding(),
    ),
    GetPage(
      name: AppRoutes.SEND_CONFIRM,
      page: () => SendConfirmView(),
      binding: SendBinding(),
    ),

    //? Request
    GetPage(
      name: AppRoutes.REQUEST_SELECTOR,
      page: () => RequestSelectorView(),
      binding: RequestBinding(),
    ),
    GetPage(
      name: AppRoutes.REQUEST,
      page: () => RequestView(),
      binding: RequestBinding(),
    ),
    GetPage(
      name: AppRoutes.REQUEST_SHARE,
      page: () => RequestShareView(),
      binding: RequestBinding(),
    ),

    //? Exchange
    GetPage(
      name: AppRoutes.EXCHANGE,
      page: () => ExchangeView(),
      binding: ExchangeBinding(),
    ),
    GetPage(
      name: AppRoutes.EXCHANGE_CONFIRM,
      page: () => ConfirmExchangeView(),
      binding: ExchangeBinding(),
    ),

    //? QR
    GetPage(name: AppRoutes.QR, page: () => QrView(), binding: QrBindins()),

    //? Card
    GetPage(
      name: AppRoutes.CARD,
      page: () => CardView(),
      binding: CardBindins(),
    ),

    //? Loan
    GetPage(
      name: AppRoutes.LOAN_SELECTOR,
      page: () => LoanSelectorView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.LOAN,
      page: () => LoanView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.LOAN_REQUEST,
      page: () => LoanRequestView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.LOAN_DETAIL,
      page: () => LoanDetailView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.LOAN_DATA,
      page: () => LoanDataView(),
      binding: LoanBinding(),
    ),

    GetPage(
      name: AppRoutes.LOAN_FINISH,
      page: () => LoanFinishView(),
      binding: LoanBinding(),
    ),

    GetPage(
      name: AppRoutes.LOAN_PAYMENT,
      page: () => LoanPaymentView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.LOAN_PAYMENT_INFO,
      page: () => LoanPaymentInfoView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.LOAN_PAYMENT_DATA,
      page: () => LoanPaymentDataView(),
      binding: LoanBinding(),
    ),

    //? Redeem
    GetPage(
      name: AppRoutes.REDEEM,
      page: () => RedeemView(),
      binding: RedeemBinding(),
    ),
    GetPage(
      name: AppRoutes.REDEEM_SELECTOR,
      page: () => RedeemSelectorView(),
      binding: RedeemBinding(),
    ),
    GetPage(
      name: AppRoutes.REDEEM_REQUEST,
      page: () => RedeemRequestView(),
      binding: RedeemBinding(),
    ),
    GetPage(
      name: AppRoutes.REDEEM_DETAIL,
      page: () => RedeemDetailView(),
      binding: RedeemBinding(),
    ),
    GetPage(
      name: AppRoutes.REDEEM_DATA,
      page: () => RedeemDataView(),
      binding: RedeemBinding(),
    ),

    GetPage(
      name: AppRoutes.REDEEM_FINISH,
      page: () => RedeemFinishView(),
      binding: RedeemBinding(),
    ),

    //? Profile
    GetPage(name: AppRoutes.PROFILE, page: () => ProfileView()),
    GetPage(name: AppRoutes.PROFILE_DATA, page: () => DataView()),
    GetPage(name: AppRoutes.PROFILE_KYC, page: () => KycView()),

    //? Security / 2FA
    GetPage(
      name: AppRoutes.SECURITY_2FA,
      page: () => Setup2FAView(),
      binding: SecurityBinding(),
    ),

    //? KYB (persona jurídica)
    GetPage(
      name: AppRoutes.KYB_COMPANY_INFO,
      page: () => const KybCompanyInfoView(),
      binding: KybBinding(),
    ),
    GetPage(
      name: AppRoutes.KYB_UBO_LIST,
      page: () => const KybUboListView(),
      binding: KybBinding(),
    ),
    GetPage(
      name: AppRoutes.KYB_UBO_FORM,
      page: () => const KybUboFormView(),
      binding: KybBinding(),
    ),
    GetPage(
      name: AppRoutes.KYB_DOCUMENTS,
      page: () => const KybDocumentsView(),
      binding: KybBinding(),
    ),
    GetPage(
      name: AppRoutes.KYB_PENDING,
      page: () => const KybPendingView(),
      binding: KybBinding(),
    ),
    GetPage(
      name: AppRoutes.KYB_STATUS,
      page: () => const KybStatusView(),
      binding: KybBinding(),
    ),

    //? Document viewer
    GetPage(
      name: AppRoutes.DOCUMENT_VIEWER,
      page: () {
        final args = Get.arguments as Map<String, String>;
        return DocumentViewerScreen(
          url: args['url']!,
          title: args['title']!,
        );
      },
    ),

    //? Settings
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),

    //? Generic
    GetPage(
      name: AppRoutes.TRANSACTION_DETAIL,
      page: () => TransactionDetailView(),
      binding: TransactionDetailBindins(),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),

    //? Auth
    GetPage(name: AppRoutes.AUTH, page: () => AuthView()),

    //? Claim
    GetPage(
      name: AppRoutes.CLAIM,
      page: () => ClaimView(),
      binding: ClaimBinding(),
    ),

    /*


    //? Register/Auth
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.register_pass,
      page: () => PassView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.register_verification,
      page: () => VerificationView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.terms,
      page: () => TermsView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.terms_privacy,
      page: () => PrivacyScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.terms_conditions,
      page: () => ConditionsScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(name: AppRoutes.auth, page: () => AuthView()),
    GetPage(name: AppRoutes.support, page: () => SupportView()),






    */
  ];
}
