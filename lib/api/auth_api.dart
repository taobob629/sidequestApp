import 'dart:developer';

import 'package:wy/api/base_http.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/utils/platform_utils.dart';
import 'package:wy/utils/storage_manager.dart';

import '../model/user_model.dart';
import 'wy_http.dart';

class AuthApi {
  static Future<String> sendEmail(
      String email, String guardian, int type) async {
    var response = await http.get('/web/index/sendEmail',
        queryParameters: ({
          'email': email,
          'guardian': guardian,
          'type': type
        }));
    return response.data["uid"];
  }

  static Future<String> resendEmail(String email) async {
    var response = await http.get('/web/index/sendValidCode',
        queryParameters: ({'email': email}));
    return response.data["uid"];
  }

  static Future<void> signUp(
      String firstName,
      String lastName,
      String nick,
      String phone,
      String email,
      String birth,
      String password,
      String code,
      String uid,
      String pin,
      String invite,
      int sex) async {
    String version = await PlatformUtils.getAppVersion();
    String location = "$version@${Platform.operatingSystem}";
    var formData = {
      "firstName": firstName,
      "lastName": lastName,
      "nickname": nick,
      "phone": phone,
      "email": email,
      "birth": birth,
      "password": password,
      "payCode": pin,
      "verifyCode": code,
      "uid": uid,
      "location": location,
      "invite": invite,
      "sex": sex,
    };
    await http.post('/web/index/register', data: formData);
  }

  static Future<UserModel> validateInfo(
      String name, String value, String token) async {
    var formData = {
      "name": name,
      "value": value,
    };
    Options options = Options(headers: {'X-Wanyoo-Token': token});
    var response = await http.post('/web/index/secondary',
        queryParameters: ({
          'name': name,
          'value': value,
        }),
        data: formData,
        options: options);

    return UserModel.fromJson(response.data);
  }

  static Future<void> updateProfile(
      String password,
      String firstName,
      String lastName,
      String nick,
      String phone,
      String email,
      String birth,
      String code,
      String uid,
      String pin,
      String token) async {
    String version = await PlatformUtils.getAppVersion();
    String location = "$version@${Platform.operatingSystem}";
    var formData = {
      "firstName": firstName,
      "lastName": lastName,
      "nickname": nick,
      "phone": phone,
      "email": email,
      "birth": birth,
      "password": password,
      "payCode": pin,
      "verifyCode": code,
      "uid": uid,
      "location": location,
    };
    Options options = Options(headers: {'X-Wanyoo-Token': token});
    await http.post('/web/index/updateUser', data: formData, options: options);
  }

  static Future<void> reset(
      String email, String password, String code, String uid) async {
    var formData = {
      "email": email,
      "password": password,
      "verifyCode": code,
      "uid": uid,
    };
    await http.post('/web/index/reset', data: formData);
  }

  static Future<String> resendPinEmail(String email) async {
    var response = await http.get('/app/user/sendEmailCode',
        queryParameters: ({'email': email}));
    return response.data["uid"];
  }

  static Future<void> resetPin(
      String email, String password, String code, String uid) async {
    var formData = {
      "email": email,
      "newPayCode": password,
      "verifyCode": code,
      "uid": uid,
    };
    await http.post('/app/user/resetPayPassword', data: formData);
  }

  static Future<LoginModel> signIn(String email, String password) async {
    String pushToken = StorageManager.getPushToken();
    var formData = {
      "username": email,
      "password": password,
      "pushToken": pushToken
    };
    var response = await http.post('/web/index/login', data: formData);
    return LoginModel.fromJson(response.data);
  }

  static Future<void> signOut() async {
    await http.post(
      '/web/index/logout',
    );
  }

  static Future<void> qrCodeLogin(String code) async {
    var formData = {
      "secret": code,
    };
    log("qrCodeLogin::$code", name: "WY");
    await http.post('/app/index/qrcode/login', data: formData);
  }
}
