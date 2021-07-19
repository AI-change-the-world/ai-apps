part of 'workboard_bloc.dart';

abstract class WorkboardEvent extends Equatable {
  const WorkboardEvent();

  @override
  List<Object> get props => [];
}

class RectAdded extends WorkboardEvent {
  final int id;
  const RectAdded({required this.id});
}

class RectIntial extends WorkboardEvent {}

class RectRemove extends WorkboardEvent {
  final int id;
  const RectRemove({required this.id});
}
