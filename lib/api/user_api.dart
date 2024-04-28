import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sq_hub_app/api/wy_http.dart';

class UserApi {

  static Future<void> updateProfile(
      String nick, String birthday, String firstName, String lastName, String phone) async {
    await http.get('/app/user/updateProfile',
        queryParameters: ({
          'nick': nick,
          'birthday': birthday,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
        }));
  }

  static Future<bool> havePayPassword() async {
    var response = await http.get('/app/user/havePayPassword', queryParameters: ({}));
    return response.data['data'] != null && response.data['data'] == true;
  }

  static Future<bool> updatePayPassword(String oldPassword, String newPassword) async {
    var formData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    var response = await http.post('/app/user/updatePayPassword', data: formData);
    return response.data;
  }

  static Future<bool> updateLoginPassword(String oldPassword, String newPassword) async {
    var formData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    var response = await http.post('/app/user/updatePassword', data: formData);
    return response.data;
  }

  static Future<void> deleteAccount() async {
    await http.get('/app/user/delete', queryParameters: ({}));
  }

  /**
   * 确认用户密码是否正确
   */
  static Future<Response> confirmPwd(var pwd) async {
    var response = await http.get('/peiwan/app/users/deleteCheck',
        queryParameters: ({'password': pwd}));
    return response;
  }
}
