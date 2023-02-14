import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nameum/home/home.dart';
import 'package:nameum/home/view/account_tab.dart';
import 'package:nameum/home/view/map_tab.dart';
import 'package:nameum/notification_api/platform_notification.dart';

import 'list_tab.dart';
import 'my_reservation_tab.dart';

enum HomePageState { account, map, list }

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final formKey = GlobalKey<FormState>();
  late PageController pageController;
  final log = Logger();

  int _pageIdx = 2;

  @override
  void initState() {
    super.initState();

    // Set Method call handler
    PlatformNotification.notificationChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'RESERVE_ACCEPTED_NOTIFICATION_CLICKED':
          final data = call.arguments['store_id'];
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return StoreDetailNoHero(storeId: data);
            },
          ));
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: _pageIdx);

    return Scaffold(
      body: PageView(
        onPageChanged: ((value) {
          // Remove TextField focus
          FocusScope.of(context).unfocus();
          setState(() {
            _pageIdx = value;
          });
        }),
        controller: pageController,
        physics: _pageIdx == 3 ? const NeverScrollableScrollPhysics() : null,
        children: [
          const AccountTab(),
          const MyReservationTab(),
          HomeList(formKey: formKey),
          const HomeMap()
        ],
      ),
      // floatingActionButton: const CustomFloatingActionButton(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 12.0,
          currentIndex: _pageIdx,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black26,
          onTap: ((value) {
            setState(() {
              _pageIdx = value;
            });
            pageController.animateToPage(value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          }),
          items: const [
            BottomNavigationBarItem(label: "계정", icon: Icon(Icons.person)),
            BottomNavigationBarItem(label: "예약", icon: Icon(Icons.history_edu)),
            BottomNavigationBarItem(
                label: "홈", icon: Icon(CupertinoIcons.home)),
            BottomNavigationBarItem(
                label: "지도", icon: Icon(CupertinoIcons.map_fill)),
          ],
        ),
      ),
    );
  }
}


// class HomeTab extends StatefulWidget {
//   const HomeTab({Key? key}) : super(key: key);

//   @override
//   State<HomeTab> createState() => HomeTabState();
// }

// class HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
//   late PageController pageController;
//   final formKey = GlobalKey<FormState>();
//   final log = Logger();
//   CupertinoTabController? _cupertinoTabController;
//   late AnimationController _alarmToastController;
//   int boolListToIndex(List<bool> list) {
//     if (list.isEmpty) return 0;
//     return list[0] ? 0 : 1;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _alarmToastController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       _cupertinoTabController = CupertinoTabController(initialIndex: 1);
//       pageController = PageController(viewportFraction: 0.8);
//     }
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     _cupertinoTabController?.dispose();
//     _alarmToastController.dispose();
//     super.dispose();
//   }

//   SizedBox customElevatedButton(String title) {
//     return SizedBox(
//       height: 30,
//       child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//           child: Text(title,
//               style: const TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold))),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (_) => ToastAlarmBloc(),
//         child: BlocListener<ToastAlarmBloc, ToastAlarmState>(
//           listener: ((context, state) {
//             final toast =
//                 CustomToast(context: context, toastType: HeartToast());
//             toast.display();
//           }),
//           child: CupertinoTabScaffold(
//               controller: _cupertinoTabController,
//               tabBar: CupertinoTabBar(items: const <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                     icon: Icon(CupertinoIcons.person_crop_circle_fill)),
//                 BottomNavigationBarItem(icon: Icon(CupertinoIcons.list_dash)),
//                 BottomNavigationBarItem(icon: Icon(CupertinoIcons.map_fill)),
//               ]),
//               tabBuilder: (context, idx) {
//                 switch (idx) {
//                   case 0:
//                     return const AccountTab();
//                   case 1:
//                     return HomeList(formKey: formKey);
//                   case 2:
//                     return const HomeMap();
//                   default:
//                     return HomeList(formKey: formKey);
//                 }
//               }),
//         ));
//   }
// }
