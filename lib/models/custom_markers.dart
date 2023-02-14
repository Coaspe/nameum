import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nameum_types/nameum_types.dart';

class CustomMarker extends Marker {
  final StoreCategory iconType;
  final String storeID;

  const CustomMarker(
      {required super.markerId,
      required this.iconType,
      required this.storeID,
      super.alpha = 1.0,
      super.anchor = const Offset(0.5, 1.0),
      super.consumeTapEvents = false,
      super.draggable = false,
      super.flat = false,
      super.infoWindow = InfoWindow.noText,
      super.position = const LatLng(0.0, 0.0),
      super.rotation = 0.0,
      super.visible = true,
      super.zIndex = 0.0,
      super.onTap,
      super.onDrag,
      super.onDragStart,
      super.onDragEnd,
      super.icon});
}
