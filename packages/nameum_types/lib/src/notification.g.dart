// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationBase _$NotificationBaseFromJson(Map<String, dynamic> json) =>
    NotificationBase(
      majorType: $enumDecode(_$NotificationTypeEnumMap, json['major_type']),
      message: json['message'] as String,
      time: json['time'] as int,
      table: json['table'] as int,
    );

Map<String, dynamic> _$NotificationBaseToJson(NotificationBase instance) =>
    <String, dynamic>{
      'major_type': _$NotificationTypeEnumMap[instance.majorType]!,
      'message': instance.message,
      'time': instance.time,
      'table': instance.table,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.reserve: 'reserve',
};

ReserveNotification _$ReserveNotificationFromJson(Map<String, dynamic> json) =>
    ReserveNotification(
      storeId: json['store_id'] as String,
      onClickEventType: $enumDecode(
          _$ReserveNotificationTypeEnumMap, json['on_click_event_type']),
      time: json['time'] as int,
      table: json['table'] as int,
    );

Map<String, dynamic> _$ReserveNotificationToJson(
        ReserveNotification instance) =>
    <String, dynamic>{
      'time': instance.time,
      'table': instance.table,
      'store_id': instance.storeId,
      'on_click_event_type':
          _$ReserveNotificationTypeEnumMap[instance.onClickEventType]!,
    };

const _$ReserveNotificationTypeEnumMap = {
  ReserveNotificationType.reserve_accepted: 'reserve_accepted',
  ReserveNotificationType.reserve_rejected: 'reserve_rejected',
  ReserveNotificationType.reserve_complete: 'reserve_complete',
};
