import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/custom_toast/bloc/toast_alarm_bloc.dart';
import 'package:nameum_types/nameum_types.dart';

class TableSelectButton extends StatefulWidget {
  const TableSelectButton(
      {super.key,
      required this.number,
      this.setSeletedSeat,
      this.selecetedTable = -1,
      this.enable = true,
      this.readOnly = false});
  final int number;
  final int selecetedTable;
  final Function(int)? setSeletedSeat;
  final bool enable;
  final bool readOnly;

  @override
  State<TableSelectButton> createState() => _TableSelectButtonState();
}

class _TableSelectButtonState extends State<TableSelectButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
          borderRadius: BorderRadius.circular(100),
          color: widget.selecetedTable == widget.number
              ? Colors.black87
              : Colors.black38,
          child: widget.readOnly
              ? SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                      child: Text(
                    "${widget.number}인${widget.number == 6 ? "+" : ""}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                )
              : InkWell(
                  onTap: () {
                    if (widget.enable) {
                      widget.setSeletedSeat!(widget.number);
                    } else {
                      BlocProvider.of<ToastAlarmBloc>(context).add(
                          ToastAlarmAdded(
                              WarningToast(message: "해당 좌석은 빈자리가 없습니다.")));
                    }
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                            child: Text(
                          "${widget.number}인${widget.number == 6 ? "+" : ""}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                      !widget.enable
                          ? const Icon(
                              Icons.close,
                              size: 40,
                              color: Colors.black38,
                            )
                          : const Center(),
                    ],
                  ))),
    );
  }
}
