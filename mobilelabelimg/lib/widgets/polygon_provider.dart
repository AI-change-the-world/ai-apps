// import 'package:flutter/material.dart';
// import 'package:mobilelabelimg/entity/PolygonEntity.dart';
// import 'package:mobilelabelimg/widgets/polygon_points.dart';

part of './polygon.dart';

enum DrawingStatus { drawing, notDrawing }

class DrawingProvicer with ChangeNotifier {
  DrawingStatus _status = DrawingStatus.notDrawing;
  DrawingStatus get status => _status;
  void changeStatus(DrawingStatus status) {
    _status = status;
    notifyListeners();
  }
}

class MovePolygonProvider with ChangeNotifier {
  List<GlobalKey<PolygonPointState>> _keys = [];
  List<GlobalKey<PolygonPointState>> get keys => _keys;

  List<PolygonPoint> _points = [];
  List<PolygonPoint> get points => _points;

  void add(GlobalKey<PolygonPointState> key, PolygonPoint point) {
    _keys.add(key);
    _points.add(point);
    notifyListeners();
  }

  void move(double x, double y, {List subkeys = const []}) {
    if (subkeys == []) {
      if (_keys.length >= 2) {
        for (int i = 1; i < _keys.length; i++) {
          // keys[i].currentState!.defaultLeft =
          //     keys[i].currentState!.defaultLeft - x;
          // keys[i].currentState!.defaultTop = keys[i].currentState!.defaultTop - y;
          keys[i].currentState!.moveTO(Offset(
              keys[i].currentState!.defaultLeft - x,
              keys[i].currentState!.defaultTop - y));
        }
        notifyListeners();
      }
    } else {
      for (int i = 1; i < subkeys.length; i++) {
        // keys[i].currentState!.defaultLeft =
        //     keys[i].currentState!.defaultLeft - x;
        // keys[i].currentState!.defaultTop = keys[i].currentState!.defaultTop - y;
        subkeys[i].currentState!.moveTO(Offset(
            subkeys[i].currentState!.defaultLeft - x,
            subkeys[i].currentState!.defaultTop - y));
      }
      notifyListeners();
    }
  }
}

class AddOrRemovePolygonProvider with ChangeNotifier {
  List<PolygonEntity> _poList = [];
  List<PolygonEntity> get poList => _poList;

  void remove(int index) {
    _poList.removeAt(index);
    notifyListeners();
  }

  void add(PolygonEntity polygonEntity) {
    _poList.add(polygonEntity);
    notifyListeners();
  }

  void setName(int index, String name) {
    _poList[index].className = name;
    notifyListeners();
  }
}
