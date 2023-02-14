import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/app/app.dart';
import 'package:nameum/custom_toast/bloc/toast_alarm_bloc.dart';
import 'package:nameum/custom_toast/custom_toast.dart';
import 'package:nameum/home/home.dart';
import 'package:nameum/login/cubit/login_cubit.dart';
import 'package:nameum_types/nameum_types.dart';
import '../../login/login.dart';
import '../../notification_api/platform_notification.dart';

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(key: key);
  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ToastAlarmBloc>(create: (_) => ToastAlarmBloc()),
          BlocProvider<AppBloc>(
              create: (_) => AppBloc(
                    authenticationRepository: _authenticationRepository,
                  )),
          BlocProvider<LoginCubit>(
              create: (_) => LoginCubit(_authenticationRepository))
        ],
        child: const AndroidMainPage(),
      ),
    );
  }
}

class AndroidMainPage extends StatelessWidget {
  const AndroidMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.black,
          useMaterial3: true,
          fontFamily: "GowunBatang",
          textTheme:
              const TextTheme(labelLarge: TextStyle(color: Colors.black))),
      home: BlocListener<ToastAlarmBloc, ToastAlarmState>(
        listener: (context, state) {
          if (state.toastQueue.isNotEmpty) {
            final toast = CustomToast(
                context: context, toastType: state.toastQueue.first);
            toast.display();
          }
        },
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state.status == AppStatus.unauthenticated) {
              return AndroidLoginPage(state: state);
            } else {
              if (state.user.notification.isNotEmpty) {
                for (var e in state.user.notification.values) {
                  switch (defaultTargetPlatform) {
                    case TargetPlatform.android:
                      PlatformNotification.showNotification(
                          AndroidNotificationDetails(notificationInfo: e));
                      break;
                    case TargetPlatform.iOS:
                      PlatformNotification.showNotification(
                          DarwinNotifiactionDetails(notificationInfo: e));
                      break;
                    default:
                      break;
                  }
                }
                // Clear notification
                // FireStoreMethods.clearNotification(state.user.email);
              }
              return const HomeTab();
            }
          },
        ),
      ),
    );
  }
}
