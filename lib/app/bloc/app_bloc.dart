import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nameum_types/nameum_types.dart';
part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(authenticationRepository.currentUser.isNotEmpty
            ? AppState.authenticated(authenticationRepository.currentUser)
            : const AppState.unauthenticated()) {
    on<AppUserAccountChanged>(_onUserAccountChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppUserInfoChanged>(_onUserInfoChanged);
    on<AppLogoutRequestedWithoutFirestore>(_onLogoutRequestedWithoutFirestore);
    on<LogInWithoutFirebase>(_onLogInWithoutFirebase);
    SharedPreferences.getInstance().then((value) async {
      final email = value.getString("userEmail");
      if (email != null) {
        User? user = await FireStoreMethods.getUserByEmail(email);
        if (user != null) {
          add(AppUserAccountChanged(user));
        }
      }
    });
    _userSubscription =
        _authenticationRepository.firebaseUser.listen((value) async {
      if (value == null) {
        add(const AppUserAccountChanged(User.empty));
      } else {
        value.then(
          (user) {
            add(AppUserAccountChanged(user));
          },
        );
      }
    });
  }
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<Future<User>?> _userSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userChange;
  final log = Logger();

  void _onUserInfoChanged(AppUserInfoChanged event, Emitter<AppState> emit) {
    AppState newState = AppState.authenticated(event.user);
    emit(newState);
  }

  void _onLogoutRequestedWithoutFirestore(
      AppLogoutRequestedWithoutFirestore event, Emitter<AppState> emit) {
    _authenticationRepository.logOutWithoutFirestore();
    add(const AppUserAccountChanged(User.empty));
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  void _onUserAccountChanged(
      AppUserAccountChanged event, Emitter<AppState> emit) {
    if (event.user.isNotEmpty) {
      emit(AppState.authenticated(event.user));
      if (_userChange != null) _userChange!.cancel();

      // 이 코드에서는 어떤 필드가 추가, 삭제, 수정되었는지 구분이 불가능하다.
      _userChange = FireStoreMethods.fs
          .collection("users")
          .doc(event.user.email)
          .snapshots()
          .listen((snap) {
        add(AppUserInfoChanged(
            User.fromJson(snap.data() as Map<String, dynamic>)));
      });
    } else {
      emit(const AppState.unauthenticated());
      if (_userChange != null) _userChange!.cancel();
    }
  }

  void _onLogInWithoutFirebase(
      LogInWithoutFirebase event, Emitter<AppState> emit) async {
    User? user = await _authenticationRepository.logInWithoutFirebase(
        event.email, event.password);
    add(AppUserAccountChanged(user!));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
