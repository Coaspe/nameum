import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/app.dart';
import 'package:nameum_types/nameum_types.dart';
import '../home.dart';

class MyReservationTab extends StatefulWidget {
  const MyReservationTab({super.key});

  @override
  State<MyReservationTab> createState() => _MyReservationTabState();
}

class _MyReservationTabState extends State<MyReservationTab> {
  late final AppBloc _appBloc;
  List<Store> myReserveStores = [];
  Future<List<Store>?> setMyReserveStores() async {
    myReserveStores = await FireStoreMethods.getListStores(
        _appBloc.state.user.reserveStore.keys.toList());
    return myReserveStores;
  }

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    setMyReserveStores().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("내 예약"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: myReserveStores.isNotEmpty
                          ? ListView(
                              children: myReserveStores!
                                  .map((e) => ReserveList(
                                        storeInfo: e,
                                        userId: _appBloc.state.user.userId,
                                      ))
                                  .toList(),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.no_meals,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("예약 정보가 없습니다"),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
