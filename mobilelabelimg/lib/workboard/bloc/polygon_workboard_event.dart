/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:34:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-16 21:59:49
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
