import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? HANDLERS
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/core/services/notification/controller/notification_controller.dart';

//? WIDGETS
// import 'package:wiigold/app/common/widgets/dynamic_app_bar.dart';
// import 'package:wiigold/app/common/widgets/dynamic_divider.dart';
// import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.toHome,
      appBar: DynamicAppBar(
        showLogo: false,
        title: Text(
          "Notificaciones",
          style: textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.main,
          ),
        ),
      ),
      onRefresh: controller.chargeData,
      onReady: controller.initialCharge,
      isContentCentered: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      body: NotificationPage(),
    );
  }
}

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      if (controller.groupedNotifications.isEmpty) {
        return SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    color: AppColors.dark2,
                    size: 80,
                  ),
                ],
              ),
              DynamicDivider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Sin notificaciones aún...",
                      style: textTheme.displaySmall?.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Verás las notificaciones aquí cuando las tengas.",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.dark2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsetsGeometry.zero,
        itemCount: controller.groupedNotifications.length,
        itemBuilder: (context, index) {
          final group = controller.groupedNotifications[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.date.toDateTimeFormat(formatAsHeader: true),
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Divider(color: AppColors.dark2),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsetsGeometry.zero,
                  itemCount: group.notifications.length,
                  itemBuilder: (context, itemIndex) {
                    final notification = group.notifications[itemIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsetsGeometry.zero,
                          dense: true,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    size: 20,
                                    Icons.access_time_rounded,
                                    color: AppColors.main,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    notification.createdAt.toDateTimeFormat(
                                      showDate: false,
                                      showTime: true,
                                    ),
                                    style: textTheme.titleSmall?.copyWith(
                                      color: AppColors.main,
                                    ),
                                  ),
                                ],
                              ),

                              DynamicDivider(height: 10),

                              Text(
                                notification.title,
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppColors.main,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DynamicDivider(height: 10),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.message,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.dark2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DynamicDivider(height: 20),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
