part of 'workboard_bloc.dart';

enum WorkboardStatus { initial, add, delete }

class WorkboardState extends Equatable {
  final WorkboardStatus status;
  final List<RectBox> rectBoxes;
  const WorkboardState(
      {this.status = WorkboardStatus.initial, this.rectBoxes = const []});

  @override
  List<Object> get props => [status, rectBoxes];

  WorkboardState copyWith(WorkboardStatus? status, List<RectBox>? rectBoxes) {
    return WorkboardState(
        status: status ?? this.status, rectBoxes: rectBoxes ?? this.rectBoxes);
  }
}

// class WorkboardInitial extends WorkboardState {}
