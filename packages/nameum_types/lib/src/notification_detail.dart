import '../nameum_types.dart';

/// Abstract class that contains several base properties for platform specified notification detail classes
abstract class CustomNotificationDetail {
  CustomNotificationDetail({
    required this.notificationInfo,
    this.title = "남음",
  }) : body = notificationInfo.message;

  final String title;
  final String body;
  final NotificationBase notificationInfo;

  Map<String, dynamic> toJson();
}

class AndroidNotificationDetails extends CustomNotificationDetail {
  AndroidNotificationDetails(
      {required super.notificationInfo,
      this.channelId = "Default channlId",
      this.channelName = "Default channelName",
      this.channelDescription = "Default channelDescription",
      this.importance = 4,
      this.id = 0,
      super.title,
      this.icon = "@mipmap/splash"});

  final int id;
  final String icon;
  final String channelId;
  final String channelName;
  final String channelDescription;
  final int importance;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'notification_info': notificationInfo.toJson(),
        'id': id,
        'title': title,
        'icon': icon,
        'channel_id': channelId,
        'channel_name': channelName,
        'channel_description': channelDescription,
        'importance': importance,
        'body': body,
      };
}

enum DarwinNotificationSound {
  soundDefault,
  soundCritical,
  soundRingtone;

  // soundDefault -> default, soundCritical -> critical, soundRingtone -> ringtone
  String get convertToSwift => this.toString().split("sound")[1].toLowerCase();
}

class DarwinNotifiactionDetails extends CustomNotificationDetail {
  DarwinNotifiactionDetails(
      {required super.notificationInfo,
      super.title,
      this.sound = DarwinNotificationSound.soundDefault,
      this.summaryArgument,
      this.summaryArgumentCount,
      this.subtitle = ""});

  final String subtitle;
  final DarwinNotificationSound sound;
  final int? summaryArgumentCount;
  final String? summaryArgument;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'notification_info': notificationInfo.toJson(),
        'title': title,
        'body': body,
        'subtitle': subtitle,
        'sound': sound.convertToSwift,
        'summaryArgumentCount': summaryArgumentCount,
        'summaryArgument': summaryArgument
      };
}
