import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wiigold/app/common/global/bindings/global_bindings.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:wiigold/config/environment.dart';
import 'package:wiigold/app/routers/app_pages.dart';
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/theme/Text.dart';
import 'package:wiigold/translations/languages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'Important notifications',
  description: 'Channel for important notifications',
  importance: Importance.max,
);

Future<void> initializeLocalNotifications() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_stat_notification');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showLocalNotification(RemoteMessage message) async {
  final String title = message.notification?.title ?? '';
  final String body = message.notification?.body ?? '';

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_stat_notification',
        color: AppColors.accent,
      );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    title,
    body,
    platformChannelSpecifics,
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await initializeLocalNotifications();
  print("Handling a background message: ${message.messageId}");
  await showLocalNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initializeLocalNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final currentEnv = EnvironmentConfig.current.name;
  print('╔══ ⚪ ═══════════════════════════════════════════');
  print('║ Current environment: $currentEnv');
  print('║');

  final prefs = await SharedPreferences.getInstance();

  final languageCode = prefs.getString('language_code') ?? 'es';
  final countryCode = prefs.getString('country_code') ?? 'ES';

  runApp(MyApp(initialLocale: Locale(languageCode, countryCode)));
}

const String MOBILE_SMALL_BREAKPOINT = "MOBILE_SMALL";
const String MOBILE_BREAKPOINT = "MOBILE";
const String TABLET_BREAKPOINT = "TABLET";
const String DESKTOP_BREAKPOINT = "DESKTOP";
const String FOUR_K_BREAKPOINT = "4K";

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.main,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return GetMaterialApp(
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: mediaQueryData.textScaler.clamp(
              minScaleFactor: 1,
              maxScaleFactor: 1.1,
            ),
          ),
          child: ResponsiveBreakpoints.builder(
            child: Builder(
              builder: (BuildContext newContext) {
                final TextTheme dynamicTextTheme = createAppTextTheme(
                  newContext,
                );
                final ThemeData appTheme = baseTheme.copyWith(
                  textTheme: dynamicTextTheme,
                );

                return Theme(data: appTheme, child: child!);
              },
            ),
            breakpoints: [
              const Breakpoint(
                start: 0,
                end: 325,
                name: MOBILE_SMALL_BREAKPOINT,
              ),
              const Breakpoint(start: 326, end: 450, name: MOBILE_BREAKPOINT),
              const Breakpoint(start: 451, end: 800, name: TABLET_BREAKPOINT),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP_BREAKPOINT),
              const Breakpoint(
                start: 1921,
                end: double.infinity,
                name: FOUR_K_BREAKPOINT,
              ),
            ],
          ),
        );
      },

      translations: Languages(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
      title: "WiiGold",

      initialBinding: GlobalBindings(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
    );
  }
}
