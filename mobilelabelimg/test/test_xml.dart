import 'package:mobilelabelimg/entity/imageObjs.dart';
import 'package:xml/xml.dart';

main(List<String> args) {
  final bookshelfXml = '''<?xml version="1.0"?>
    <bookshelf>
      <book>
        <title lang="english">Growing a Language</title>
        <price>29.99</price>
      </book>
      <book>
        <title lang="english">Learning XML</title>
        <price>39.95</price>
      </book>
      <price>132.00</price>
    </bookshelf>''';
  final document = XmlDocument.parse(bookshelfXml);

  // print(document);

  Bndbox bndbox = Bndbox();
  bndbox.xmin = 20;
  bndbox.ymin = 20;
  bndbox.xmax = 120;
  bndbox.ymax = 200;

  final builder = XmlBuilder();
  builder.element("xmin", nest: bndbox.xmin);
  builder.element("xmax", nest: bndbox.xmax);
  builder.element("ymin", nest: bndbox.ymin);
  builder.element("ymax", nest: bndbox.ymax);

  ClassObject classObject = ClassObject();
  classObject.name = "asdads";
  classObject.difficult = 0;
  classObject.bndbox = bndbox;

  // var xml = builder.buildDocument();

  final _builder = XmlBuilder();
  _builder.element("name", nest: classObject.name);
  _builder.element("difficult", nest: classObject.difficult);
  _builder.element("bndbox", nest: () {
    _builder.element("xmin", nest: 20);
    _builder.element("xmax", nest: 40);
    _builder.element("ymin", nest: 20);
    _builder.element("ymax", nest: 80);
  });

  // var _xml = _builder.buildDocument();
  // print(_xml.toXmlString());

  ClassObject classObject1 = ClassObject();
  classObject1.name = "asdads1";
  classObject1.difficult = 0;
  classObject1.bndbox = bndbox;

  ClassObject classObject2 = ClassObject();
  classObject2.name = "asdads2";
  classObject2.difficult = 0;
  classObject2.bndbox = bndbox;

  ClassObject classObject3 = ClassObject();
  classObject3.name = "asdads3";
  classObject3.difficult = 0;
  classObject3.bndbox = bndbox;

  Annotation annotation = Annotation();
  annotation.filename = "asdasd.png";
  annotation.path = "./sa/as/asdasd.png";
  annotation.source = Source();
  annotation.size = ClassSize(width: 200, height: 200, depth: 1);
  annotation.segmented = 0;
  annotation.object = [classObject1, classObject2, classObject3];
  ImageObjs imageObjs = ImageObjs(annotation: annotation);
  // print(imageObjs.toXmlStr());

  String _s =
      "<annotation><folder>TEST</folder><filename>image_picker-94381381.jpg</filename><path>/data/user/0/com.xiaoshuyui.mobilelabelimg/cache/image_picker-94381381.jpg</path><source><database>Unknown</database></source><size><width>480</width><height>853</height><depth/></size><segmented>0</segmented><object><name>mess</name><difficult>0</difficult><bndbox><xmin>46</xmin><xmax>341</xmax><ymin>167</ymin><ymax>648</ymax></bndbox></object></annotation>";

  final _document = XmlDocument.parse(_s);
  // print(_document.children);
  final objets = _document.findAllElements("object");
  // print(objets);
  for (var i in objets) {
    print(i.findElements("name").first.firstChild);
    print(i
        .findElements("bndbox")
        .first
        .findElements("xmin")
        .first
        .firstChild
        .toString());
  }
}
