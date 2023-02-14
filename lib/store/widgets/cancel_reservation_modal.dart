import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelReservationModal extends StatefulWidget {
  const CancelReservationModal({super.key, required this.thisOverlayEntry});
  final OverlayEntry thisOverlayEntry;

  @override
  State<CancelReservationModal> createState() => _CancelReservationModalState();
}

class _CancelReservationModalState extends State<CancelReservationModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _backgroundAnimation;
  late final Animation<double> _foregroundAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _backgroundAnimation =
        Tween<double>(begin: 0.0, end: 0.3).animate(_animationController);
    _foregroundAnimation = _animationController;
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        _animationController
            .reverse()
            .then((_) => widget.thisOverlayEntry.remove());
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: _backgroundAnimation,
            child: Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Material(
            child: FadeTransition(
              opacity: _foregroundAnimation,
              child: AnimatedContainer(
                color: Colors.white,
                curve: Curves.bounceInOut,
                duration: const Duration(milliseconds: 200),
                width: 300,
                height: 200,
                child: Column(
                  children: [
                    SizedBox(
                        width: 300,
                        height: 150,
                        child: Center(
                          child: Text("예약을 취소하시겠습니까?",
                              style: GoogleFonts.abel(fontSize: 15)),
                        )),
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                                onPressed: () {}, child: const Text("예"))),
                        Expanded(
                            child: TextButton(
                                onPressed: () {}, child: const Text("아니오")))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
