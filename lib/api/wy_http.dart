import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as Get;
import 'package:wy/ui/login/login_page.dart';
import '../config/app_config.dart';
import '../utils/platform_utils.dart';
import '../utils/storage_manager.dart';
import 'base_http.dart';
import 'dart:developer';

Http http = Http();
class Http extends BaseHttp {

  @override
  void init() async{

    options.baseUrl = AppConfig.getBaseServer();
    interceptors
      ..add(ApiInterceptor())
      ..add(HeaderInterceptor());
  }

}

class HeaderInterceptor extends InterceptorsWrapper{
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if(options.headers['X-Wanyoo-Token'] == null) {
      options.headers['X-Wanyoo-Token'] = StorageManager.getToken();
    }
    options.headers['platform'] = Platform.operatingSystem;
    handler.next(options);
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
  onResponse(Response response, ResponseInterceptorHandler handler) {
    log('api-response:$response',name: "WY_API");

    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      response.statusMessage = respData.msg;
      return handler.next(response);
    } else {
      if (respData.code == 401) {
        //throw const UnAuthorizedException(); // 需要登录
        EasyLoading.dismiss(animation: false);
        Get.Get.to(()=>LoginPage());
      } else {
        EasyLoading.dismiss(animation: false);
        if(respData.msg.isEmpty) {
          EasyLoading.showError("Server Failure", duration: Duration(seconds: 3));
        }else{
          EasyLoading.showError("${respData.msg}", duration: Duration(seconds: 3));
        }
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
    msg = json['msg'] == null?"":json['msg'];
    data = json['data'];
  }
}
