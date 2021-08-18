/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:34:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 19:59:41
 */
part of 'polygon_workboard_bloc.dart';

abstract class PolygonWorkboardEvent extends Equatable {
  const PolygonWorkboardEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends PolygonWorkboardEvent {
  // final GlobalKey<ScaffoldState> scaffoldKey;
  // const InitialEvent({required this.scaffoldKey});
}

class WidgetAddEvent extends PolygonWorkboardEvent {
  final Widget w;
  const WidgetAddEvent({required this.w});
}

class PolygonEntityAddEvent extends PolygonWorkboardEvent {
  final PolygonEntity p;
  const PolygonEntityAddEvent({required this.p});
}

class PolygonEntityRemoveEvent extends PolygonWorkboardEvent {
  final int index;
  const PolygonEntityRemoveEvent({required this.index});
}

class WidgetsRemoveEvent extends PolygonWorkboardEvent {
  final int index;
  const WidgetsRemoveEvent({required this.index});
}

class PolygonEntityChangeNameEvent extends PolygonWorkboardEvent {
  final String name;
  final int index;
  const PolygonEntityChangeNameEvent({required this.name, required this.index});
}

class SetImgPathEvent extends PolygonWorkboardEvent {
  final String imgpath;
  const SetImgPathEvent({required this.imgpath});
}

class GetSingleImagePolygonEvent extends PolygonWorkboardEvent {
  final String filename;
  const GetSingleImagePolygonEvent({required this.filename});
}
