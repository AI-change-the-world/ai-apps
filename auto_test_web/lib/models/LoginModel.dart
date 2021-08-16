class LoginModel {
  String? username;
  String? password;

  LoginModel({this.username, this.password});

  LoginModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}

class LoginDataModel {
  int? isLogged;
  int? isRoot;
  int? userId;

  LoginDataModel({this.isLogged, this.isRoot, this.userId});

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    isLogged = json['is_logged'] ?? 0;
    isRoot = json['is_root'] ?? 0;
    userId = json['user_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_logged'] = this.isLogged;
    data['is_root'] = this.isRoot;
    data['user_id'] = this.userId;
    return data;
  }
}
