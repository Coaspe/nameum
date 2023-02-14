import 'package:flutter/services.dart';
import 'package:nameum_types/nameum_types.dart';

class PlatformNotification {
  static const notificationChannel = MethodChannel('nameum/notification');

  static Future<void> showNotification(CustomNotificationDetail details) async {
    notificationChannel.invokeMethod("show", details.toJson());
  }
}
