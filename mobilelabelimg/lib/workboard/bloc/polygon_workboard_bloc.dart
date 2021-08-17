/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:34:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-16 22:37:10
 */
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobilelabelimg/entity/PolygonEntity.dart';
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:mobilelabelimg/widgets/drawer_button_list.dart';
import 'package:mobilelabelimg/widgets/polygon_points.dart';

part 'polygon_workboard_event.dart';
part 'polygon_workboard_state.dart';

class PolygonWorkboardBloc
    extends Bloc<PolygonWorkboardEvent, PolygonWorkboardState> {
  PolygonWorkboardBloc() : super(PolygonWorkboardState());

  @override
  Stream<PolygonWorkboardState> mapEventToState(
    PolygonWorkboardEvent event,
  ) async* {
    if (event is InitialEvent) {
      yield await _fetchedToState(state, event);
    }

    if (event is WidgetAddEvent) {
      yield await _addWidget(state, event);
    }

    if (event is PolygonEntityAddEvent) {
      yield await _addPolyEntity(state, event);
    }

    if (event is WidgetsRemoveEvent) {
      yield await _removeWidget(state, event);
    }

    if (event is PolygonEntityRemoveEvent) {
      yield await _removePolygon(state, event);
    }

    if (event is PolygonEntityChangeNameEvent) {
      yield await _changeName(state, event);
    }
  }

  Future<PolygonWorkboardState> _fetchedToState(
      PolygonWorkboardState state, InitialEvent event) async {
    List<Widget> widgets = [];
    List<PolygonEntity> listPolygonEntity = [];
    return state.copyWith(
        PolygonWorkboardStatus.initial, widgets, listPolygonEntity);
  }

  Future<PolygonWorkboardState> _addWidget(
      PolygonWorkboardState state, WidgetAddEvent event) async {
    List<Widget> widgets = state.widgets;
    widgets.add(event.w);
    return state.copyWith(
        PolygonWorkboardStatus.add, widgets, state.listPolygonEntity);
  }

  Future<PolygonWorkboardState> _addPolyEntity(
      PolygonWorkboardState state, PolygonEntityAddEvent event) async {
    PolygonEntity polygonEntity =
        PolygonEntity(keyList: [], pList: [], className: "", index: 0);
    List<PolygonEntity> ps = state.listPolygonEntity;
    ps.add(polygonEntity);
    return state.copyWith(PolygonWorkboardStatus.add, state.widgets, ps);
  }

  Future<PolygonWorkboardState> _removeWidget(
      PolygonWorkboardState state, WidgetsRemoveEvent event) async {
    List<int> indexes = [];
    List<Widget> _widgets = state.widgets;
    for (int i = 0; i < state.widgets.length; i++) {
      if (state.widgets[i].runtimeType == PolygonPoint &&
          (state.widgets[i] as PolygonPoint).isFirst) {
        indexes.add(i);
      }
    }
    if (event.index < indexes.length - 1) {
      int start = indexes[event.index];
      int end = indexes[event.index + 1];
      _widgets.removeRange(start, end);
    } else {
      int start = indexes[event.index];
      _widgets.removeRange(start, state.widgets.length - 1);
    }
    return state.copyWith(
        PolygonWorkboardStatus.delete, _widgets, state.listPolygonEntity);
  }

  Future<PolygonWorkboardState> _removePolygon(
      PolygonWorkboardState state, PolygonEntityRemoveEvent event) async {
    List<PolygonEntity> ps = state.listPolygonEntity;
    ps.removeAt(event.index);

    return state.copyWith(PolygonWorkboardStatus.delete, state.widgets, ps);
  }

  Future<PolygonWorkboardState> _changeName(
      PolygonWorkboardState state, PolygonEntityChangeNameEvent event) async {
    state.listPolygonEntity[event.index].className = event.name;
    return state;
  }
}
