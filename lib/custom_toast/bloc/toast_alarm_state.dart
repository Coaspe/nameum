part of 'toast_alarm_bloc.dart';

class ToastAlarmState extends Equatable {
  const ToastAlarmState({required this.toastQueue, this.displayedEntry});
  final Queue<ToastBase> toastQueue;
  final OverlayEntry? displayedEntry;

  @override
  List<Object> get props => [toastQueue, displayedEntry.runtimeType];

  ToastAlarmState copyWith(
      {Queue<ToastBase>? toastQueue, required OverlayEntry? displayedEntry}) {
    return ToastAlarmState(
        toastQueue: toastQueue ?? this.toastQueue,
        displayedEntry: displayedEntry);
  }
}
