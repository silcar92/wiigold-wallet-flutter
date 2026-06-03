import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/data/storage/token_storage.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/config/environment.dart';

class DeepLinkController extends GetxController {
  final TokenStorage _tokenStorage = TokenStorage();
  final AppLinks _appLinks = AppLinks();
  final Logger _logger = Logger(module: 'DeepLinkController');

  bool _isProcessingLink = false;
  StreamSubscription<Uri>? _linkSubscription;

  static const String EXPECTED_SCHEME = EnvironmentConfig.appScheme;
  static final String EXPECTED_UNIVERSAL_HOST = Uri.parse(
    EnvironmentConfig.refUrl,
  ).host;
  static const String ACTION_PROCESS_PAYMENT = 'request-link';

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    bool initialLinkHandled = false;

    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _logger.log(
          label: 'Initial Link Received and Processed',
          content: initialUri.toString(),
        );
        _processUri(initialUri);
        initialLinkHandled = true;
      }
    } catch (e, stackTrace) {
      _logger.crashlyticsError(
        error: e,
        stackTrace: stackTrace,
        tag: 'init_initial_link_error',
        reason: 'Failed to fetch the initial app link.',
      );
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _logger.log(label: 'Link Received Via Stream', content: uri.toString());

        if (initialLinkHandled) {
          _logger.log(
            label: 'Ignoring Stream Link',
            content:
                'Initial link was already handled. Ignoring this stream event.',
          );

          initialLinkHandled = false;
          return;
        }

        _processUri(uri);
      },
      onError: (err, stackTrace) {
        _logger.crashlyticsError(
          error: err,
          stackTrace: stackTrace,
          tag: 'stream_link_error',
          reason: 'An error occurred in the app link stream.',
        );
      },
    );
  }

  void _processUri(Uri uri) {
    _logger.log(
      label: 'Processing URI',
      content: 'Attempting to process: ${uri.toString()}',
    );

    if (_tokenStorage.getCurrentToken() == '') {
      _logger.log(label: 'Processing URI', content: 'Ignoring: No token.');
      return;
    }

    if (_isProcessingLink) {
      _logger.log(
        label: 'Ignoring Link',
        content: 'A deep link flow is already in progress.',
        customData: {'ignored_uri': uri.toString()},
      );
      return;
    }

    if (uri.scheme == 'https' || uri.scheme == 'http') {
      _logger.log(
        label: "uri.scheme == 'https' || uri.scheme == 'http'",
        content: "${uri.scheme == 'https' || uri.scheme == 'http'}",
      );

      if (uri.host == EXPECTED_UNIVERSAL_HOST) {
        if (uri.pathSegments.isNotEmpty &&
            uri.pathSegments.first == ACTION_PROCESS_PAYMENT) {
          _isProcessingLink = true;
          _navigateToPaymentScreen(uri);
        } else {
          _logger.crashlyticsReport(
            tag: 'unrecognized_path_for_universal_link',
            reportMessage:
                'Universal Link received for host "$EXPECTED_UNIVERSAL_HOST", but path is not recognized.',
            customData: {
              'received_path': uri.path,
              'expected_action': ACTION_PROCESS_PAYMENT,
              'full_uri': uri.toString(),
            },
          );
        }
      } else {
        _logger.log(
          label: 'Ignoring HTTPS link',
          content: 'Received a link from an unexpected host.',
          customData: {
            'received_host': uri.host,
            'expected_host': EXPECTED_UNIVERSAL_HOST,
          },
        );
      }
    } else if (uri.scheme == EXPECTED_SCHEME) {
      _logger.log(
        label: "case uri.scheme == EXPECTED_SCHEME",
        content: "${uri.scheme == EXPECTED_SCHEME}",
      );

      if (uri.host == ACTION_PROCESS_PAYMENT) {
        _isProcessingLink = true;
        _navigateToPaymentScreen(uri);
      } else {
        _logger.crashlyticsReport(
          tag: 'unrecognized_host_for_custom_scheme',
          reportMessage:
              'Scheme "$EXPECTED_SCHEME" received, but host is not recognized.',
          customData: {
            'received_host': uri.host,
            'expected_host': ACTION_PROCESS_PAYMENT,
            'full_uri': uri.toString(),
          },
        );
      }
    } else {
      _logger.crashlyticsReport(
        tag: 'unexpected_scheme',
        reportMessage: 'Received URI with an unexpected scheme.',
        customData: {
          'received_scheme': uri.scheme,
          'expected_scheme': '$EXPECTED_SCHEME or https',
          'full_uri': uri.toString(),
        },
      );
    }
  }

  void _navigateToPaymentScreen(Uri data) {
    _logger.log(
      label: 'Navigation Triggered',
      content: 'Attempting to navigate to payment screen.',
      customData: {'data': data.toString()},
    );

    final Map<String, dynamic> decodedData = data.toString().decodeUriParams();

    Get.toNamed(
      AppRoutes.SEND,
      arguments: {"viewMode": 'ofRequest', "data": decodedData},
    );
  }

  void completeDeepLinkFlow() {
    _logger.log(
      label: 'Flow Completed',
      content: 'Deep link processing flag has been reset.',
    );
    _isProcessingLink = false;
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    _logger.log(
      label: 'Controller Closed',
      content: 'Link subscription cancelled.',
    );
    super.onClose();
  }
}
