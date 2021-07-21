import 'package:xml/xml.dart';

class ImageObjs {
  Annotation? annotation;

  ImageObjs({this.annotation});

  ImageObjs.fromJson(Map<String, dynamic> json) {
    annotation = json['annotation'] != null
        ? new Annotation.fromJson(json['annotation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.annotation != null) {
      data['annotation'] = this.annotation!.toJson();
    }
    return data;
  }

  String toXmlStr() {
    if (null != this.annotation) {
      final builder = XmlBuilder();
      builder.element("annotation", nest: () {
        builder.element("folder", nest: this.annotation!.folder);
        builder.element("filename", nest: this.annotation!.filename);
        builder.element("path", nest: this.annotation!.path);
        builder.element("source", nest: () {
          builder.element("database", nest: this.annotation!.source!.database);
        });
        builder.element("size", nest: () {
          builder.element("width", nest: this.annotation!.size!.width);
          builder.element("height", nest: this.annotation!.size!.height);
          builder.element("depth", nest: this.annotation!.size!.depth);
        });
        builder.element("segmented", nest: 0);
        if (null != this.annotation!.object) {
          // List objs = this.annotation!.object!;
          for (var i in this.annotation!.object!) {
            // print(i.toJson());
            builder.element("object", nest: () {
              builder.element("name", nest: i.name);
              builder.element("difficult", nest: i.difficult);
              builder.element("bndbox", nest: () {
                builder.element("xmin", nest: i.bndbox!.xmin);
                builder.element("xmax", nest: i.bndbox!.xmax);
                builder.element("ymin", nest: i.bndbox!.ymin);
                builder.element("ymax", nest: i.bndbox!.ymax);
              });
            });
          }
        }
      });

      var _xml = builder.buildDocument();
      return _xml.toXmlString();
    }

    return "";
  }
}

class Annotation {
  String? folder;
  String? filename;
  String? path;
  Source? source;
  ClassSize? size;
  int? segmented;
  List<ClassObject>? object;

  Annotation(
      {this.folder = "TEST",
      this.filename,
      this.path,
      this.source,
      this.size,
      this.segmented,
      this.object});

  Annotation.fromJson(Map<String, dynamic> json) {
    folder = json['folder'];
    filename = json['filename'];
    path = json['path'];
    source =
        json['source'] != null ? new Source.fromJson(json['source']) : null;
    size = json['size'] != null ? new ClassSize.fromJson(json['size']) : null;
    segmented = json['segmented'];
    if (json['object'] != null) {
      object = [];
      json['object'].forEach((v) {
        object!.add(new ClassObject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folder'] = this.folder;
    data['filename'] = this.filename;
    data['path'] = this.path;
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    if (this.size != null) {
      data['size'] = this.size!.toJson();
    }
    data['segmented'] = this.segmented;
    if (this.object != null) {
      data['object'] = this.object!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Source {
  String? database;

  Source({this.database = "Unknown"});

  Source.fromJson(Map<String, dynamic> json) {
    database = json['database'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['database'] = this.database;
    return data;
  }
}

class ClassSize {
  int? width;
  int? height;
  int? depth;

  ClassSize({this.width, this.height, this.depth});

  ClassSize.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    depth = json['depth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['depth'] = this.depth;
    return data;
  }
}

class ClassObject {
  String? name;
  int? difficult;
  Bndbox? bndbox;

  ClassObject({this.name, this.difficult = 0, this.bndbox});

  ClassObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    difficult = json['difficult'];
    bndbox =
        json['bndbox'] != null ? new Bndbox.fromJson(json['bndbox']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['difficult'] = this.difficult;
    if (this.bndbox != null) {
      data['bndbox'] = this.bndbox!.toJson();
    }
    return data;
  }
}

class Bndbox {
  int? xmin;
  int? ymin;
  int? xmax;
  int? ymax;

  Bndbox({this.xmin, this.ymin, this.xmax, this.ymax});

  Bndbox.fromJson(Map<String, dynamic> json) {
    xmin = json['xmin'];
    ymin = json['ymin'];
    xmax = json['xmax'];
    ymax = json['ymax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xmin'] = this.xmin;
    data['ymin'] = this.ymin;
    data['xmax'] = this.xmax;
    data['ymax'] = this.ymax;
    return data;
  }
}
