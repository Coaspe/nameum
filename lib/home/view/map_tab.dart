import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:nameum/constant.dart';
import 'package:nameum/home/widgets/map_bottom_sheet.dart';
import 'package:nameum/models/store_in_radius.dart';
import 'package:nameum_types/nameum_types.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition userLocation = const CameraPosition(
      target: LatLng(37.57002838826, 126.97962084516), zoom: 15);
  bool bottomSheetOpened = false;
  bool _fetchLoading = false;
  final List<Marker> _markers = [];
  void setBottomSheetOpend(bool opend) {
    setState(() {
      bottomSheetOpened = opend;
    });
  }

  Map<String, BitmapDescriptor>? mapIcons;
  StoreInRadius? selected;

  CancelableOperation? _fetch;

  @override
  void initState() {
    super.initState();
    registIcons(userLocation);
    getLocation();
  }

  Future<Uint8List> imageToByteData(StoreCategory category) async {
    String path = categoryToPath[category]!;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 50);
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List uint8list =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
    return uint8list;
  }

  void registIcons(CameraPosition position) async {
    Map<String, BitmapDescriptor> icons = {
      'error': BitmapDescriptor.defaultMarker
    };
    for (var element in indsMclsNmToCategory.entries) {
      icons[element.key] =
          BitmapDescriptor.fromBytes(await imageToByteData(element.value));
    }
    setState(() {
      mapIcons = icons;
    });
    getStoreFromAPI(position);
  }

  Future<dynamic> searchStores(Uri url) async {
    Response response = await get(url);
    String resBody = response.body;
    Map<String, dynamic> res = jsonDecode(resBody);
    List<dynamic> items = res['body']['items'];
    List<StoreInRadius> stores =
        items.map(((e) => StoreInRadius.fromJson(e))).toList();
    List<Marker> test = stores
        .map((e) => Marker(
            onTap: () {
              setState(() {
                selected = e;
                bottomSheetOpened = true;
              });
            },
            infoWindow: InfoWindow(title: e.bizesNm),
            markerId: MarkerId('${e.bizesNm}'),
            position: LatLng(e.lat!, e.lon!),
            icon: mapIcons![e.indsMclsCd] ?? mapIcons!['Q01']!))
        .toList();
    setState(() {
      _markers.addAll(test);
    });
  }

  void getStoreFromAPI(CameraPosition position) async {
    setState(() {
      if (!_fetchLoading) {
        _fetchLoading = true;
      }
    });
    final params = {
      'serviceKey': dotenv.env['STORE_DECODED'],
      'pageNo': '1',
      'numOfRows': '30',
      'radius': '500',
      'cx': '${position.target.longitude}',
      'cy': '${position.target.latitude}',
      'type': 'json',
      'indsLclsCd': 'Q',
    };
    Uri query = Uri.http(
        "apis.data.go.kr", "/B553077/api/open/sdsc2/storeListInRadius", params);

    if (_fetch != null) _fetch!.cancel();
    _fetch = CancelableOperation.fromFuture(
      searchStores(query).then((_) {
        if (_fetchLoading) {
          setState(() {
            _fetchLoading = false;
          });
        }
      }),
      onCancel: () {
        print('Cancel');
      },
    );
  }

  void getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {}
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {}
    }

    locationData = await location.getLocation();
    setState(() {
      // 종로
      userLocation =
          const CameraPosition(target: LatLng(37.541, 126.986), zoom: 14);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: mapIcons == null
                      ? const Center(
                          child: Text("Loading..."),
                        )
                      : GoogleMap(
                          onCameraMove: (position) {
                            setState(() {
                              userLocation = position;
                            });
                          },
                          onCameraIdle: () {
                            getStoreFromAPI(userLocation);
                          },
                          markers: Set.from(_markers),
                          mapType: MapType.normal,
                          initialCameraPosition: userLocation,
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        )),
            ],
          ),
          MapBottomSheet(
              bottomSheetOpened: bottomSheetOpened,
              setBottomSheetOpend: setBottomSheetOpend),
          _fetchLoading
              ? Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive()),
                          SizedBox(
                            width: 10,
                          ),
                          Text("로딩 중")
                        ]),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
