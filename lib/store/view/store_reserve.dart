import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/bloc/app_bloc.dart';
import 'package:nameum/constant.dart';
import 'package:nameum/custom_toast/bloc/toast_alarm_bloc.dart';
import 'package:nameum/store/widgets/table_button.dart';
import 'package:nameum_types/nameum_types.dart';

class StoreReserveTab extends StatefulWidget {
  const StoreReserveTab({super.key, required this.storeInfo});
  final Store storeInfo;
  @override
  State<StoreReserveTab> createState() => _StoreReseverTabState();
}

class _StoreReseverTabState extends State<StoreReserveTab> {
  int selecetedTable = -1;
  bool _useSafeNumber = false;
  final TextEditingController _messageController = TextEditingController();
  late final Map<int, bool> _enableTable;
  void setSeletedSeat(int seat) {
    setState(() {
      selecetedTable = seat;
    });
  }

  Map<int, bool> enbaleTable(Store store) {
    Map<int, int> check = {for (var v in store.tables.keys) v: 0};
    for (var ele in store.reserveClients.values) {
      check[ele.table] = check[ele.table]! + 1;
    }
    return {for (var v in check.entries) v.key: store.tables[v.key]! > v.value};
  }

  @override
  void initState() {
    super.initState();
    _enableTable = enbaleTable(widget.storeInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("예약"),
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
                  const Text("예약정보"),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "010-xxxx-xxxx",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "변경",
                            style: TextStyle(fontSize: 11),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                            value: _useSafeNumber,
                            onChanged: ((value) {
                              setState(() {
                                _useSafeNumber = value!;
                              });
                            })),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("안전번호 사용")
                    ],
                  )
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.storeInfo.tables.keys
                    .toList()
                    .map((e) => TableSelectButton(
                          number: e,
                          selecetedTable: selecetedTable,
                          setSeletedSeat: setSeletedSeat,
                          enable: _enableTable[e]!,
                        ))
                    .toList(),
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
                      maxLength: 100,
                      controller: _messageController,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "예) 안녕하세요 잘 부탁드립니다.",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                      ))
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                try {
                  if (selecetedTable == -1) {
                    throw const NoSelectedTable("예약 인원을 선택해주세요.");
                  }
                  FireStoreMethods.reserveStore(
                    widget.storeInfo.storeId,
                    BlocProvider.of<AppBloc>(context).state.user,
                    selecetedTable,
                    _messageController.text,
                  ).then((_) {
                    BlocProvider.of<ToastAlarmBloc>(context).add(
                        ToastAlarmAdded(SuccessToast(message: "예약이 완료되었습니다.")));
                    Navigator.of(context).pop();
                  });
                } on FullTable catch (e) {
                  BlocProvider.of<ToastAlarmBloc>(context).add(ToastAlarmAdded(
                      WarningToast(
                          message: e.message == null ? "" : e.message!)));
                } on NoSelectedTable catch (e) {
                  BlocProvider.of<ToastAlarmBloc>(context).add(ToastAlarmAdded(
                      WarningToast(
                          message: e.message == null ? "" : e.message!)));
                } catch (e) {}
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
                "예약 완료",
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
