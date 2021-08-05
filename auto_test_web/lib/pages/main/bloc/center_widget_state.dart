/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-03 19:25:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 20:09:53
 */
part of 'center_widget_bloc.dart';

enum CenterWidgetStatus { initial, refresh, add, delete, notChanged, loading }

class CenterWidgetState extends Equatable {
  final List<MyTab> tabList;
  final Widget centerWidget;
  final CenterWidgetStatus status;
  final List<String> tabNames;
  final List<Widget> screens;
  final bool needRefresh;
  final String currentTabName;
  final bool isLoading;

  const CenterWidgetState(
      {this.tabList = const [],
      this.centerWidget = const WelcomeWidget(),
      this.status = CenterWidgetStatus.initial,
      this.tabNames = const [],
      this.screens = const [],
      this.needRefresh = false,
      this.currentTabName = "",
      this.isLoading = false});

  @override
  // TODO: implement props
  List<Object?> get props => [
        status,
        tabList,
        centerWidget,
        tabNames,
        screens,
        needRefresh,
        currentTabName
      ];

  CenterWidgetState copywith(
      List<MyTab>? tabList,
      Widget? centerWidget,
      CenterWidgetStatus? status,
      List<String>? tabNames,
      List<Widget>? screens,
      bool? needRefresh,
      String? currentTabName,
      bool? isLoading) {
    return CenterWidgetState(
        centerWidget: centerWidget ?? this.centerWidget,
        tabList: tabList ?? this.tabList,
        status: status ?? this.status,
        tabNames: tabNames ?? this.tabNames,
        screens: screens ?? this.screens,
        needRefresh: needRefresh ?? this.needRefresh,
        currentTabName: currentTabName ?? this.currentTabName,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  bool operator ==(Object other) {
    if (status == CenterWidgetStatus.refresh ||
        status == CenterWidgetStatus.add ||
        status == CenterWidgetStatus.delete) {
      return false;
    }
    if (status == CenterWidgetStatus.notChanged) true;
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  int get hashCode => super.hashCode;
}
