import 'package:flutter/material.dart';
import 'package:nameum/home/widgets/selected_bottom_sheet.dart';
import '../../constant.dart';

class MapBottomSheet extends StatefulWidget {
  const MapBottomSheet(
      {super.key,
      required this.bottomSheetOpened,
      required this.setBottomSheetOpend});
  final bool bottomSheetOpened;
  final Function setBottomSheetOpend;
  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  double _height = lowLimit;

  /// 100 -> 600, 550 -> 100 으로 애니메이션이 진행 될 때,
  /// 드래그로 인한 _height의 변화 방지
  bool _longAnimation = false;
  bool _openedOnEnd = false;
  bool _storeDetailFetchingEnded = false;
  bool _storeDetailFetching = false;

  @override
  void didUpdateWidget(MapBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.bottomSheetOpened != widget.bottomSheetOpened) &&
        widget.bottomSheetOpened) {
      fetchSomething();
    }
  }

  void fetchSomething() async {
    setState(() {
      _storeDetailFetching = true;
      _storeDetailFetchingEnded = false;
      _height = highLimit;
      _longAnimation = true;
    });
    await Future.delayed(const Duration(seconds: 2), (() {
      setState(() {
        _storeDetailFetchingEnded = true;
        _storeDetailFetching = false;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0.0,
        child: GestureDetector(
            onVerticalDragUpdate: ((details) {
              // delta: y축의 변화량, 우리가 보기에 위로 움직이면 양의 값, 아래로 움직이면 음의 값
              double? delta = details.primaryDelta;
              if (delta != null) {
                /// Long Animation이 진행 되고 있을 때는 드래그로 높이 변화 방지,
                /// 그리고 low limit 보다 작을 때 delta가 양수,
                /// High limit 보다 크거나 같을 때 delta가 음수이면 드래그로 높이 변화 방지
                if (_longAnimation ||
                    (_height <= lowLimit && delta > 0) ||
                    (_height >= highLimit && delta < 0)) return;
                setState(() {
                  /// 600으로 높이 설정
                  if (upThresh <= _height && _height <= boundary) {
                    _longAnimation = true;
                    _height = highLimit;
                  }

                  /// 100으로 높이 설정
                  else if (boundary <= _height && _height <= downThresh) {
                    _longAnimation = true;
                    _height = lowLimit;
                    widget.setBottomSheetOpend(false);
                  }

                  /// 기본 작동
                  else {
                    _height -= delta;
                  }
                });
              }
            }),
            child: AnimatedContainer(
              curve: Curves.bounceOut,
              onEnd: () {
                if (_longAnimation) {
                  if (_height == highLimit) {
                    setState(() {
                      _longAnimation = false;
                      _openedOnEnd = true;
                    });
                  } else if (_height == lowLimit) {
                    setState(() {
                      _longAnimation = false;
                      _openedOnEnd = false;
                    });
                  }
                }
              },
              duration: const Duration(milliseconds: 400),
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 6, spreadRadius: 0.7)],
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              width: MediaQuery.of(context).size.width,
              height: _height,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: 70,
                    height: 4.5,
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  (downThresh <= _height && _height <= highLimit + 100) &&
                          _storeDetailFetchingEnded &&
                          !_storeDetailFetching
                      ? Expanded(
                          child: SelectedBottomSheet(openedOnEnd: _openedOnEnd))
                      : Container(),
                  !_storeDetailFetchingEnded && _storeDetailFetching
                      ? const Expanded(
                          child: Center(
                              child: CircularProgressIndicator.adaptive()))
                      : Container()
                ],
              ),
            )));
  }
}
