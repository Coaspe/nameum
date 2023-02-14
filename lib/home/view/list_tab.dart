import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nameum/constant.dart';
import 'package:nameum/home/home.dart';
import 'package:nameum_types/nameum_types.dart';

import '../../notification_api/platform_notification.dart';

Expanded listOfStores(List<Store> list) {
  return Expanded(
    child: ListView(
      children: list
          .map((e) =>
              StoreListWidgets(type: StoreWidgetBuild.popularListItem, info: e))
          .toList(),
    ),
  );
}

class HomeList extends StatefulWidget {
  const HomeList({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey formKey;
  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  String name = "";
  final PageController pageController = PageController();
  List<Store>? _storeList;

  @override
  void initState() {
    super.initState();
    FireStoreMethods.getAllStores().then((value) {
      setState(() {
        _storeList = value;
      });
    });
  }

  @override
  void dispose() {
    // removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Form(
                        key: widget.formKey,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          width: 250,
                          height: 35,
                          color: const Color.fromRGBO(237, 237, 237, 0.5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5, top: 0, right: 5, bottom: 0),
                                child: Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                  color: Color.fromRGBO(200, 200, 200, 1),
                                ),
                              ),
                              Expanded(
                                child: AutoCompleteSearchBar(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    PlatformNotification.notificationChannel
                        .invokeMethod("show");
                  }),
                  child: Text(
                    "Popular",
                    style: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: _storeList != null
                      ? PageView.builder(
                          itemCount: sampleImages.length,
                          pageSnapping: true,
                          controller: pageController,
                          itemBuilder: (context, pagePosition) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return StoreDetailNoHero(
                                        storeInfo: _storeList![pagePosition]);
                                  }));
                                },
                                child: StoreListWidgets(
                                    type: StoreWidgetBuild.popularRow,
                                    info: _storeList![pagePosition]));
                          })
                      : const Text("인기 많은 가게들을 불러오는 중 ..."),
                ),
              ],
            ),
            // Nearby stores
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nearby",
                      style: GoogleFonts.notoSerif(
                          fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    _storeList != null
                        ? listOfStores(_storeList!)
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OverlayEntry _overlayEntry = OverlayEntry(
  //   builder: (context) {
  //     return Container();
  //   },
  // );
  // final _layerLink = LayerLink();
  // final GlobalKey _searchBarKey = GlobalKey();

  // Offset _getOverlayEntryPosition() {
  //   RenderBox renderBox =
  //       _searchBarKey.currentContext!.findRenderObject()! as RenderBox;
  //   return Offset(renderBox.localToGlobal(Offset.zero).dx,
  //       renderBox.localToGlobal(Offset.zero).dy);
  // }

  // Size _getOverlayEntrySize() {
  //   RenderBox renderBox =
  //       _searchBarKey.currentContext!.findRenderObject()! as RenderBox;
  //   return renderBox.size;
  // }
  // OverlayEntry streamOveraly() {
  //   Offset position = _getOverlayEntryPosition();
  //   Size size = _getOverlayEntrySize();
  //   return OverlayEntry(
  //     builder: (BuildContext context) {
  //       return Positioned(
  //         left: position.dx,
  //         top: position.dy,
  //         child: CompositedTransformFollower(
  //           offset: Offset(0, size.height),
  //           link: _layerLink,
  //           child: StreamBuilder<QuerySnapshot>(
  //             stream:
  //                 FirebaseFirestore.instance.collection('stores').snapshots(),
  //             builder: (context, snapshots) {
  //               return (snapshots.connectionState == ConnectionState.waiting)
  //                   ? Container(
  //                       width: 300,
  //                       height: 300,
  //                       child: const Center(
  //                         child: CircularProgressIndicator(),
  //                       ),
  //                     )
  //                   : (snapshots.connectionState == ConnectionState.active &&
  //                           snapshots.data != null
  //                       ? Material(
  //                           child: SizedBox(
  //                             width: 300,
  //                             child: ListView.builder(
  //                                 shrinkWrap: true,
  //                                 itemCount: snapshots.data!.docs.length,
  //                                 itemBuilder: (context, index) {
  //                                   final data = snapshots.data!.docs[index]
  //                                       .data() as Map<String, dynamic>;
  //                                   if (data['storeName']
  //                                       .toString()
  //                                       .toLowerCase()
  //                                       .startsWith(name.toLowerCase())) {
  //                                     return ListTile(
  //                                       title: Text(
  //                                         data['storeName'],
  //                                         maxLines: 1,
  //                                         overflow: TextOverflow.ellipsis,
  //                                         style: const TextStyle(
  //                                             color: Colors.black54,
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                       subtitle: Text(
  //                                         data['number'],
  //                                         maxLines: 1,
  //                                         overflow: TextOverflow.ellipsis,
  //                                         style: const TextStyle(
  //                                             color: Colors.black54,
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                       leading: const CircleAvatar(
  //                                         backgroundImage: AssetImage(
  //                                             'images/map_icons/bar.png'),
  //                                       ),
  //                                     );
  //                                   } else {
  //                                     return Container();
  //                                   }
  //                                 }),
  //                           ),
  //                         )
  //                       : Container());
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void insertOverlay() {
  //   if (!_overlayEntry.mounted) {
  //     OverlayState overlayState = Overlay.of(context);
  //     _overlayEntry = streamOveraly();
  //     overlayState.insert(_overlayEntry);
  //   }
  // }

  // void removeOverlay() {
  //   if (_overlayEntry.mounted) {
  //     _overlayEntry.remove();
  //   }
  // }
}
