part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AppLogoutRequestedWithoutFirestore extends AppEvent {}

class AppUserAccountChanged extends AppEvent {
  const AppUserAccountChanged(this.user);

  final User user;

  @override
  List<Object> get props => [];
}

class LogInWithoutFirebase extends AppEvent {
  const LogInWithoutFirebase(this.email, this.password);
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class AppUserInfoChanged extends AppEvent {
  const AppUserInfoChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class UserReservationChanged extends AppUserInfoChanged {
  const UserReservationChanged(user) : super(user);

  @override
  List<Object> get props => [user.reserveStore];
}
