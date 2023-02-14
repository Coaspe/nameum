part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState({required this.status, this.user = User.empty});
  const AppState.authenticated(User user)
      : this(status: AppStatus.authenticated, user: user);
  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;

  // I guess this is inefficient.
  @override
  List<Object> get props =>
      [status, user.reserveStore, user.notification, user.reserveStore];
}
