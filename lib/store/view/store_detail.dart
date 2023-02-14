import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/app.dart';
import 'package:nameum/constant.dart';
import 'package:nameum/custom_toast/bloc/toast_alarm_bloc.dart';
import 'package:nameum/store/view/cancel_reservation.dart';
import 'package:nameum/store/view/store_reserve.dart';
import 'package:nameum/store/widgets/cancel_reservation_modal.dart';
import 'package:nameum_types/nameum_types.dart';
import 'package:nameum/widget.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({Key? key, required this.store}) : super(key: key);
  final Store store;

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        tooltip: "예약",
        onPressed: () {},
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.restaurant,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(widget.store.storeName),
      ),
      body: Column(children: [
        Hero(
          tag: '${widget.store.storeId} image',
          child: SizedBox(
            height: 250,
            child: Image.network(fit: BoxFit.contain, widget.store.mainImage),
          ),
        ),
        Hero(
          tag: '${widget.store.storeId} info',
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -3))
                    ]),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      mainCarouselTitleText("역전 할머니"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star_border,
                              size: 15,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          mainCarouselInfoText("4팀 대기", 0),
                          mainCarouselInfoText("1.7km", 1),
                          mainCarouselInfoText("평균 20분", 2)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
                "익산역 앞에 있는 엘베강을 모티브로 하여 더 많은 사람들에게 맛있는 맥주 맛을 알리고자 ‘역전할머니맥주’라는 이름으로 시작하게 되었습니다.\n\n한결같은 마음으로 손님에게 편안한 가게를 만들고자 노력하며 장사했고 그 마음을 담았습니다.\n\n현재 역전할머니맥주는 손님과 주인이 따로 없는 편안한 가게를 지향하며 구시대와 현시대를 아우르는 맥주집이 되고자 노력중입니다."))
      ]),
    );
  }
}

class StoreDetailNoHero extends StatefulWidget {
  const StoreDetailNoHero({Key? key, this.storeId, this.storeInfo})
      : super(key: key);
  final String? storeId;
  // Already has info
  final Store? storeInfo;
  @override
  State<StoreDetailNoHero> createState() => _StoreDetailNoHeroState();
}

class _StoreDetailNoHeroState extends State<StoreDetailNoHero> {
  late OverlayEntry _modal;
  Store store = Store(
      storeName: '등록되지 않은 가게',
      storeId: '0',
      tables: {},
      owner: "",
      address: defaultAddress);

  Future<void> waitForAccetped() {
    return Future.delayed(const Duration(seconds: 5));
  }

  @override
  void initState() {
    super.initState();
    assert(widget.storeId == null || widget.storeInfo == null);
    _modal = OverlayEntry(builder: ((context) {
      return CancelReservationModal(
        thisOverlayEntry: _modal,
      );
    }));
    if (widget.storeInfo != null) {
      store = widget.storeInfo!;
    } else {
      FireStoreMethods.getStoreInfo(widget.storeId!).then((value) {
        setState(() {
          store = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      final bool alreadyReserved =
          state.user.reserveStore.keys.contains(store.storeId);
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          tooltip: "예약",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => alreadyReserved
                        ? CancelReservation(storeInfo: widget.storeInfo!)
                        : StoreReserveTab(storeInfo: widget.storeInfo!)));
          },
          backgroundColor: Colors.black,
          child: Icon(
            !alreadyReserved ? Icons.restaurant : Icons.history_edu,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: Text(store.storeName),
        ),
        body: Column(children: [
          SizedBox(
            height: 250,
            child: store.mainImage != ""
                ? Image.network(fit: BoxFit.contain, store.mainImage)
                : Image.asset(
                    'images/grandma.jpg',
                    fit: BoxFit.contain,
                  ),
          ),
          Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -3))
                    ]),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      mainCarouselTitleText(store.storeName),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.star_border,
                              size: 15,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          mainCarouselInfoText(
                              "${store.reserveClients.length}팀 대기", 0),
                          mainCarouselInfoText("1.7km", 1),
                          mainCarouselInfoText("평균 20분", 2)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                  "익산역 앞에 있는 엘베강을 모티브로 하여 더 많은 사람들에게 맛있는 맥주 맛을 알리고자 ‘역전할머니맥주’라는 이름으로 시작하게 되었습니다.\n\n한결같은 마음으로 손님에게 편안한 가게를 만들고자 노력하며 장사했고 그 마음을 담았습니다.\n\n현재 역전할머니맥주는 손님과 주인이 따로 없는 편안한 가게를 지향하며 구시대와 현시대를 아우르는 맥주집이 되고자 노력중입니다."))
        ]),
      );
    });
  }
}
