class CommenResponse {
  int? code;
  dynamic? data;
  String? message;

  CommenResponse({required this.code, this.data});

  CommenResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 11;
    data = json['data'] ?? "服务器异常";
    message = json["message"] ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['data'] = this.data;
    return data;
  }
}
