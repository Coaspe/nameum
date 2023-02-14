import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationBase {
  const NotificationBase(
      {required this.majorType,
      required this.message,
      required this.time,
      required this.table});
  final NotificationType majorType;
  final String message;
  final int time;
  final int table;

  factory NotificationBase.fromJson(Map<String, dynamic> json) {
    switch (json["major_type"]) {
      case "reserve":
        return ReserveNotification.fromJson(json);
      default:
        return ReserveNotification.fromJson(json);
    }
  }
  Map<String, dynamic> toJson() => Map();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReserveNotification extends NotificationBase {
  ReserveNotification(
      {required this.storeId,
      required this.onClickEventType,
      required int time,
      required int table})
      : super(
            majorType: NotificationType.reserve,
            message: ReserveNotificationMessageMap[onClickEventType]!,
            time: time,
            table: table);

  final String storeId;
  final ReserveNotificationType onClickEventType;

  factory ReserveNotification.fromJson(Map<String, dynamic> json) =>
      _$ReserveNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'time': time,
      'store_id': storeId,
      'table': table,
      'message': message,
      'on_click_event_type': onClickEventType.toString().split(".")[1],
      'major_type': majorType.toString().split(".")[1]
    };
  }
}

enum NotificationType { reserve }

enum ReserveNotificationType {
  reserve_accepted,
  reserve_rejected,
  reserve_complete,
}

const Map<ReserveNotificationType, String> ReserveNotificationMessageMap = {
  ReserveNotificationType.reserve_accepted: "예약이 접수되었습니다.",
  ReserveNotificationType.reserve_rejected: "예약이 거절되었습니다.",
  ReserveNotificationType.reserve_complete: "자리가 준비되었습니다. 가게에 입장해주세요!"
};

const Map<String, String> NotificationToMethodCall = {
  "reserve_accepted": "RESERVE_ACCEPTED_NOTIFICATION_CLICKED",
  "reserve_rejected": "RESERVE_REJECTED_NOTIFICATION_CLICKED",
  "reserve_complete": "RESERVE_COMPLETE_NOTIFICATION_CLICKED"
};

extension onClickEventType on ReserveNotificationType {
  String toOnClickEventType() {
    return (this.toString().split(".")[1] + "_NOTIFICATION_CLICKED")
        .toUpperCase();
  }
}
