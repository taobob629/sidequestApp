import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' as Get;

import '../config/app_config.dart';
import '../controller/user_controller.dart';
import '../service/location_service.dart';
import '../ui/pages/login/login_page.dart';
import '../utils/platform_utils.dart';
import '../utils/storage_manager.dart';
import '../utils/toast_utils.dart';
import '../utils/utils.dart';
import 'base_http.dart';

///是否正在登录
bool isSigningIn = false;

Http http = Http();

class Http extends BaseHttp {
  @override
  void init() async {
    options.baseUrl = AppConfig.getBaseServer();
    // options.baseUrl = 'http://114.117.203.137:8081';
    interceptors
      ..add(ApiInterceptor())
      ..add(HeaderInterceptor());
  }
}

class HeaderInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers['X-Wanyoo-Token'] == null) {
      options.headers['X-Wanyoo-Token'] = StorageManager.getToken();
    }
    options.headers['platform'] = Platform.operatingSystem;
    options.headers['language'] = language();
    // options.headers['phoneModel'] =Platform.isIOS? deviceInfo['name']:  '${deviceInfo['manufacturer']}-${deviceInfo['brand']}';
    options.headers['longitude'] = LocationService().position?.longitude ?? 0;
    options.headers['latitude'] = LocationService().position?.latitude ?? 0;
    log(jsonEncode(options.headers), name: 'options.headers');
    handler.next(options);
  }
}

//语言 0中文
language() {
  Locale? locale = Get.Get.locale;
  var code = locale?.countryCode;
  switch (code) {
    case 'CN':
      return 0;
    default:
      return 1;
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    log(
      'api-request:${options.baseUrl}${options.path}' +
          ' queryParameters: ${options.queryParameters} data :${options.data} ',
      name: "WY_API",
    );
    //debugPrint('---api-request--->data--->${options.data}');
    handler.next(options);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) async {
    String requestPath = response.requestOptions.path;
    flog(' requestPath:$requestPath onResponse api-response ${response}');
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      response.statusMessage = respData.msg;
      return handler.next(response);
    } else {
      if (respData.code == 401) {
        //throw const UnAuthorizedException(); // 需要登录
        if (requestPath == '/peiwan/app/tim/getSig') {
          return handler.next(response);
        }
        dismissLoading(status: SmartStatus.loading);
        var email = StorageManager.getAccount();
        var password = StorageManager.getPassword();
        if (email.isEmpty || password.isEmpty) {
          Get.Get.to(() => LoginPage());
        } else {
          if (isSigningIn) return;
          isSigningIn = true;
          UserController.find.switchLogin();
        }
      } else {
        dismissLoading(status: SmartStatus.loading);
        if (respData.msg.isEmpty) {
          showError("Server Failure");
        } else {
          showError("${respData.msg}");
        }

        // response.data = respData.data;
        // response.statusMessage = respData.msg;
        // response.statusCode = respData.code;
        return handler.next(response);
      }
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    log(' onError: ${err.message}');
    dismissLoading(status: SmartStatus.loading);
    showToast("Networking Failure");
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    msg = json['msg'] == null ? "" : json['msg'];
    data = json['data'];
    if (data == null && json["rows"] != null) {
      data = json;
    }
  }
}
