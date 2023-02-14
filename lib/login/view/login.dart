import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/app.dart';
import 'package:nameum/login/cubit/login_cubit.dart';
import 'package:nameum/notification_api/platform_notification.dart';
import 'package:nameum/signup/Signup.dart';

class AndroidLoginPage extends StatefulWidget {
  const AndroidLoginPage({Key? key, required this.state}) : super(key: key);
  final AppState state;
  @override
  State<AndroidLoginPage> createState() => _AndroidLoginPageState();
}

class _AndroidLoginPageState extends State<AndroidLoginPage> {
  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = BlocProvider.of<LoginCubit>(context);
    return Scaffold(
      appBar: AppBar(
          // actions: [],
          ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset('images/NamEum-logos_transparent.png'),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: ((context) => const SignupPage())))
                            .then((result) => BlocProvider.of<AppBloc>(context)
                                .add(LogInWithoutFirebase(
                                    result[0], result[1])));
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                width: 1, color: Colors.black)),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "가입",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "GowunBatang",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(width: 1, color: Colors.black)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        await loginCubit.loginWithGoogle();
                      } catch (e) {}
                    },
                    child: const Text(
                      "로그인",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "GowunBatang",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class IosLoginPage extends StatefulWidget {
  const IosLoginPage({Key? key}) : super(key: key);
  @override
  State<IosLoginPage> createState() => _IosLoginPageState();
}

class _IosLoginPageState extends State<IosLoginPage> {
  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = BlocProvider.of<LoginCubit>(context);
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset('images/NamEum-logos_transparent.png'),
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 40),
                        // maximumSize: const Size(300, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                width: 1, color: Colors.black)),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "가입",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "GowunBatang",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                title: const Text('로그인'),
                                actions: <CupertinoActionSheetAction>[
                                  CupertinoActionSheetAction(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.asset(
                                              'images/kakao.jpg',
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              try {
                                                loginCubit
                                                    .loginWithGoogle()
                                                    .then((v) {
                                                  Navigator.pop(context);
                                                });
                                              } catch (e) {
                                                print(e);
                                              }
                                            },
                                            child: Image.asset(
                                              'images/google.png',
                                              width: 40,
                                              height: 40,
                                            ),
                                          )
                                        ]),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: const Text('Action Two'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                        // try {
                        //   OAuthToken token =
                        //       await UserApi.instance.loginWithKakaoTalk();
                        // } catch (error) {
                        //   print(error);
                        // }
                        // Navigator.push(context,
                        //     CupertinoPageRoute(builder: ((context) {
                        //   return const HomeTab();
                        // })));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.75, 40),
                        // maximumSize: const Size(300, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                width: 1, color: Colors.black)),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "로그인",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GowunBatang",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
