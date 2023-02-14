import 'package:json_annotation/json_annotation.dart';
import 'package:nameum_types/nameum_types.dart';

part 'reserve_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReserveInfo {
  ReserveInfo(
      {required this.time,
      this.state = ReserveState.pending,
      this.message = "",
      required this.table});
  int time;
  ReserveState state;
  String message;
  int table;
  factory ReserveInfo.fromJson(Map<String, dynamic> json) =>
      _$ReserveInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ReserveInfoToJson(this);
}
