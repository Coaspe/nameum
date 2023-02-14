import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/constant.dart';
import 'package:nameum/widget.dart';
import 'package:nameum_types/nameum_types.dart';

import '../../app/bloc/app_bloc.dart';
import '../../store/view/store_reserve.dart';

class SelectedBottomSheet extends StatefulWidget {
  const SelectedBottomSheet({super.key, required this.openedOnEnd});
  final bool openedOnEnd;
  @override
  State<SelectedBottomSheet> createState() => _SelectedBottomSheetState();
}

class _SelectedBottomSheetState extends State<SelectedBottomSheet> {
  final Store _storeInfo = rests[0];
  bool _isReserving = false;

  @override
  Widget build(BuildContext context) {
    final bool alreadyReserve = BlocProvider.of<AppBloc>(context)
        .state
        .user
        .reserveStore
        .keys
        .contains(_storeInfo.storeId);
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          elevation: 10,
          tooltip: "예약",
          onPressed: () {
            if (!alreadyReserve) {
              setState(() {
                _isReserving = true;
              });
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StoreReserveTab(storeInfo: _storeInfo)))
                  .then((value) => setState(
                        () => _isReserving = false,
                      ));
            }
          },
          backgroundColor: Colors.black,
          child: _isReserving
              ? const CircularProgressIndicator()
              : Icon(
                  !alreadyReserve ? Icons.restaurant : Icons.cancel,
                  color: Colors.white,
                ),
        ),
      ),
      body: widget.openedOnEnd
          ? Column(children: [
              Image.asset(
                _storeInfo.mainImage,
                height: 200,
                fit: BoxFit.fitHeight,
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
              const Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text(
                          "익산역 앞에 있는 엘베강을 모티브로 하여 더 많은 사람들에게 맛있는 맥주 맛을 알리고자 ‘역전할머니맥주’라는 이름으로 시작하게 되었습니다.\n\n한결같은 마음으로 손님에게 편안한 가게를 만들고자 노력하며 장사했고 그 마음을 담았습니다.\n\n현재 역전할머니맥주는 손님과 주인이 따로 없는 편안한 가게를 지향하며 구시대와 현시대를 아우르는 맥주집이 되고자 노력중입니다.")),
                ),
              ),
            ])
          : Container(),
    );
  }
}
