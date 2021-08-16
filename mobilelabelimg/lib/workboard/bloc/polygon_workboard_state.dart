/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:34:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-16 20:45:09
 */
part of 'polygon_workboard_bloc.dart';

enum PolygonWorkboardStatus { initial, add, delete, refresh }

class PolygonWorkboardState extends Equatable {
  final PolygonWorkboardStatus status;
  final List<Widget> widgets;
  final List<PolygonEntity> listPolygonEntity;

  const PolygonWorkboardState(
      {this.status = PolygonWorkboardStatus.initial,
      this.widgets = const [],
      this.listPolygonEntity = const []});

  @override
  List<Object> get props => [status, widgets, listPolygonEntity];

  @override
  bool operator ==(Object other) {
    if (this.status == PolygonWorkboardStatus.add ||
        this.status == PolygonWorkboardStatus.refresh) {
      return false;
    }
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  PolygonWorkboardState copyWith(PolygonWorkboardStatus? status,
      List<Widget>? widgets, List<PolygonEntity>? listPolygonEntity) {
    return PolygonWorkboardState(
        status: status ?? this.status,
        widgets: widgets ?? this.widgets,
        listPolygonEntity: listPolygonEntity ?? this.listPolygonEntity);
  }
}