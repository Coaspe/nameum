import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/app.dart';
import 'package:nameum/home/widgets/account_grid_button.dart';
import 'package:nameum/home/widgets/account_menu_row.dart';
import 'package:nameum_types/nameum_types.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  late final AppBloc _appBloc;
  List<Store>? myReserveStores;
  final List<AccountMenuRow> _rows = const [
    AccountMenuRow(name: "공지사항"),
    AccountMenuRow(name: "이벤트"),
    AccountMenuRow(name: "환경설정"),
    AccountMenuRow(name: "고객센터"),
    AccountMenuRow(name: "약관 및 정책"),
    AccountMenuRow(name: "현재 버전"),
  ];
  Future<List<Store>?> setMyReserveStores() async {
    myReserveStores = await FireStoreMethods.getListStores(
        _appBloc.state.user.reserveStore.keys.toList());
    return myReserveStores;
  }

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of<AppBloc>(context);
    setMyReserveStores().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("내 정보"),
        ),
        body: ListView(
          children: [
            Divider(
              height: 10,
              thickness: 10,
              color: Colors.grey.shade200,
            ),
            Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                shape: BoxShape.circle),
                            child: _appBloc.state.user.profileImg != ""
                                ? Image.network(
                                    _appBloc.state.user.profileImg,
                                  )
                                : Image.asset(
                                    'images/NamEum.png',
                                  )),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text("반갑습니다",
                            style: TextStyle(color: Colors.grey, fontSize: 18)),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          _appBloc.state.user.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: const [
                AccountGridButton(icon: Icons.monetization_on, text: "포인트"),
                AccountGridButton(icon: Icons.money, text: "쿠폰함"),
                AccountGridButton(icon: Icons.card_giftcard, text: "선물함"),
                AccountGridButton(icon: Icons.favorite, text: "찜"),
                AccountGridButton(icon: Icons.reviews, text: "리뷰관리"),
                AccountGridButton(icon: Icons.receipt, text: "예약내역"),
              ],
            ),
            Divider(
              height: 10,
              thickness: 10,
              color: Colors.grey.shade200,
            ),
            ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                itemBuilder: ((context, index) => _rows[index]),
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.shade200,
                      thickness: 1,
                    ),
                itemCount: _rows.length),
            Divider(
              height: 10,
              thickness: 10,
              color: Colors.grey.shade200,
            ),
            ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AppBloc>(context).add(AppLogoutRequested());
                },
                child: const Text("로그아웃"))
          ],
        ));
  }
}
