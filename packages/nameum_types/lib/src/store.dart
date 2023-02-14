import 'package:json_annotation/json_annotation.dart';
import 'package:nameum_types/nameum_types.dart';

part 'store.g.dart';

/// Comprehensive information of store
@JsonSerializable(fieldRename: FieldRename.snake)
class Store {
  Store(
      {this.storeId = "",
      required this.address,
      required this.storeName,
      required this.tables,
      required this.owner,
      this.thumbnail = "",
      this.mainImage = "",
      this.oneLineDesc = "",
      this.number = "",
      this.reserveClients = const {},
      this.category = const [],
      this.detailDesc = "",
      this.managers = const []});

  // Category of store
  List<StoreCategory> category;

  /// Detail description of store
  String detailDesc;

  /// Image in firestore access token form that to be seen when users tap store list row.
  String mainImage;

  /// Variables representing store managers' emails
  List<String> managers;

  /// Phone number of store
  String number;

  /// Concise description of store
  String oneLineDesc;

  /// E-mail of owner
  String owner;

  /// Represents who reserved this store
  ///
  /// Key of Map is user’s e-mail
  Map<String, ReserveInfo> reserveClients;

  /// Unique string id for store  that made by firestore
  String storeId;

  /// Name of store
  String storeName;

  // Address of store
  Address address;

  /// Represents total numbers of tables
  ///
  /// e.g. {1:1, 2:1, 3:4, 4: 5, 5: 4, 6: 1} means it has one sigle table and double table, four three-seater tables, five four-seater tables, four five-seater tables and one table for more than six people
  Map<int, int> tables;

  /// Thumbnail in Firestore access token form of store
  String thumbnail;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

enum StoreCategory {
  pub,
  cafe,
  restaurant,
  bar,
  chicken,
  buffet,
  chinese,
  fastfood,
  other,
  japanese,
  snack,
  delivery,
  fusion,
  bread,
  korean,
  westren,
  error
}
