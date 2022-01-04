// ignore_for_file: unnecessary_this, unnecessary_overrides

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:34:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 19:57:39
 */
part of 'polygon_workboard_bloc.dart';

enum PolygonWorkboardStatus { initial, add, delete, refresh }

class PolygonWorkboardState extends Equatable {
  final PolygonWorkboardStatus status;
  final List<Widget> widgets;
  final List<PolygonEntity> listPolygonEntity;
  final String imgPath;

  const PolygonWorkboardState(
      {this.status = PolygonWorkboardStatus.initial,
      this.widgets = const [],
      this.listPolygonEntity = const [],
      this.imgPath = ""});

  @override
  List<Object> get props => [status, widgets, listPolygonEntity, imgPath];

  @override
  bool operator ==(Object other) {
    if (this.status == PolygonWorkboardStatus.add ||
        this.status == PolygonWorkboardStatus.refresh ||
        this.status == PolygonWorkboardStatus.delete) {
      return false;
    }
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  int get hashCode => super.hashCode;

  PolygonWorkboardState copyWith(
    PolygonWorkboardStatus? status,
    List<Widget>? widgets,
    List<PolygonEntity>? listPolygonEntity,
    String? imgPath,
  ) {
    return PolygonWorkboardState(
      status: status ?? this.status,
      widgets: widgets ?? this.widgets,
      listPolygonEntity: listPolygonEntity ?? this.listPolygonEntity,
      imgPath: imgPath ?? this.imgPath,
    );
  }
}
