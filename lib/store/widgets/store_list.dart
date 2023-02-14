import 'package:flutter/material.dart';
import 'package:nameum/store/view/cancel_reservation.dart';
import 'package:nameum/store/view/store_detail.dart';
import 'package:nameum_types/nameum_types.dart';
import 'package:nameum/widget.dart';

enum StoreWidgetBuild { popularListItem, popularRow, reservedListRow }

class StoreListWidgets extends StatefulWidget {
  const StoreListWidgets({Key? key, required this.type, required this.info})
      : super(key: key);

  final StoreWidgetBuild type;
  final Store info;

  @override
  State<StoreListWidgets> createState() => _StoreListWidgetsState();
}

class _StoreListWidgetsState extends State<StoreListWidgets> {
  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  late final Widget val;
  GestureDetector surroundingListRow() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return StoreDetailNoHero(storeInfo: widget.info);
        }));
      },
      child: Card(
        child: ListTile(
          leading: SizedBox(
              width: 40,
              height: 40,
              child: widget.info.thumbnail != ""
                  ? Image.network(
                      fit: BoxFit.contain,
                      widget.info.thumbnail,
                    )
                  : const Icon(Icons.shop_sharp)),
          title: Text(
            maxLines: 1,
            widget.info.storeName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(widget.info.detailDesc),
        ),
      ),
    );
  }

  Container popularListItem() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Hero(
              tag: '${widget.info.storeId} image',
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.info.mainImage != ""
                      ? Image.network(widget.info.mainImage)
                      : Image.asset("images/NaumEum.png"))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Hero(
              flightShuttleBuilder: _flightShuttleBuilder,
              tag: '${widget.info.storeId} info',
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3))
                    ]),
                width: 250,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      mainCarouselTitleText(widget.info.storeName),
                      Row(
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
            ),
          )
        ],
      ),
    );
  }

  GestureDetector reservedListRow() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return StoreDetailNoHero(storeInfo: widget.info);
        }));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [Text("3시간 전"), Text("·"), Text("예약 접수")]),
            ListTile(
              leading: SizedBox(
                  height: double.infinity,
                  child: widget.info.thumbnail != ""
                      ? Image.network(
                          widget.info.thumbnail,
                          width: 40,
                          height: 40,
                        )
                      : const Icon(Icons.shop_sharp)),
              title: Text(
                widget.info.storeName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(widget.info.detailDesc),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case StoreWidgetBuild.popularListItem:
        val = surroundingListRow();
        break;
      case StoreWidgetBuild.popularRow:
        val = popularListItem();
        break;
      case StoreWidgetBuild.reservedListRow:
        val = reservedListRow();
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return val;
  }
}

class ReserveList extends StatefulWidget {
  const ReserveList({super.key, required this.storeInfo, required this.userId});
  final String userId;
  final Store storeInfo;

  @override
  State<ReserveList> createState() => _ReserveListState();
}

class _ReserveListState extends State<ReserveList> {
  ReserveInfo? reserveInfo;
  bool canceled = false;
  @override
  void initState() {
    super.initState();
    reserveInfo = widget.storeInfo.reserveClients[widget.userId];
    assert(reserveInfo != null);
  }

  String convertTimeStampToDateTime(int timestamp) {
    DateTime reserveTime = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    if (now.year > reserveTime.year) {
      return "${now.year - reserveTime.year}년 전";
    }
    if (now.month > reserveTime.month) {
      return "${now.month - reserveTime.month}달 전";
    }
    if (now.day > reserveTime.day) {
      return "${now.day - reserveTime.day}일 전";
    }
    if (now.hour > reserveTime.hour) {
      return "${now.hour - reserveTime.hour}시간 전";
    }
    if (now.minute > reserveTime.minute) {
      return "${now.minute - reserveTime.minute}분 전";
    }
    return "몇초 전";
  }

  void pushCancelReservation() async {
    String? val = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CancelReservation(storeInfo: widget.storeInfo)));
    if (val != null) {
      setState(() {
        canceled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!canceled) pushCancelReservation();
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  !canceled
                      ? "${convertTimeStampToDateTime(reserveInfo!.time)} · ${reserveInfo!.state.convertToString()}"
                      : "예약 취소",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const Icon(Icons.more_vert)
              ]),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                    height: double.infinity,
                    child: widget.storeInfo.thumbnail != ""
                        ? Image.network(
                            widget.storeInfo.thumbnail,
                            width: 40,
                            height: 40,
                          )
                        : const Icon(Icons.shop_sharp)),
                title: Text(
                  widget.storeInfo.storeName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  widget.storeInfo.detailDesc,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
