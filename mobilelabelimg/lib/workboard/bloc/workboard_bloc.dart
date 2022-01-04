import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilelabelimg/entity/imageObjs.dart';
import 'package:mobilelabelimg/widgets/rect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:xml/xml.dart';

part 'workboard_event.dart';
part 'workboard_state.dart';

class WorkboardBloc extends Bloc<WorkboardEvent, WorkboardState> {
  WorkboardBloc() : super(WorkboardState()) {
    on<RectIntial>(_fetchedToState);
    on<RectAdded>(_addToState);
    on<RectRemove>(_removeToState);
    on<GetSingleImageRects>(_getSingleImageRectsToState);
    on<ForceRefresh>(_forceRefresh);
    on<ChangeFactorEvent>(_changeFactor);
  }

  Future<void> _changeFactor(
      ChangeFactorEvent event, Emitter<WorkboardState> emit) async {
    return emit(
        state.copyWith(WorkboardStatus.refresh, state.param, event.factor));
  }

  Future<void> _fetchedToState(
      RectIntial event, Emitter<WorkboardState> emit) async {
    final List<RectBox> rectboxes = [];
    // state.param.rectBoxes.addAll(rectboxes);
    ImageRectBox imageRectBox = ImageRectBox(imageName: "", rectBoxes: []);
    imageRectBox.rectBoxes.addAll(rectboxes);
    return emit(state.copyWith(
        WorkboardStatus.initial, imageRectBox, state.currentFactor));
  }

  Future<void> _addToState(
      RectAdded event, Emitter<WorkboardState> emit) async {
    ImageRectBox imageRectBox = ImageRectBox(
        imageName: state.param.imageName,
        rectBoxes: state.param.rectBoxes,
        imagePath: state.param.imagePath);
    imageRectBox.rectBoxes.add(RectBox(
      id: event.id,
      // imgName: "",
    ));
    // state.param.rectBoxes.add(RectBox(id: event.id));
    return emit(
        state.copyWith(WorkboardStatus.add, imageRectBox, state.currentFactor));
  }

  Future<void> _removeToState(
      RectRemove event, Emitter<WorkboardState> emit) async {
    ImageRectBox imageRectBox = ImageRectBox(
        imageName: state.param.imageName,
        rectBoxes: [],
        imagePath: state.param.imagePath);
    var rectBoxes =
        state.param.rectBoxes.where((element) => element.id != event.id);
    imageRectBox.rectBoxes.addAll(rectBoxes);
    return emit(state.copyWith(
        WorkboardStatus.delete, imageRectBox, state.currentFactor));
  }

  Future<void> _getSingleImageRectsToState(
      GetSingleImageRects event, Emitter<WorkboardState> emit) async {
    String _name, _ext;
    _name = event.filename.split("/").last.split(".").first;
    _ext = event.filename.split("/").last.split(".").last;
    String path = _name + "." + "xml";
    ImageRectBox imageRectBox =
        ImageRectBox(imageName: path, rectBoxes: [], imagePath: event.filename);
    // imageRectBox.imageName = path;
    if (await Permission.storage.request().isGranted) {
      var value = await getExternalStorageDirectory();
      File file = File(value!.path + "/" + path);
      try {
        String content = file.readAsStringSync();
        final _document = XmlDocument.parse(content);
        // print(_document);
        final objects = _document.findAllElements("object");
        int index = 0;
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

          if (bndbox.xmin! < bndbox.xmax! && bndbox.ymin! < bndbox.ymax!) {
            ClassObject classObject = ClassObject(name: name, bndbox: bndbox);

            RectBox rectBox = RectBox(
              id: index,
              classObject: classObject,
              // imgName: event.filename,
            );
            index += 1;
            imageRectBox.rectBoxes.add(rectBox);
          }
        }
      } catch (e) {
        print(e);
      }

      return emit(state.copyWith(
          WorkboardStatus.add, imageRectBox, state.currentFactor));
    } else {
      return emit(state.copyWith(
          WorkboardStatus.add, imageRectBox, state.currentFactor));
    }
  }

  Future<void> _forceRefresh(
      ForceRefresh event, Emitter<WorkboardState> emit) async {
    return emit(state.copyWith(
        WorkboardStatus.refresh, state.param, state.currentFactor));
  }
}
