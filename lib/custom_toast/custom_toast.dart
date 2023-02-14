import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/custom_toast/bloc/toast_alarm_bloc.dart';
import 'package:nameum_types/src/toast_types.dart';

class ToastWidget extends StatefulWidget {
  const ToastWidget(
      {super.key, required this.toastType, required this.blocContext});
  final ToastBase toastType;
  final BuildContext blocContext;
  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late ToastAlarmBloc _toastBloc;
  Timer? _timer;

  void showIt() {
    _controller.forward();
  }

  void hideIt() {
    _controller.reverse().then((_) {
      if (_toastBloc.state.displayedEntry != null) {
        _toastBloc.add(ToastAlarmRemoved());
      }
    });
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _toastBloc = BlocProvider.of<ToastAlarmBloc>(widget.blocContext);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    showIt();
    _timer = Timer(const Duration(seconds: 2), () {
      hideIt();
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _controller.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 100,
        right: MediaQuery.of(context).size.width / 2 - 150,
        child: FadeTransition(
            opacity: _fadeAnimation,
            child: Material(
              child: Container(
                width: 300,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.toastType.leading,
                      Expanded(child: Center(child: widget.toastType.message)),
                      GestureDetector(
                          onTap: () {
                            _toastBloc.add(ToastAlarmRemoved());
                          },
                          child: widget.toastType.trailing)
                    ],
                  ),
                ),
              ),
            )));
  }
}

class CustomToast {
  CustomToast({required this.context, required ToastBase toastType});

  /// BuildContext for overlay
  final BuildContext context;

  /// ToastWidget
  late final ToastWidget toastWidget;
  void insertEntry() {
    ToastAlarmBloc bloc = BlocProvider.of<ToastAlarmBloc>(context);

    if (bloc.state.displayedEntry == null && bloc.state.toastQueue.isNotEmpty) {
      toastWidget = ToastWidget(
          toastType: bloc.state.toastQueue.first, blocContext: context);
      OverlayEntry nextOverlay = OverlayEntry(builder: ((context) {
        return toastWidget;
      }));
      Overlay.of(context)!.insert(nextOverlay);
      bloc.add(DisplayedEntryChanged(nextOverlay));
    }
  }

  void display() {
    insertEntry();
  }
}
