import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as Get;
import 'package:wy/main.dart';
import 'package:wy/service/location_service.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/show_error_widget.dart';

import '../config/app_config.dart';
import '../utils/platform_utils.dart';
import '../utils/storage_manager.dart';
import 'base_http.dart';

///是否正在登录
bool isSigningIn = false;

Http http = Http();

class Http extends BaseHttp {
  @override
  void init() async {
    options.baseUrl = AppConfig.getBaseServer();
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
      'api-request:${options.baseUrl}${options.path}' + ' queryParameters: ${options.queryParameters} data :${options.data} ',
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
        EasyLoading.dismiss(animation: false);
        var email = StorageManager.getAccount();
        var password = StorageManager.getPassword();
        if (email.isEmpty || password.isEmpty) {
          Get.Get.to(() => LoginPage());
        } else {
          if (isSigningIn) return;
          isSigningIn = true;
          await Get.Get.find<UserController>().login();
          isSigningIn = false;
        }
      } else {
        EasyLoading.dismiss(animation: false);
        if (respData.msg.isEmpty) {
          showErrorWidget("Server Failure");
        } else {
          showErrorWidget("${respData.msg}");
        }

        response.data = respData.data;
        response.statusMessage = respData.msg;
        return handler.next(response);
      }
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    EasyLoading.dismiss(animation: false);
    EasyLoading.showToast("Networking Failure");
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'] == null ? "" : json['msg'];
    data = json['data'];
    if (data == null && json["rows"] != null) {
      data = json;
    }
  }
}
