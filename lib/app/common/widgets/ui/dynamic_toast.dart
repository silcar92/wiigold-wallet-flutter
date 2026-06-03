import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicToast {
  static OverlayEntry? _currentEntry;

  static void _showSnackbar({
    required String title,
    String? description,
    required IconData iconData,
    required Color backgroundColor,
    Color iconColor = Colors.white,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration? duration,
    TextButton? mainButton,
  }) {
    try {
      _currentEntry?.remove();
    } catch (_) {}
    _currentEntry = null;

    final toastDuration = duration ?? const Duration(seconds: 4);
    final isBottom = position == SnackPosition.BOTTOM;

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        title: title,
        description: description,
        iconData: iconData,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        isBottom: isBottom,
        duration: toastDuration,
        mainButton: mainButton,
        onDismissed: () {
          try {
            entry?.remove();
          } catch (_) {}
          if (_currentEntry == entry) {
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final ctx = Get.overlayContext;
        if (ctx != null && ctx.mounted) {
          Overlay.of(ctx).insert(entry!);
        }
      } catch (_) {}
    });
  }

  static void success({
    required String title,
    String? description,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration? duration,
  }) {
    _showSnackbar(
      title: title,
      description: description,
      iconData: Icons.check_circle_outline,
      backgroundColor: AppColors.success,
      position: position,
      duration: duration,
    );
  }

  static void error({
    required String title,
    String? description,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration? duration,
    TextButton? mainButton,
  }) {
    _showSnackbar(
      title: title,
      description: description,
      iconData: Icons.error_outline,
      backgroundColor: AppColors.failure,
      position: position,
      duration: duration,
      mainButton: mainButton,
    );
  }

  static void warning({
    required String title,
    String? description,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration? duration,
  }) {
    _showSnackbar(
      title: title,
      description: description,
      iconData: Icons.warning_amber_rounded,
      backgroundColor: AppColors.accent,
      position: position,
      duration: duration,
    );
  }

  static void info({
    required String title,
    String? description,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration? duration,
  }) {
    _showSnackbar(
      title: title,
      description: description,
      iconData: Icons.info_outline,
      backgroundColor: Colors.blue.shade700,
      position: position,
      duration: duration,
    );
  }

  static void legacyError({String? label}) {
    error(title: 'form.invalidForm_title'.tr, description: label);
  }
}

class _ToastWidget extends StatefulWidget {
  final String title;
  final String? description;
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final bool isBottom;
  final Duration duration;
  final TextButton? mainButton;
  final VoidCallback onDismissed;

  const _ToastWidget({
    required this.title,
    this.description,
    required this.iconData,
    required this.backgroundColor,
    required this.iconColor,
    required this.isBottom,
    required this.duration,
    this.mainButton,
    required this.onDismissed,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnim = Tween<Offset>(
      begin: Offset(0, widget.isBottom ? 0.4 : -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    ));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Align(
          alignment:
              widget.isBottom ? Alignment.bottomCenter : Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              widget.isBottom ? 0 : bottomPadding + 16,
              16,
              widget.isBottom ? bottomPadding + 16 : 0,
            ),
            child: Material(
              elevation: 8,
              shadowColor: widget.backgroundColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              color: widget.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.iconData, color: widget.iconColor, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: textTheme.labelLarge?.copyWith(
                              color: AppColors.light,
                            ),
                          ),
                          if (widget.description != null &&
                              widget.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                widget.description!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.light.withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.mainButton != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: widget.mainButton,
                      ),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.light.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
