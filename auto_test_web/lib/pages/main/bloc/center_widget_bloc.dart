/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-03 19:25:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-03 20:55:39
 */
import 'dart:async';

import 'package:auto_test_web/pages/main/main_page_provider.dart';
import 'package:auto_test_web/widgets/side_menu.dart';
import 'package:auto_test_web/widgets/welcome_widget.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:rxdart/rxdart.dart';

part 'center_widget_event.dart';
part 'center_widget_state.dart';

class CenterWidgetBloc extends Bloc<CenterWidgetEvent, CenterWidgetState> {
  CenterWidgetBloc() : super(const CenterWidgetState());

  @override
  Stream<CenterWidgetState> mapEventToState(
    CenterWidgetEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is WidgetInit) {
      yield await _fetchedToState(state);
    }

    if (event is WidgetAdd) {
      yield await _addToState(state, event);
    }

    if (event is WidgetDelete) {
      yield await _deleteToState(state, event);
    }
  }

  @override
  Stream<Transition<CenterWidgetEvent, CenterWidgetState>> transformEvents(
    Stream<CenterWidgetEvent> events,
    TransitionFunction<CenterWidgetEvent, CenterWidgetState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  Future<CenterWidgetState> _fetchedToState(CenterWidgetState state) async {
    final List<MyTab> tabs = [];
    tabs.add(MyTab(text: "首页"));
    Widget center = const WelcomeWidget();
    List<Widget> screens = [];
    screens.add(center);
    return state.copywith(
        tabs, center, CenterWidgetStatus.initial, ["首页"], screens);
  }

  Future<CenterWidgetState> _addToState(
      CenterWidgetState state, WidgetAdd event) async {
    if (state.tabNames.contains(event.widgetName)) {
      int id = state.tabNames.indexOf(event.widgetName);
      return state.copywith(state.tabList, state.screens[id],
          CenterWidgetStatus.refresh, state.tabNames, state.screens);
    } else {
      Widget newWidget = MainCenterWidget(
        widgetName: event.widgetName,
      );
      MyTab newTab = MyTab(text: event.widgetName);

      return state.copywith(
          List.of(state.tabList)..add(newTab),
          newWidget,
          CenterWidgetStatus.add,
          List.of(state.tabNames)..add(event.widgetName),
          List.of(state.screens)..add(newWidget));
    }
  }

  Future<CenterWidgetState> _deleteToState(
      CenterWidgetState state, WidgetDelete event) async {
    int id = state.tabNames.indexOf(event.widgetName);
    return state.copywith(
        List.of(state.tabList)..removeAt(id),
        state.screens[0],
        CenterWidgetStatus.add,
        List.of(state.tabNames)..removeAt(id),
        List.of(state.screens)..removeAt(id));
  }
}
