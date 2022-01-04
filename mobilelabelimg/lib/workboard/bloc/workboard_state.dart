part of 'workboard_bloc.dart';

enum WorkboardStatus { initial, add, delete, refresh }

class ImageRectBox extends Equatable {
  final List<RectBox> rectBoxes;
  final String imageName;
  final String imagePath;
  final double currentFactor;
  const ImageRectBox(
      {this.imageName = "",
      this.rectBoxes = const [],
      this.imagePath = "",
      this.currentFactor = 1.0});

  @override
  // TODO: implement props
  List<Object?> get props => [imageName, rectBoxes, imagePath, currentFactor];
}

class WorkboardState extends Equatable {
  final WorkboardStatus status;
  // final List<RectBox> rectBoxes;
  final ImageRectBox param;
  final double currentFactor;

  const WorkboardState(
      {this.status = WorkboardStatus.initial,
      this.param = const ImageRectBox(),
      this.currentFactor = 1.0});

  @override
  List<Object> get props => [status, param];

  WorkboardState copyWith(
      WorkboardStatus? status, ImageRectBox? param, double? currentFactor) {
    return WorkboardState(
      status: status ?? this.status,
      param: param ?? this.param,
      currentFactor: currentFactor ?? this.currentFactor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (this.status == WorkboardStatus.add ||
        this.status == WorkboardStatus.refresh) {
      return false;
    }
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  int get hashCode => super.hashCode;
}

// class WorkboardInitial extends WorkboardState {}
