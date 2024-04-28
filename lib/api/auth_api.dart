import 'package:sq_hub_app/utils/storage_manager.dart';

import '../model/login_model.dart';
import '../model/qr_login.dart';
import '../model/qr_login_info.dart';
import '../model/user_model.dart';
import '../utils/platform_utils.dart';
import 'base_http.dart';
import 'wy_http.dart';

class AuthApi {
  static Future<String> sendEmail(
    String email,
    String guardian,
    int type,
  ) async {
    var response = await http.get('/web/index/sendEmail',
        queryParameters: ({
          'email': email,
          'guardian': guardian,
          'type': type
        }));
    return response.data["uid"];
  }

  static Future<bool> verifyCode(
    String code,
    String uid,
  ) async {
    var response = await http.get('/web/index/appRegvalidCode',
        queryParameters: ({
          'code': code,
          'uid': uid,
        }));
    return response.data['validated'] == true;
  }

  static Future<String> resendEmail(String email) async {
    var response = await http.get('/web/index/sendValidCode',
        queryParameters: ({'email': email}));
    return response.data["uid"];
  }

  static Future<void> signUp(
    // String firstName,
    // String lastName,
    String nick,
    String phone,
    String email,
    String birth,
    String password,
    String code,
    String uid,
    String pin,
    String invite,
    int sex,
  ) async {
    String version = await PlatformUtils.getAppVersion();
    String location = "$version@${Platform.operatingSystem}";
    var formData = {
      // "firstName": firstName,
      // "lastName": lastName,
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

  static Future<LoginModel> signUp2(
    String nick,
    String phone,
    String email,
    String birth,
    String password,
    String code,
    String uid,
    String pin,
    String invite,
    int sex,
  ) async {
    String version = await PlatformUtils.getAppVersion();
    String location = "$version@${Platform.operatingSystem}";
    var formData = {
      // "firstName": firstName,
      // "lastName": lastName,
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
    final response = await http.post('/web/index/appRegister', data: formData);
    return LoginModel.fromJson(response.data);
  }

  static Future<void> updateProfile(
    String password,
    // String firstName,
    // String lastName,
    String nick,
    String phone,
    String email,
    String birth,
    String code,
    String uid,
    String pin,
    String token,
  ) async {
    String version = await PlatformUtils.getAppVersion();
    String location = "$version@${Platform.operatingSystem}";
    var formData = {
      // "firstName": firstName,
      // "lastName": lastName,
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

  static Future<bool> reset(
    String email,
    String password,
    String code,
    String uid,
  ) async {
    var formData = {
      "email": email,
      "password": password,
      "verifyCode": code,
      "uid": uid,
    };
    final result = await http.post('/web/index/reset', data: formData);
    try {
      if (result.data == null) {
        return result.statusCode == 200;
      }
      int code = result.data['code'];
      return code == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<String> resendPinEmail(String email) async {
    var response = await http.get('/app/user/sendEmailCode',
        queryParameters: ({'email': email}));
    return response.data["uid"];
  }

  static Future<bool> resetPin(
    String email,
    String password,
    String code,
    String uid,
  ) async {
    var formData = {
      "email": email,
      "newPayCode": password,
      "verifyCode": code,
      "uid": uid,
    };
    final result =
        await http.post('/app/user/resetPayPassword', data: formData);
    try {
      if (result.data == null) {
        return result.statusCode == 200;
      }
      int code = result.data['code'];
      return code == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<LoginModel> signIn(
    String email,
    String password,
  ) async {
    String pushToken = StorageManager.getPushToken();
    var formData = {
      "username": email,
      "password": password,
      "pushToken": pushToken
    };
    var response = await http.post('/web/index/login', data: formData);
    return LoginModel.fromJson(response.data);
  }

  static Future<LoginModel> signInDiscord(
    String url,
    String? discordAppId,
    String? email,
    String? nickName,
    String? discriminator, {
    String? birth,
    String? sex,
  }) async {
    var formData = {
      'discordAppId': discordAppId,
      'email': email,
      'nickName': nickName,
      'discriminator': discriminator,
      'birth': birth,
      'sex': sex,
    };
    var response = await http.post(
      url,
      data: formData,
    );
    return LoginModel.fromJson(response.data);
  }

  static Future<void> signOut() async {
    await http.post(
      '/web/index/logout',
    );
  }

  static Future<void> appNotifyCallback(
    int memberId,
    String extInfo,
    String platform,
  ) async {
    var formData = {
      "memberId": memberId,
      "extInfo": extInfo,
      "platform": platform,
    };

    await http.post('/web/extra/appNotifyCallback', data: formData);
  }

  static Future<QrLoginInfoModel> scanInfo(String code) async {
    var formData = {
      "secret": code,
    };

    var response = await http.post('/app/index/scanInfo', data: formData);
    return QrLoginInfoModel.fromJson(response.data);
  }

  static Future<QrLoginModel> qrCodeLogin(String code) async {
    var formData = {
      "secret": code,
    };
    var res = await http.post('/app/index/qrcode/login', data: formData);
    return QrLoginModel.fromJson(res.data);
  }
}
