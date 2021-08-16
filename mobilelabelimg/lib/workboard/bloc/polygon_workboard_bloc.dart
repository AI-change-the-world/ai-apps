/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2021-08-16 19:34:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2021-08-16 19:34:59
 */
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'polygon_workboard_event.dart';
part 'polygon_workboard_state.dart';

class PolygonWorkboardBloc
    extends Bloc<PolygonWorkboardEvent, PolygonWorkboardState> {
  PolygonWorkboardBloc() : super(PolygonWorkboardState());

  @override
  Stream<PolygonWorkboardState> mapEventToState(
    PolygonWorkboardEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
