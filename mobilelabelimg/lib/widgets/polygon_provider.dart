part of 'polygon.dart';

enum DrawingStatus { drawing, notDrawing }

class DrawingProvicer with ChangeNotifier {
  DrawingStatus _status = DrawingStatus.drawing;
  DrawingStatus get status => _status;
  void changeStatus(DrawingStatus status) {
    _status = status;
    notifyListeners();
  }
}
