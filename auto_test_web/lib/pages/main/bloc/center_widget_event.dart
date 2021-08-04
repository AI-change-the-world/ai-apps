/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-03 19:25:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 19:55:03
 */
part of 'center_widget_bloc.dart';

abstract class CenterWidgetEvent extends Equatable {
  const CenterWidgetEvent();

  @override
  List<Object> get props => [];
}

class WidgetInit extends CenterWidgetEvent {}

class WidgetRefresh extends CenterWidgetEvent {
  final String widgetName;
  final bool needRefresh;
  const WidgetRefresh({required this.widgetName, required this.needRefresh});
}

class WidgetAdd extends CenterWidgetEvent {
  final String widgetName;
  const WidgetAdd({required this.widgetName});
}

class WidgetDelete extends CenterWidgetEvent {
  final String widgetName;
  const WidgetDelete({required this.widgetName});
}
