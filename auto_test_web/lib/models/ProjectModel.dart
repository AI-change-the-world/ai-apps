class ProjectModel {
  String? createTime;
  String? filePath;
  int? projectId;
  int? userId;
  String? projectName;
  String? projectUrl;

  ProjectModel({this.createTime, this.filePath, this.projectId, this.userId});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    createTime = json['create_time'];
    filePath = json['file_path'];
    projectId = json['project_id'];
    userId = json['user_id'];
    projectName = json['project_name'];
    projectUrl = json['project_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_time'] = this.createTime;
    data['file_path'] = this.filePath;
    data['project_id'] = this.projectId;
    data['user_id'] = this.userId;
    data['project_name'] = this.projectName;
    data['project_url'] = this.projectUrl;
    return data;
  }
}

class ProjectStartModel {
  int? userId;
  int? projectId;

  ProjectStartModel({this.userId, this.projectId});

  ProjectStartModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId ?? -1;
    data['project_id'] = this.projectId ?? -1;
    return data;
  }
}
