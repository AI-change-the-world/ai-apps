class LabelmeObject {
  /// flags is always {}
  Map? flags;
  String? imageData;
  int? imageHeight;
  String? imagePath;
  int? imageWidth;
  List<Shapes>? shapes;
  String? version;

  LabelmeObject(
      {this.imageData,
      this.imageHeight,
      this.imagePath,
      this.imageWidth,
      this.shapes,
      this.version});

  LabelmeObject.fromJson(Map<String, dynamic> json) {
    // flags = json['flags'] != null ? new Flags.fromJson(json['flags']) : null;
    imageData = json['imageData'];
    imageHeight = json['imageHeight'];
    imagePath = json['imagePath'];
    imageWidth = json['imageWidth'];
    if (json['shapes'] != null) {
      shapes = [];
      json['shapes'].forEach((v) {
        shapes!.add(new Shapes.fromJson(v));
      });
    }
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.flags != null) {
    //   data['flags'] = this.flags!.toJson();
    // }
    data['imageData'] = this.imageData;
    data['imageHeight'] = this.imageHeight;
    data['imagePath'] = this.imagePath;
    data['imageWidth'] = this.imageWidth;
    if (this.shapes != null) {
      data['shapes'] = this.shapes!.map((v) => v.toJson()).toList();
    }
    data['version'] = this.version;
    return data;
  }
}

// class Flags {

// 	Flags({});

// 	Flags.fromJson(Map<String, dynamic> json) {
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		return data;
// 	}
// }

class Shapes {
  /// flags is always {}
  Map? flags;
  String? groupId;
  String? label;
  List<PPoint>? points;
  String? shapeType;

  Shapes({this.groupId, this.label, this.points, this.shapeType});

  Shapes.fromJson(Map<String, dynamic> json) {
    // flags = json['flags'] != null ? new Flags.fromJson(json['flags']) : null;
    groupId = json['group_id'];
    label = json['label'];
    if (json['points'] != null) {
      points = [];
      json['points'].forEach((v) {
        points!.add(new PPoint.fromJson(v));
      });
    }
    shapeType = json['shape_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.flags != null) {
    //   data['flags'] = this.flags.toJson();
    // }
    data['group_id'] = this.groupId;
    data['label'] = this.label;
    if (this.points != null) {
      data['points'] = this.points!.map((v) => v.toJson()).toList();
    }
    data['shape_type'] = this.shapeType;
    return data;
  }
}

class PPoint {
  List<int>? ppoints;

  PPoint({this.ppoints});

  PPoint.fromJson(Map<String, dynamic> json) {
    ppoints = json['ppoints'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ppoints'] = this.ppoints;
    return data;
  }
}
