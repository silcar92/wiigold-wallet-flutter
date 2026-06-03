import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/theme/Colors.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const DocumentViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() { _isLoading = true; _hasError = false; }),
        onPageFinished: (_) => setState(() => _isLoading = false),
        onWebResourceError: (_) => setState(() { _isLoading = false; _hasError = true; }),
      ))
      ..loadRequest(Uri.parse(_viewerUrl(widget.url)));
  }

  String _viewerUrl(String url) {
    final isPdf = url.toLowerCase().contains('.pdf');
    if (isPdf) {
      return 'https://docs.google.com/viewer?url=${Uri.encodeComponent(url)}&embedded=true';
    }
    return url;
  }

  Future<void> _openExternal() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appAltBackground,
      appBar: DynamicAppBar(
        showAutoBackButton: true,
        showLogo: false,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Stack(
        children: [
          if (!_hasError)
            WebViewWidget(controller: _controller),

          if (_isLoading && !_hasError)
            const Center(
              child: CircularProgressIndicator(color: AppColors.main),
            ),

          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.dark2),
                    Text(
                      'document_viewer.load_error'.tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.dark2,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _openExternal,
                      icon: const Icon(Icons.open_in_browser),
                      label: Text('document_viewer.open_external'.tr),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
