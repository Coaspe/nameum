import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/bloc/app_bloc.dart';
import 'package:nameum/constant.dart';
import 'package:nameum/custom_toast/bloc/toast_alarm_bloc.dart';
import 'package:nameum/store/widgets/table_button.dart';
import 'package:nameum_types/nameum_types.dart';

class CancelReservation extends StatefulWidget {
  const CancelReservation({super.key, required this.storeInfo});
  final Store storeInfo;

  @override
  State<CancelReservation> createState() => _CancelReservationState();
}

class _CancelReservationState extends State<CancelReservation> {
  late final TextEditingController _messageController;
  late final ReserveInfo _reserveInfo;

  @override
  void initState() {
    super.initState();
    assert(widget.storeInfo.reserveClients
        .containsKey(BlocProvider.of<AppBloc>(context).state.user.userId));
    _reserveInfo = widget.storeInfo
        .reserveClients[BlocProvider.of<AppBloc>(context).state.user.userId]!;
    _messageController = TextEditingController(text: _reserveInfo.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("예약정보"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("예약가게"),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: ListTile(
                      leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: widget.storeInfo.thumbnail != ""
                              ? Image.network(
                                  fit: BoxFit.contain,
                                  widget.storeInfo.thumbnail,
                                )
                              : const Icon(Icons.shop_sharp)),
                      title: Text(
                        maxLines: 1,
                        widget.storeInfo.storeName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(defaultAddress.roadAddr!),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            // Client number
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("예약번호"),
                  Text(
                    "010-xxxx-xxxx",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            // Select num of clients
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("예약 인원"),
                  TableSelectButton(
                      readOnly: true,
                      selecetedTable: _reserveInfo.table,
                      number: _reserveInfo.table)
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("예약 상태"),
                  Text(_reserveInfo.state.convertToString())
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 8,
            ),
            // Requirement
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("요청사항"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      enabled: false,
                      controller: _messageController,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                      ))
                ],
              ),
            ),
            // Cancel reservation button
            TextButton(
              onPressed: () {
                final toastBloc = BlocProvider.of<ToastAlarmBloc>(context);
                try {
                  FireStoreMethods.cancelReservation(widget.storeInfo.storeId,
                          BlocProvider.of<AppBloc>(context).state.user)
                      .then((_) {
                    toastBloc.add(ToastAlarmAdded(
                        SuccessToast(message: "예약 취소가 완료되었습니다.")));
                    Navigator.of(context).pop(widget.storeInfo.storeId);
                  });
                } on NoSuchReservation catch (e) {
                  toastBloc
                      .add(ToastAlarmAdded(FailToast(message: e.message!)));
                } catch (e) {
                  toastBloc.add(
                      ToastAlarmAdded(FailToast(message: "예약 취소를 실패하였습니다.")));
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black))),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                fixedSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width, 40)),
              ),
              child: const Text(
                "예약 취소",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
