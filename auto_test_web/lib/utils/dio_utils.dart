import 'dart:convert';

import 'package:auto_test_web/models/CommonRes.dart';
import 'package:auto_test_web/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginInterceptors extends Interceptor {
  late int _resultCode;
  // String _resultMsg;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains("user_id")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var _userId = prefs.getInt("userid");
      // print("===================");
      // print(_userId);
      // print("===================");
      if (null == _userId) {
        _userId = -1;
      }

      /// 测试用token
      // _token = '543789e9d8b22554ca9ed37f2431cc5626';
      options.path = options.path + _userId.toString();
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
    // print("发生了错误");
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    CommenResponse commenResponse =
        CommenResponse.fromJson(jsonDecode(response.toString()));
    _resultCode = commenResponse.code ?? 11;

    /// token过期,未授权的情况
    // if (_resultCode == 23) {
    //   NavigatorState navigatorState = Global.navigatorKey.currentState!;
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   if (navigatorState != null) {
    //     var _trigged = prefs.getInt("trigged");
    //     if (null == _trigged) {
    //       _trigged = 0;
    //       await prefs.setInt("trigged", _trigged);
    //     }
    //     if (_trigged == 0) {
    //       await prefs.setInt("trigged", _trigged + 1);
    //       Fluttertoast.showToast(
    //           msg: "当前登陆状态已失效，请重新登陆",
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.CENTER,
    //           timeInSecForIosWeb: 1,
    //           backgroundColor: Colors.orange,
    //           textColor: Colors.white,
    //           fontSize: 16.0);

    //       navigatorState
    //           .push(MaterialPageRoute(builder: (context) => LoginPage()));
    //     } else {
    //       await prefs.setInt("trigged", _trigged + 1);
    //     }
    //   }
    // } else

    if (_resultCode == 11) {
      showToastMessage(commenResponse.message.toString(), null);
    } else {
      return super.onResponse(response, handler);
    }
  }
}

class DioUtil {
  static DioUtil _instance = DioUtil._internal();
  factory DioUtil() => _instance;
  Dio? _dio;

  DioUtil._internal() {
    if (null == _dio) {
      _dio = Dio();
      _dio!.interceptors.add(LoginInterceptors());
    }
  }

  addInterceptors(Interceptor i) {
    _dio!.interceptors.clear();
    _dio!.interceptors.add(i);
  }

  ///get请求方法
  get(url, {params, options, cancelToken}) async {
    late Response response;
    try {
      response = await _dio!.get(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      debugPrint('getHttp exception: $e');
      formatError(e);
    }
    return response;
  }

  ///put请求方法
  put(url, {data, params, options, cancelToken}) async {
    late Response response;
    try {
      response = await _dio!.put(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e) {
      debugPrint('getHttp exception: $e');
      formatError(e);
    }
    return response;
  }

  ///post请求
  post(url, {data, params, options, cancelToken}) async {
    late Response response;
    try {
      response = await _dio!.post(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e) {
      debugPrint('getHttp exception: $e');
      formatError(e);
    }
    return response;
  }

  //取消请求
  cancleRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      debugPrint("连接超时");
      showToastMessage("连接超时", null);
    } else if (e.type == DioErrorType.sendTimeout) {
      debugPrint("请求超时");
      showToastMessage("请求超时", null);
    } else if (e.type == DioErrorType.receiveTimeout) {
      debugPrint("响应超时");
      showToastMessage("响应超时", null);
    } else if (e.type == DioErrorType.response) {
      debugPrint("出现异常");
      showToastMessage("出现异常", null);
    } else if (e.type == DioErrorType.cancel) {
      debugPrint("请求取消");
      showToastMessage("请求取消", null);
    } else {
      debugPrint("未知错误");
      showToastMessage("未知错误", null);
    }
  }
}
