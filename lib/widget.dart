import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  const PlatformWidget(
      {Key? key, required this.androidBuilder, required this.iosBuilder})
      : super(key: key);
  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;
  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

Text mainCarouselTitleText(String text) => Text(text,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold));
Row mainCarouselInfoText(String text, int idx) {
  IconData i = idx == 0
      ? Icons.person
      : idx == 1
          ? Icons.directions_walk
          : Icons.timelapse;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        i,
        size: 14,
      ),
      Text(text,
          style: const TextStyle(
              fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w200))
    ],
  );
}
