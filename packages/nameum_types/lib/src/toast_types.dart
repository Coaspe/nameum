import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ToastBase {
  const ToastBase({
    required this.message,
    required this.leading,
    this.background = const Color.fromRGBO(0, 0, 0, 0.5),
  }) : trailing = const Icon(
          CupertinoIcons.xmark,
          size: 15,
          color: Colors.white,
        );
  final Text message;
  final Color background;
  final Icon leading;
  final Icon trailing;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is ToastBase &&
          other.message.data == message.data &&
          other.leading == leading &&
          other.trailing == trailing &&
          other.background == background);
}

class SuccessToast extends ToastBase {
  SuccessToast(
      {Color background = const Color.fromRGBO(0, 0, 0, 0.5),
      required String message})
      : super(
            message: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
            background: background,
            leading: const Icon(
              CupertinoIcons.cart_badge_plus,
              size: 30,
              color: Colors.white,
            ));
}

class WarningToast extends ToastBase {
  WarningToast(
      {Color background = const Color.fromRGBO(0, 0, 0, 0.5),
      required String message})
      : super(
            message: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
            background: background,
            leading: const Icon(
              Icons.warning_amber_outlined,
              size: 30,
              color: Colors.white,
            ));
}

class FailToast extends ToastBase {
  FailToast(
      {Color background = const Color.fromRGBO(0, 0, 0, 0.5),
      required String message})
      : super(
            message: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
            background: background,
            leading: const Icon(
              Icons.cancel_sharp,
              size: 30,
              color: Colors.white,
            ));
}

class HeartToast extends ToastBase {
  HeartToast({Color background = const Color.fromRGBO(0, 0, 0, 0.5)})
      : super(
            message: const Text(
              "즐겨찾기가 완료되었습니다.",
              style: TextStyle(color: Colors.white),
            ),
            background: background,
            leading: const Icon(
              CupertinoIcons.heart_fill,
              size: 30,
              color: Colors.white,
            ));
}
