import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/model/level_model.dart';
import 'package:wy/model/skill_config_model.dart';
import 'package:wy/model/skill_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/utils/utils.dart';

class UserApi {
  static Future<UserInfoModel> info() async {
    var response = await http.get('/app/user/info', queryParameters: ({}));
    return UserInfoModel.fromJson(response.data);
  }

  static Future<String> uploadAvatar(
      File image, Function(int, int)? sendCallback) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(path, filename: name)
    });
    var response = await http.post('/app/user/uploadAvatar',
        data: formData, onSendProgress: sendCallback);

    return response.data['url'];
  }

  static Future<void> updateProfile(String nick, String birthday,
      String firstName, String lastName, String phone) async {
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
    var response =
        await http.get('/app/user/havePayPassword', queryParameters: ({}));
    return response.data['data'] != null && response.data['data'] == true;
  }

  static Future<bool> updatePayPassword(
      String oldPassword, String newPassword) async {
    var formData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    var response =
        await http.post('/app/user/updatePayPassword', data: formData);
    return response.data;
  }

  static Future<bool> updateLoginPassword(
      String oldPassword, String newPassword) async {
    var formData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
    var response = await http.post('/app/user/updatePassword', data: formData);
    return response.data;
  }

  static String generateMd5(String data) {
    if (data.isEmpty) {
      return data;
    }
    var bytes = utf8.encode(data);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  static Future<void> deleteAccount() async {
    await http.get('/app/user/delete', queryParameters: ({}));
  }

  static Future<List<AttentionModel>> attentionList(
      int pageNum, int pageSize) async {
    List<AttentionModel> list = [];
    var response = await http.get('/peiwan/app/user/followlist',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    list = response.data
        .map<AttentionModel>((item) => AttentionModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<SkillModel>> myauthlist() async {
    List<SkillModel> list = [];
    var response = await http.get('/peiwan/app/user/myauthlist');
    if (response.data == null) {
      return list;
    }
    list = response.data
        .map<SkillModel>((item) => SkillModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<SkillItemConfigModel?> skillItemConfig(var id) async {
    var response = await http.get('/peiwan/app/skillItem/getItems/$id');
    return SkillItemConfigModel.fromJson(response.data);
  }

  static Future<SkillItemConfigModel?> skillItemDetail(var id) async {
    var response = await http.get('/peiwan/app/skillItem/$id');
    return SkillItemConfigModel.fromJson(response.data);
  }

  static Future<Response> addSkillItem(Map<String, dynamic> params) async {
    var response = await http.post('/peiwan/app/skillItem/addItem',
        queryParameters: params);
    return response;
  }

  static Future<Response> deleteSkillItem(var id) async {
    var response = await http.get('/peiwan/app/skillItem/delete/$id');
    return response;
  }

  static Future<List<AttentionModel>> fansList(
      int pageNum, int pageSize) async {
    List<AttentionModel> list = [];
    var response = await http.get('/peiwan/app/user/fanslist',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    list = response.data
        .map<AttentionModel>((item) => AttentionModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<Response> attention(var touid) async {
    var response = await http.get('/peiwan/app/user/attention/$touid',
        queryParameters: ({}));
    return response;
  }

  /**
   * 玩家爵位查询
   */
  static Future<LevelModel> level(var type) async {
    var response = await http.get(
        type == TYPE_VIP
            ? '/peiwan/app/order/live/level'
            : '/peiwan/app/order/user/level',
        queryParameters: ({}));
    return LevelModel.fromJson(response.data);
  }
}
