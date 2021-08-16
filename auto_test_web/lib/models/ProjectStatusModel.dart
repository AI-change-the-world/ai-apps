class StatusModel {
  String? actionTime;
  int? adminId;
  String? endTime;
  int? failTimes;
  int? projrctId;
  String? resultPath;
  String? startTime;
  int? successTimes;
  int? testTimes;
  int? totalApiTimes;

  StatusModel(
      {this.actionTime,
      this.adminId,
      this.endTime,
      this.failTimes,
      this.projrctId,
      this.resultPath,
      this.startTime,
      this.successTimes,
      this.testTimes,
      this.totalApiTimes});

  StatusModel.fromJson(Map<String, dynamic> json) {
    actionTime = json['action_time'];
    adminId = json['admin_id'];
    endTime = json['end_time'];
    failTimes = json['fail_times'];
    projrctId = json['projrct_id'];
    resultPath = json['result_path'];
    startTime = json['start_time'];
    successTimes = json['success_times'];
    testTimes = json['test_times'];
    totalApiTimes = json['total_api_times'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_time'] = this.actionTime;
    data['admin_id'] = this.adminId;
    data['end_time'] = this.endTime;
    data['fail_times'] = this.failTimes;
    data['projrct_id'] = this.projrctId;
    data['result_path'] = this.resultPath;
    data['start_time'] = this.startTime;
    data['success_times'] = this.successTimes;
    data['test_times'] = this.testTimes;
    data['total_api_times'] = this.totalApiTimes;
    return data;
  }
}
