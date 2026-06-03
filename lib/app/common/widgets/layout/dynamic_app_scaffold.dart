import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_dialog.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/modules/auth/controllers/auth_controller.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

enum BackButtonBehavior {
  standard,
  block,
  logout,
  closeApp,
  toHome,
  toLogin,
  confirmBack,
  custom,
}

class DynamicAppScaffold extends StatefulWidget {
  final GetxController? pageController;
  final RxBool? isLoading;
  final RxBool? showLoader;

  final BackButtonBehavior backButtonBehavior;
  final VoidCallback? onCustomBack;

  final Widget body;
  final EdgeInsetsGeometry contentPadding;
  final bool isContentCentered;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onReady;

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Color backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomInset;

  const DynamicAppScaffold({
    super.key,
    this.pageController,
    this.isLoading,
    this.showLoader,
    this.backButtonBehavior = BackButtonBehavior.standard,
    this.onCustomBack,
    required this.body,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 20.0,
    ),
    this.isContentCentered = true,
    this.onRefresh,
    this.onReady,
    this.scaffoldKey,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.backgroundColor = AppColors.appAltBackground,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset,
  });

  @override
  State<DynamicAppScaffold> createState() => _DynamicAppScaffoldState();
}

class _DynamicAppScaffoldState extends State<DynamicAppScaffold> {
  final Logger logger = Logger(module: "DynamicAppScaffold");

  late final Widget _stableBody;
  late final ScrollController _scrollController;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Worker? _loadingWorker;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    if (widget.pageController != null) {
      _stableBody = GetX<GetxController>(
        init: widget.pageController,
        builder: (_) => widget.body,
      );
    } else {
      _stableBody = widget.body;
    }

    if (widget.onReady != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onReady!();
      });
    }

    if (widget.isLoading != null && widget.showLoader != null) {
      _loadingWorker = ever(widget.isLoading!, (bool isLoading) {
        final bool shouldShowNativeLoader =
            isLoading && !(widget.showLoader!.value);

        if (shouldShowNativeLoader) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _refreshIndicatorKey.currentState?.show();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _loadingWorker?.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_scrollController.position.pixels <= 0) {
      if (widget.onRefresh != null) {
        await widget.onRefresh!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool showLoading = widget.isLoading?.value ?? false;
      final bool displayCustomLoader = widget.showLoader?.value ?? true;

      final bool isBlockingLoad = showLoading && displayCustomLoader;

      final Widget internalBodyLayout = LayoutBuilder(
        builder: (context, constraints) {
          final scrollableContent = SingleChildScrollView(
            controller: _scrollController,
            physics: widget.onRefresh != null
                ? const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  )
                : const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(

                padding: widget.contentPadding,
                child: !widget.isContentCentered
                    ? _stableBody
                    : Center(
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            _stableBody,
                            const DynamicDivider(height: 75),
                          ],
                        ),
                      ),
              ),
            ),
          );

          if (widget.onRefresh != null) {
            if (displayCustomLoader) {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppColors.main,
                backgroundColor: AppColors.light2,
                elevation: 0,
                strokeWidth: 0.0,
                displacement: 100.0,
                child: scrollableContent,
              );
            } else {
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                color: AppColors.main,
                backgroundColor: AppColors.light,
                child: scrollableContent,
              );
            }
          }

          return scrollableContent;
        },
      );

      final Widget scaffoldWidget = Scaffold(
        key: widget.scaffoldKey,
        appBar: widget.appBar,
        body: internalBodyLayout,
        bottomNavigationBar: widget.bottomNavigationBar,
        drawer: widget.drawer,
        backgroundColor: widget.backgroundColor,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      );

      return PopScope(
        canPop:
            !isBlockingLoad &&
            widget.backButtonBehavior == BackButtonBehavior.standard,
        onPopInvoked: (didPop) {
          if (didPop || isBlockingLoad) return;

          switch (widget.backButtonBehavior) {
            case BackButtonBehavior.standard:
              break;
            case BackButtonBehavior.block:
              break;
            case BackButtonBehavior.custom:
              widget.onCustomBack?.call();
              break;
            default:
              _handleConfirmationDialog(context, widget.backButtonBehavior);
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: isBlockingLoad
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: displayCustomLoader
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    scaffoldWidget,
                    if (showLoading) const DynamicLoader(),
                  ],
                )
              : scaffoldWidget,
        ),
      );
    });
  }

  void _handleConfirmationDialog(
    BuildContext context,
    BackButtonBehavior behavior,
  ) {
    switch (behavior) {
      case BackButtonBehavior.closeApp:
        _exitDialog(context);
        break;
      case BackButtonBehavior.toHome:
        _toHomeDialog(context);
        break;
      case BackButtonBehavior.toLogin:
        _toLoginDialog(context);
        break;
      case BackButtonBehavior.confirmBack:
        _toConfirmarDialog(context);
        break;
      case BackButtonBehavior.logout:
        _logoutDialog(context);
        break;
      default:
        break;
    }
  }

  Future<void> _logoutDialog(BuildContext context) async {
    return DynamicDialog(
      context: context,
      title: 'widgets.dynamic_app_scaffold.logout_title'.tr,
      message: 'widgets.dynamic_app_scaffold.logout_message'.tr,
      onConfirm: () {
        try {
          Get.find<AuthController>().logout();
        } catch (e) {
          Get.put(AuthController()).logout();
        }
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> _exitDialog(BuildContext context) async {
    return DynamicDialog(
      context: context,
      title: 'widgets.dynamic_app_scaffold.exit_title'.tr,
      message: 'widgets.dynamic_app_scaffold.exit_message'.tr,
      confirmButtonColor: AppColors.failure,
      cancelButtonColor: AppColors.dark3,
      onConfirm: () => exit(0),
      onCancel: () => Get.back(),
    );
  }

  Future<void> _toConfirmarDialog(BuildContext context) async {
    return DynamicDialog(
      context: context,
      title: 'widgets.dynamic_app_scaffold.confirm_back_title'.tr,
      message: 'widgets.dynamic_app_scaffold.confirm_back_message'.tr,
      onConfirm: () {
        Get.back();
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> _toHomeDialog(BuildContext context) async {
    return DynamicDialog(
      context: context,
      title: 'widgets.dynamic_app_scaffold.go_back_title'.tr,
      message: 'widgets.dynamic_app_scaffold.to_home_message'.tr,
      confirmButtonText: 'widgets.dynamic_app_scaffold.go_back_button'.tr,
      onConfirm: () async {
        Get.find<HomeController>().chargeData();
        Get.offAllNamed(AppRoutes.HOME);
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> _toLoginDialog(BuildContext context) async {
    return DynamicDialog(
      context: context,
      title: 'widgets.dynamic_app_scaffold.go_back_title'.tr,
      message: 'widgets.dynamic_app_scaffold.to_login_message'.tr,
      confirmButtonText: 'widgets.dynamic_app_scaffold.go_back_button'.tr,
      onConfirm: () => Get.offAllNamed(AppRoutes.LOGIN),
      onCancel: () => Get.back(),
    );
  }
}
