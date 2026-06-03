enum Environment {
  local1,
  local2,
  local3,
  local4,
  develop,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment get current {
    const env = String.fromEnvironment('ENV', defaultValue: 'stage');

    switch (env.toLowerCase()) {
      case 'local1':
        return Environment.local1;
      case 'local2':
        return Environment.local2;
      case 'local3':
        return Environment.local3;
      case 'local4':
        return Environment.local4;
      case 'dev':
      case 'develop':
        return Environment.develop;
      case 'stage':
      case 'staging':
        return Environment.staging;
      case 'prod':
      case 'production':
        return Environment.production;
      default:
        return Environment.local1;
    }
  }

  static String get apiUrl {
    switch (current) {
      case Environment.local1:
        return 'https://significative-may-corollaceous.ngrok-free.dev';
      case Environment.local2:
        return 'https://rich-racer-wildly.ngrok-free.app';
      case Environment.local3:
        return 'https://malamute-hardy-dogfish.ngrok-free.app';
      case Environment.local4:
        return 'https://unwooded-oozily-chaya.ngrok-free.dev';

      case Environment.develop:
        return 'https://admin-wallet.develop.wiigold.com';
      case Environment.staging:
        return 'https://admin-wallet.demo.wiigold.com';
      case Environment.production:
        return '';
    }
  }

  static String get refUrl {
    switch (current) {
      case Environment.local1:
      case Environment.local2:
      case Environment.local3:
      case Environment.local4:
      case Environment.develop:
        return 'https://pay-develop.wiigold.com/';
      case Environment.staging:
        return 'https://pay-demo.wiigold.com/';
      case Environment.production:
        return 'https://pay.wiigold.com/';
    }
  }

  static const userPrefersNotificationsStorageKey =
      'user_notifications_prefers';

  static const appScheme = 'wiigold';

  static const goldToken = 'WGOLD_B75VRLGX_32XP';
  static const silverToken = 'WSILV_B75VRLGX_C8GK';
  static const copperToken = 'WCOPP_B75VRLGX_3LEC';

  static const ironToken = 'WIRON_B75VRLGX_NKGR';
  static const xautToken = 'XAUT_ETH_TEST5_DS5D';
  static const usdtToken = 'USDT_B75VRLGX_E5OW';


  static bool get inProduction => current == Environment.production;

  static bool get inRenderSemantics => false;
}
