class Obj {
  String? classname;
  List<int>? region;

  Obj({required this.classname, required this.region});

  Obj.fromJson(Map<String, dynamic> json) {
    classname = json['classname'];
    region = json['region'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classname'] = this.classname;
    data['region'] = this.region;
    return data;
  }
}
