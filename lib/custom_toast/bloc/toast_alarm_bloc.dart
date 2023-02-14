import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nameum_types/src/toast_types.dart';

part 'toast_alarm_state.dart';
part 'toast_alarm_event.dart';

// 중복된 알람 막기 서술하기
class ToastAlarmBloc extends Bloc<ToastAlarmEvent, ToastAlarmState> {
  ToastAlarmBloc() : super(ToastAlarmState(toastQueue: Queue<ToastBase>())) {
    on<ToastAlarmAdded>(_onToastAlarmAdded);
    on<ToastAlarmRemoved>(_onToastAlarmRemoved);
    on<DisplayedEntryChanged>(_onDisplayedEntryChanged);
    on<ToastAlarmRemovedByButton>(_onToastAlarmRemovedByBtn);
  }

  void _onToastAlarmAdded(
      ToastAlarmAdded event, Emitter<ToastAlarmState> emit) {
    if (state.toastQueue.isNotEmpty && event.toast == state.toastQueue.last) {
      return;
    }
    Queue<ToastBase> newQueue = Queue.from(state.toastQueue);
    newQueue.addLast(event.toast);
    emit(ToastAlarmState(
        toastQueue: newQueue, displayedEntry: state.displayedEntry));
  }

  void _onDisplayedEntryChanged(
      DisplayedEntryChanged event, Emitter<ToastAlarmState> emit) {
    emit(state.copyWith(displayedEntry: event.nowDisplayedEntry));
  }

  void _onToastAlarmRemoved(
      ToastAlarmRemoved event, Emitter<ToastAlarmState> emit) {
    Queue<ToastBase> newQueue = Queue.from(state.toastQueue);
    newQueue.removeFirst();
    state.displayedEntry!.remove();
    emit(state.copyWith(toastQueue: newQueue, displayedEntry: null));
  }

  void _onToastAlarmRemovedByBtn(
      ToastAlarmRemovedByButton event, Emitter<ToastAlarmState> emit) {
    Queue<ToastBase> newQueue = Queue.from(state.toastQueue);
    newQueue.removeFirst();
    emit(ToastAlarmState(toastQueue: newQueue, displayedEntry: null));
  }

  @override
  void onEvent(ToastAlarmEvent event) {
    super.onEvent(event);
    if (event.runtimeType == ToastAlarmRemoved) {}
  }
}
