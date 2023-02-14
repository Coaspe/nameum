part of 'toast_alarm_bloc.dart';

abstract class ToastAlarmEvent extends Equatable {
  const ToastAlarmEvent();

  @override
  List<Object> get props => [];
}

class ToastAlarmRemoved extends ToastAlarmEvent {}

class ToastAlarmAdded extends ToastAlarmEvent {
  const ToastAlarmAdded(this.toast);
  final ToastBase toast;
  @override
  List<Object> get props => [toast];
}

class DisplayedEntryChanged extends ToastAlarmEvent {
  const DisplayedEntryChanged(this.nowDisplayedEntry);
  final OverlayEntry? nowDisplayedEntry;

  @override
  List<Object> get props => [nowDisplayedEntry.runtimeType];
}

class ToastAlarmRemovedByButton extends ToastAlarmEvent {}
