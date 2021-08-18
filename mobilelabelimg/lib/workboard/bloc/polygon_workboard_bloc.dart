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
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:mobilelabelimg/entity/labelmeObj.dart';
import 'package:provider/provider.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:mobilelabelimg/widgets/polygon_points.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

    if (event is SetImgPathEvent) {
      yield await _setImgPath(state, event);
    }

    if (event is GetSingleImagePolygonEvent) {
      yield await _getSingleFilePolygon(state, event);
    }

    if (event is PointMoveEvent) {
      yield await _moveEvent(state, event);
    }
  }

  Future<PolygonWorkboardState> _fetchedToState(
      PolygonWorkboardState state, InitialEvent event) async {
    List<Widget> widgets = [];
    List<PolygonEntity> listPolygonEntity = [];
    return state.copyWith(
        PolygonWorkboardStatus.initial, widgets, listPolygonEntity, '');
  }

  Future<PolygonWorkboardState> _addWidget(
      PolygonWorkboardState state, WidgetAddEvent event) async {
    List<Widget> widgets = state.widgets;

    widgets.add(event.w);

    return state.copyWith(
      PolygonWorkboardStatus.add,
      widgets,
      state.listPolygonEntity,
      state.imgPath,
    );
  }

  Future<PolygonWorkboardState> _addPolyEntity(
      PolygonWorkboardState state, PolygonEntityAddEvent event) async {
    // PolygonEntity polygonEntity =
    //     PolygonEntity(keyList: [], pList: [], className: "", index: 0);
    List<PolygonEntity> ps = state.listPolygonEntity;
    ps.add(event.p);
    return state.copyWith(
        PolygonWorkboardStatus.add, state.widgets, ps, state.imgPath);
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
    return state.copyWith(PolygonWorkboardStatus.delete, _widgets,
        state.listPolygonEntity, state.imgPath);
  }

  Future<PolygonWorkboardState> _removePolygon(
      PolygonWorkboardState state, PolygonEntityRemoveEvent event) async {
    List<PolygonEntity> ps = state.listPolygonEntity;
    ps.removeAt(event.index);

    return state.copyWith(
        PolygonWorkboardStatus.delete, state.widgets, ps, state.imgPath);
  }

  Future<PolygonWorkboardState> _changeName(
      PolygonWorkboardState state, PolygonEntityChangeNameEvent event) async {
    state.listPolygonEntity[event.index].className = event.name;
    return state;
  }

  Future<PolygonWorkboardState> _setImgPath(
      PolygonWorkboardState state, SetImgPathEvent event) async {
    // state.imgPath = event.imgpath;
    return state.copyWith(PolygonWorkboardStatus.refresh, state.widgets,
        state.listPolygonEntity, event.imgpath);
  }

  Future<PolygonWorkboardState> _getSingleFilePolygon(
      PolygonWorkboardState state, GetSingleImagePolygonEvent event) async {
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
      print(value.path + "/" + path);
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
        print(stack.toString());
      }
      return state.copyWith(PolygonWorkboardStatus.initial, state.widgets,
          listPolygonEntity, _filepath);
    } else {
      return state.copyWith(
          PolygonWorkboardStatus.initial, state.widgets, [], "");
    }
  }

  Future<PolygonWorkboardState> _moveEvent(
      PolygonWorkboardState state, PointMoveEvent event) async {
    // List<GlobalKey<PolygonPointState>> _keys = [];
    // List<PolygonPoint> _points = [];
    // for (var i in state.listPolygonEntity) {
    //   _keys.addAll(i.keyList);
    //   _points.addAll(i.pList);
    // }

    PolygonEntity polygonEntity = state.listPolygonEntity[event.index];

    // for (var i in polygonEntity.keyList) {
    //   i.currentState!.moveTO(Offset(i.currentState!.defaultLeft - event.x,
    //       i.currentState!.defaultTop - event.y));
    // }

    for (int i = 1; i < polygonEntity.keyList.length; i++) {
      polygonEntity.keyList[i].currentState!.moveTO(Offset(
          polygonEntity.keyList[i].currentState!.defaultLeft - event.x,
          polygonEntity.keyList[i].currentState!.defaultTop - event.y));
    }

    state.listPolygonEntity[event.index] = polygonEntity;

    // if (event.subkeys == []) {
    //   if (_keys.length >= 2) {
    //     for (int i = 1; i < _keys.length; i++) {
    //       _keys[i].currentState!.moveTO(Offset(
    //           _keys[i].currentState!.defaultLeft - event.x,
    //           _keys[i].currentState!.defaultTop - event.y));
    //     }
    //   }
    // } else {
    //   for (int i = 1; i < event.subkeys.length; i++) {
    //     event.subkeys[i].currentState!.moveTO(Offset(
    //         event.subkeys[i].currentState!.defaultLeft - event.x,
    //         event.subkeys[i].currentState!.defaultTop - event.y));
    //   }
    // }

    return state.copyWith(PolygonWorkboardStatus.refresh, state.widgets,
        state.listPolygonEntity, state.imgPath);
  }
}
