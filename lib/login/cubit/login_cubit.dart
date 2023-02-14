import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());
  final AuthenticationRepository _authenticationRepository;

  Future<void> loginWithGoogle() async {
    if (state.status == FormzStatus.submissionInProgress) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzStatus.submissionFailure));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> logInWithoutFirebase(String email, String password) async {
    if (state.status == FormzStatus.submissionInProgress) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      _authenticationRepository.logInWithoutFirebase(email, password);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzStatus.submissionFailure));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
