import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilelabelimg/widgets/rect.dart';
import 'package:rxdart/rxdart.dart';

part 'workboard_event.dart';
part 'workboard_state.dart';

class WorkboardBloc extends Bloc<WorkboardEvent, WorkboardState> {
  WorkboardBloc() : super(WorkboardState());

  @override
  Stream<WorkboardState> mapEventToState(
    WorkboardEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is RectIntial) {
      yield await _fetchedToState(state);
    }

    if (event is RectAdded) {
      yield await _addToState(state, event);
    }

    if (event is RectRemove) {
      yield await _removeToState(state, event);
    }
  }

  @override
  Stream<Transition<WorkboardEvent, WorkboardState>> transformEvents(
    Stream<WorkboardEvent> events,
    TransitionFunction<WorkboardEvent, WorkboardState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  Future<WorkboardState> _fetchedToState(WorkboardState state) async {
    final List<RectBox> rectboxes = [];
    return state.copyWith(
        WorkboardStatus.initial, List.of(state.rectBoxes)..addAll(rectboxes));
  }

  Future<WorkboardState> _addToState(
      WorkboardState state, RectAdded event) async {
    return state.copyWith(WorkboardStatus.add,
        List.of(state.rectBoxes)..add(RectBox(id: event.id)));
  }

  Future<WorkboardState> _removeToState(
      WorkboardState state, RectRemove event) async {
    var rectBoxes = state.rectBoxes.where((element) => element.id != event.id);
    return state.copyWith(
        WorkboardStatus.delete,
        List.of(state.rectBoxes)
          ..clear()
          ..addAll(rectBoxes));
  }
}
