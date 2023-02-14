// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserve_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReserveInfo _$ReserveInfoFromJson(Map<String, dynamic> json) => ReserveInfo(
      time: json['time'] as int,
      state: $enumDecodeNullable(_$ReserveStateEnumMap, json['state']) ??
          ReserveState.pending,
      message: json['message'] as String? ?? "",
      table: json['table'] as int,
    );

Map<String, dynamic> _$ReserveInfoToJson(ReserveInfo instance) =>
    <String, dynamic>{
      'time': instance.time,
      'state': _$ReserveStateEnumMap[instance.state]!,
      'message': instance.message,
      'table': instance.table,
    };

const _$ReserveStateEnumMap = {
  ReserveState.pending: 'pending',
  ReserveState.accepted: 'accepted',
  ReserveState.rejected: 'rejected',
  ReserveState.complete: 'complete',
};
