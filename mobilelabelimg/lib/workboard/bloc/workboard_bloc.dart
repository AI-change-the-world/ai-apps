import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:mobilelabelimg/entity/imageObjs.dart';
import 'package:mobilelabelimg/widgets/rect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:xml/xml.dart';

part 'workboard_event.dart';
part 'workboard_state.dart';

class WorkboardBloc extends Bloc<WorkboardEvent, WorkboardState> {
  WorkboardBloc() : super(WorkboardState());

  @override
  Stream<WorkboardState> mapEventToState(
    WorkboardEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is RectIntial) {
      yield await _fetchedToState(state);
    }

    if (event is RectAdded) {
      yield await _addToState(state, event);
    }

    if (event is RectRemove) {
      yield await _removeToState(state, event);
    }

    if (event is GetSingleImageRects) {
      yield await _getSingleImageRectsToState(state, event);
    }
  }

  @override
  Stream<Transition<WorkboardEvent, WorkboardState>> transformEvents(
    Stream<WorkboardEvent> events,
    TransitionFunction<WorkboardEvent, WorkboardState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  Future<WorkboardState> _fetchedToState(WorkboardState state) async {
    final List<RectBox> rectboxes = [];
    // state.param.rectBoxes.addAll(rectboxes);
    ImageRectBox imageRectBox = ImageRectBox(imageName: "", rectBoxes: []);
    imageRectBox.rectBoxes.addAll(rectboxes);
    return state.copyWith(WorkboardStatus.initial, imageRectBox);
  }

  Future<WorkboardState> _addToState(
      WorkboardState state, RectAdded event) async {
    ImageRectBox imageRectBox =
        ImageRectBox(imageName: "", rectBoxes: state.param.rectBoxes);
    imageRectBox.rectBoxes.add(RectBox(id: event.id));
    // state.param.rectBoxes.add(RectBox(id: event.id));
    return state.copyWith(WorkboardStatus.add, imageRectBox);
  }

  Future<WorkboardState> _removeToState(
      WorkboardState state, RectRemove event) async {
    ImageRectBox imageRectBox = ImageRectBox(imageName: "", rectBoxes: []);
    var rectBoxes =
        state.param.rectBoxes.where((element) => element.id != event.id);
    imageRectBox.rectBoxes.addAll(rectBoxes);
    return state.copyWith(
      WorkboardStatus.delete,
      imageRectBox,
    );
  }

  Future<WorkboardState> _getSingleImageRectsToState(
      WorkboardState state, GetSingleImageRects event) async {
    String _name, _ext;
    _name = event.filename.split("/").last.split(".").first;
    _ext = event.filename.split("/").last.split(".").last;
    String path = _name + "." + "xml";
    ImageRectBox imageRectBox = ImageRectBox(imageName: path, rectBoxes: []);
    // imageRectBox.imageName = path;
    if (await Permission.storage.request().isGranted) {
      var value = await getExternalStorageDirectory();
      File file = File(value!.path + "/" + path);
      try {
        String content = file.readAsStringSync();
        final _document = XmlDocument.parse(content);
        final objects = _document.findAllElements("object");
        int index = 0;
        print("***********************************");
        print(objects);
        print("***********************************");
        for (var i in objects) {
          Bndbox bndbox = Bndbox();
          String name = i.findElements("name").first.firstChild.toString();
          bndbox.xmin = int.parse(i
              .findElements("bndbox")
              .first
              .findElements("xmin")
              .first
              .firstChild
              .toString());
          bndbox.ymax = int.parse(i
              .findElements("bndbox")
              .first
              .findElements("ymax")
              .first
              .firstChild
              .toString());
          bndbox.xmax = int.parse(i
              .findElements("bndbox")
              .first
              .findElements("xmax")
              .first
              .firstChild
              .toString());
          bndbox.ymin = int.parse(i
              .findElements("bndbox")
              .first
              .findElements("ymin")
              .first
              .firstChild
              .toString());

          RectBox rectBox = RectBox(id: index);
          index += 1;
          imageRectBox.rectBoxes.add(rectBox);
        }
      } catch (e) {
        print(e);
      }

      return state.copyWith(WorkboardStatus.add, imageRectBox);
    } else {
      return state.copyWith(WorkboardStatus.add, imageRectBox);
    }
  }
}
