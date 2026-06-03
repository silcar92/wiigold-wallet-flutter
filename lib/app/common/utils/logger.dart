import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ControlledReportException implements Exception {
  final String message;

  ControlledReportException(this.message);

  @override
  String toString() => 'ControlledReport: $message';
}

class Logger {
  final String module;

  Logger({required this.module});

  void log({
    bool enable = true,
    String? label = '',
    String? content,
    Map<String, dynamic>? customData,
  }) {
    if (!kDebugMode || !enable) return;

    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
    print('╔══ 🔵 [LOG] ════════════════════════════════════════════');
    print('║ [$timestamp] [$module]: $label');
    if (content != null) {
      print('║ $content');
    }
    if (customData != null) {
      customData.forEach((key, value) {
        print('║ - $key: $value');
      });
    }
    print('╚════════════════════════════════════════════════════════');
  }

  Future<void> crashlyticsError({
    required Object error,
    required StackTrace stackTrace,
    required String tag,
    String? reason,
    Map<String, dynamic>? customData,
    bool forceSendInDebug = false,
  }) async {
    final fullContext = '$module:$tag';

    if (kDebugMode && !forceSendInDebug) {
      final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
      print('╔══ 🔴 [ERROR] ═════════════════════════════════════════');
      print('║ [$timestamp] CONTEXT: $fullContext');
      print('║ Error: $error');
      if (reason != null) {
        print('║ Reason: $reason');
      }
      if (customData != null) {
        print('║ Custom Data:');
        customData.forEach((key, value) => print('║ - $key: $value'));
      }
      print('╟── Stack Trace ────────────────────────────────────────');
      print(stackTrace);
      print('╚═══════════════════════════════════════════════════════');
      return;
    }

    try {
      await FirebaseCrashlytics.instance.setCustomKey('module', module);
      await FirebaseCrashlytics.instance.setCustomKey('tag', tag);
      if (customData != null) {
        customData.forEach((key, value) {
          FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
        });
      }

      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason ?? 'Error capturado en $fullContext',
        fatal: false,
      );
      if (kDebugMode)
        print('☑️ Crashlytics error for tag [$tag] sent to be processed.');
    } catch (e) {
      print('🔴 Error al intentar reportar a Crashlytics: $e');
    }
  }

  Future<void> crashlyticsReport({
    required String tag,
    required String reportMessage,
    Map<String, dynamic>? customData,
    bool forceSendInDebug = false,
  }) async {
    final fullContext = '$module:$tag';

    if (kDebugMode && !forceSendInDebug) {
      final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
      print('╔══ 🟡 [REPORT] ═══════════════════════════════════════');
      print('║ [$timestamp] CONTEXT: $fullContext');
      print('║ Message: $reportMessage');
      if (customData != null) {
        print('║ Custom Data:');
        customData.forEach((key, value) => print('║  - $key: $value'));
      }
      print('╚══════════════════════════════════════════════════════');
      return;
    }

    try {
      await FirebaseCrashlytics.instance.setCustomKey('module', module);
      await FirebaseCrashlytics.instance.setCustomKey('tag', tag);
      await FirebaseCrashlytics.instance.setCustomKey(
        'report_type',
        'controlled_failure',
      );
      if (customData != null) {
        customData.forEach((key, value) {
          FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
        });
      }

      final reportException = ControlledReportException(reportMessage);

      await FirebaseCrashlytics.instance.recordError(
        reportException,
        StackTrace.current,
        reason: 'Controlled failure report from $fullContext',
        fatal: false,
      );
      if (kDebugMode)
        print('☑️ Crashlytics report for tag [$tag] sent to be processed.');
    } catch (e) {
      print('🔴 Error al intentar generar un reporte para Crashlytics: $e');
    }
  }
}
