import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nameum_types/src/notification.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends Equatable {
  // Email is an unique key.
  const User({
    this.bio = "",
    this.password,
    this.signupType = SignupType.google,
    this.bookMark = const [],
    required this.email,
    this.myStore = const [],
    required this.name,
    this.notification = const {},
    this.reserveStore = const {},
    this.profileImg = '',
    required this.userId,
  });

  /// Type of sign up (e.g. Goolge Oauth, email-password etc...)
  final SignupType signupType;

  /// Exists if signupType is SignupType.email
  final String? password;

  /// Biography of user
  final String bio;

  /// User’s favorite stores list
  ///
  /// List of firebase document ids
  final List<String> bookMark;

  /// User’s e-mail
  ///
  /// Unique key
  final String email;

  /// List of stores that user own
  ///
  /// List of firebase document ids
  final List<String> myStore;

  /// User’s display name
  final String name;

  /// Map of Pushed notifications
  ///
  /// Key is time in unix timestamp form
  final Map<int, NotificationBase> notification;

  /// User’s Profile image in form of firestorage access token
  final String profileImg;

  /// List of stores that user reserved
  ///
  /// Key is store’s id in firestore document id form
  final Map<String, ReserveState> reserveStore;

  /// User’s firestore document id
  final String userId;

  User newUser({
    String? bio,
    List<String>? bookMark,
    String? email,
    List<String>? myStore,
    String? name,
    Map<int, NotificationBase>? notification,
    String? profileImg,
    Map<String, ReserveState>? reserveStore,
    String? userId,
  }) {
    User _user = User(
      bio: bio ?? this.bio,
      bookMark: bookMark ?? this.bookMark,
      email: email ?? this.email,
      myStore: myStore ?? this.myStore,
      name: name ?? this.name,
      notification: notification ?? this.notification,
      profileImg: profileImg ?? this.profileImg,
      reserveStore: reserveStore ?? this.reserveStore,
      userId: userId ?? this.userId,
    );
    return _user;
  }

  /// Empty user which represents an unauthenticated user.
  static const empty = User(email: '', userId: '', name: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [name, email, userId];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum ReserveState {
  pending,
  accepted,
  rejected,
  complete;

  String convertToString() {
    switch (this) {
      case ReserveState.pending:
        return "접수 대기";
      case ReserveState.accepted:
        return "예약 완료";
      case ReserveState.accepted:
        return "준비 완료";
      case ReserveState.rejected:
        return "예약 거절";
      default:
        return "Error";
    }
  }
}

enum SignupType { google, email, kakao }
