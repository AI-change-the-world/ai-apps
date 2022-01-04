// ignore_for_file: prefer_const_constructors, unused_local_variable

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:34:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-17 20:05:36
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobilelabelimg/entity/PolygonEntity.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:mobilelabelimg/entity/labelmeObj.dart';
import 'package:mobilelabelimg/widgets/polygon_points.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'polygon_workboard_event.dart';
part 'polygon_workboard_state.dart';

class PolygonWorkboardBloc
    extends Bloc<PolygonWorkboardEvent, PolygonWorkboardState> {
  PolygonWorkboardBloc() : super(PolygonWorkboardState()) {
    on<InitialEvent>(_fetchedToState);
    on<WidgetAddEvent>(_addWidget);
    on<PolygonEntityAddEvent>(_addPolyEntity);
    on<WidgetsRemoveEvent>(_removeWidget);
    on<PolygonEntityRemoveEvent>(_removePolygon);
    on<PolygonEntityChangeNameEvent>(_changeName);
    on<SetImgPathEvent>(_setImgPath);
    on<GetSingleImagePolygonEvent>(_getSingleFilePolygon);
    on<PointMoveEvent>(_moveEvent);
  }

  Future<void> _fetchedToState(
      InitialEvent event, Emitter<PolygonWorkboardState> emit) async {
    List<Widget> widgets = [];
    List<PolygonEntity> listPolygonEntity = [];
    return emit(state.copyWith(
        PolygonWorkboardStatus.initial, widgets, listPolygonEntity, ''));
  }

  Future<void> _addWidget(
      WidgetAddEvent event, Emitter<PolygonWorkboardState> emit) async {
    List<Widget> widgets = state.widgets;

    widgets.add(event.w);

    return emit(state.copyWith(
      PolygonWorkboardStatus.add,
      widgets,
      state.listPolygonEntity,
      state.imgPath,
    ));
  }

  Future<void> _addPolyEntity(
      PolygonEntityAddEvent event, Emitter<PolygonWorkboardState> emit) async {
    // PolygonEntity polygonEntity =
    //     PolygonEntity(keyList: [], pList: [], className: "", index: 0);
    List<PolygonEntity> ps = state.listPolygonEntity;
    ps.add(event.p);
    return emit(state.copyWith(
        PolygonWorkboardStatus.add, state.widgets, ps, state.imgPath));
  }

  Future<void> _removeWidget(
      WidgetsRemoveEvent event, Emitter<PolygonWorkboardState> emit) async {
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
    return emit(state.copyWith(PolygonWorkboardStatus.delete, _widgets,
        state.listPolygonEntity, state.imgPath));
  }

  Future<void> _removePolygon(PolygonEntityRemoveEvent event,
      Emitter<PolygonWorkboardState> emit) async {
    List<PolygonEntity> ps = state.listPolygonEntity;
    ps.removeAt(event.index);

    return emit(state.copyWith(
        PolygonWorkboardStatus.delete, state.widgets, ps, state.imgPath));
  }

  Future<void> _changeName(PolygonEntityChangeNameEvent event,
      Emitter<PolygonWorkboardState> emit) async {
    state.listPolygonEntity[event.index].className = event.name;
    return emit(state);
  }

  Future<void> _setImgPath(
      SetImgPathEvent event, Emitter<PolygonWorkboardState> emit) async {
    // state.imgPath = event.imgpath;
    return emit(state.copyWith(PolygonWorkboardStatus.refresh, state.widgets,
        state.listPolygonEntity, event.imgpath));
  }

  Future<void> _getSingleFilePolygon(GetSingleImagePolygonEvent event,
      Emitter<PolygonWorkboardState> emit) async {
    String _name, _ext;
    _name = event.filename.split("/").last.split(".").first;
    _ext = event.filename.split("/").last.split(".").last;
    String path = _name + "." + "json";
    String _filepath = event.filename;
    // List<Widget> widgets = [];
    List<PolygonEntity> listPolygonEntity = [];

    if (await Permission.storage.request().isGranted) {
      var value = await getExternalStorageDirectory();
      File file = File(value!.path + "/" + path);
      debugPrint(value.path + "/" + path);
      try {
        String content = file.readAsStringSync();
        var _obj = json.decode(content);
        // print(_obj.toString());
        final LabelmeObject labelmeObject = LabelmeObject.fromJson(_obj);
        List<Shapes> _shapes = labelmeObject.shapes!;
        for (var i in _shapes) {
          PolygonEntity polygonEntity = PolygonEntity(
              keyList: [],
              pList: [],
              index: _shapes.indexOf(i),
              className: i.label!);
          for (int j = 0; j < i.points!.length; j++) {
            double _dx = i.points![j][0] * 1.0;
            double _dy = i.points![j][1] * 1.0;
            GlobalKey<PolygonPointState> key = GlobalKey();
            PolygonPoint point = PolygonPoint(
                key: key,
                poffset: Offset(_dx, _dy),
                index: j + 1,
                isFirst: j == 0);
            if (_shapes.indexOf(i) > 0 && j == 0) {
              // print("我这里不需要插入一个占位point但是插入了。");
              state.widgets.add(PolygonPoint(
                poffset: Offset(-1, -1),
                index: -1,
                isFirst: false,
              ));
            }
            state.widgets.add(point);
            polygonEntity.keyList.add(key);
            polygonEntity.pList.add(point);
          }
          state.widgets.add(PolygonPoint(
            poffset: Offset(-1, -1),
            index: -1,
            isFirst: false,
          ));
          listPolygonEntity.add(polygonEntity);
        }
      } catch (e, stack) {
        debugPrint(stack.toString());
      }
      return emit(state.copyWith(PolygonWorkboardStatus.initial, state.widgets,
          listPolygonEntity, _filepath));
    } else {
      return emit(state.copyWith(
          PolygonWorkboardStatus.initial, state.widgets, [], ""));
    }
  }

  Future<void> _moveEvent(
      PointMoveEvent event, Emitter<PolygonWorkboardState> emit) async {
    PolygonEntity polygonEntity = state.listPolygonEntity[event.index];

    for (int i = 1; i < polygonEntity.keyList.length; i++) {
      polygonEntity.keyList[i].currentState!.moveTO(Offset(
          polygonEntity.keyList[i].currentState!.defaultLeft - event.x,
          polygonEntity.keyList[i].currentState!.defaultTop - event.y));
    }

    state.listPolygonEntity[event.index] = polygonEntity;

    return emit(state.copyWith(PolygonWorkboardStatus.refresh, state.widgets,
        state.listPolygonEntity, state.imgPath));
  }
}
