// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      storeId: json['store_id'] as String? ?? "",
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      storeName: json['store_name'] as String,
      tables: (json['tables'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as int),
      ),
      owner: json['owner'] as String,
      thumbnail: json['thumbnail'] as String? ?? "",
      mainImage: json['main_image'] as String? ?? "",
      oneLineDesc: json['one_line_desc'] as String? ?? "",
      number: json['number'] as String? ?? "",
      reserveClients: (json['reserve_clients'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, ReserveInfo.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      category: (json['category'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StoreCategoryEnumMap, e))
              .toList() ??
          const [],
      detailDesc: json['detail_desc'] as String? ?? "",
      managers: (json['managers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'category':
          instance.category.map((e) => _$StoreCategoryEnumMap[e]!).toList(),
      'detail_desc': instance.detailDesc,
      'main_image': instance.mainImage,
      'managers': instance.managers,
      'number': instance.number,
      'one_line_desc': instance.oneLineDesc,
      'owner': instance.owner,
      'reserve_clients': instance.reserveClients,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'address': instance.address,
      'tables': instance.tables.map((k, e) => MapEntry(k.toString(), e)),
      'thumbnail': instance.thumbnail,
    };

const _$StoreCategoryEnumMap = {
  StoreCategory.pub: 'pub',
  StoreCategory.cafe: 'cafe',
  StoreCategory.restaurant: 'restaurant',
  StoreCategory.bar: 'bar',
  StoreCategory.chicken: 'chicken',
  StoreCategory.buffet: 'buffet',
  StoreCategory.chinese: 'chinese',
  StoreCategory.fastfood: 'fastfood',
  StoreCategory.other: 'other',
  StoreCategory.japanese: 'japanese',
  StoreCategory.snack: 'snack',
  StoreCategory.delivery: 'delivery',
  StoreCategory.fusion: 'fusion',
  StoreCategory.bread: 'bread',
  StoreCategory.korean: 'korean',
  StoreCategory.westren: 'westren',
  StoreCategory.error: 'error',
};
