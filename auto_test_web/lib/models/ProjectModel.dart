class ProjectModel {
  String? createTime;
  String? filePath;
  int? projectId;
  int? userId;
  String? projectName;

  ProjectModel({this.createTime, this.filePath, this.projectId, this.userId});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    createTime = json['create_time'];
    filePath = json['file_path'];
    projectId = json['project_id'];
    userId = json['user_id'];
    projectName = json['project_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_time'] = this.createTime;
    data['file_path'] = this.filePath;
    data['project_id'] = this.projectId;
    data['user_id'] = this.userId;
    data['project_name'] = this.projectName;
    return data;
  }
}
