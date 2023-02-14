// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      bio: json['bio'] as String? ?? "",
      password: json['password'] as String?,
      signupType:
          $enumDecodeNullable(_$SignupTypeEnumMap, json['signup_type']) ??
              SignupType.google,
      bookMark: (json['book_mark'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      email: json['email'] as String,
      myStore: (json['my_store'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String,
      notification: (json['notification'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k),
                NotificationBase.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      reserveStore: (json['reserve_store'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, $enumDecode(_$ReserveStateEnumMap, e)),
          ) ??
          const {},
      profileImg: json['profile_img'] as String? ?? '',
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'signup_type': _$SignupTypeEnumMap[instance.signupType]!,
      'password': instance.password,
      'bio': instance.bio,
      'book_mark': instance.bookMark,
      'email': instance.email,
      'my_store': instance.myStore,
      'name': instance.name,
      'notification':
          instance.notification.map((k, e) => MapEntry(k.toString(), e)),
      'profile_img': instance.profileImg,
      'reserve_store': instance.reserveStore
          .map((k, e) => MapEntry(k, _$ReserveStateEnumMap[e]!)),
      'user_id': instance.userId,
    };

const _$SignupTypeEnumMap = {
  SignupType.google: 'google',
  SignupType.email: 'email',
  SignupType.kakao: 'kakao',
};

const _$ReserveStateEnumMap = {
  ReserveState.pending: 'pending',
  ReserveState.accepted: 'accepted',
  ReserveState.rejected: 'rejected',
  ReserveState.complete: 'complete',
};
