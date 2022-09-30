import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/model/user_info_model.dart';

class UserApi {
  static Future<UserInfoModel> info() async {
    var response = await http.get('/app/user/info',
      queryParameters: ({})
    );
    return UserInfoModel.fromJson(response.data);
  }

  static Future<String> uploadAvatar(File image, Function(int,int)? sendCallback) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(path, filename: name)
    });
    var response = await http.post('/app/user/uploadAvatar', data: formData, onSendProgress: sendCallback);

    return response.data['url'];
  }

  static Future<void> updateProfile(String nick, String birthday, String firstName, String lastName,String phone) async {
    await http.get('/app/user/updateProfile',
      queryParameters: ({
        'nick':nick,
        'birthday':birthday,
        'firstName':firstName,
        'lastName':lastName,
        'phone':phone,
      })
    );
  }

  static Future<bool> havePayPassword() async {
    var response = await http.get('/app/user/havePayPassword',
      queryParameters: ({})
    );
    return response.data['data'] != null && response.data['data'] == true;
  }

  static Future<bool> updatePayPassword(String oldPassword, String newPassword) async {
    var formData = {
      "oldPassword" : oldPassword,
      "newPassword" : newPassword,
    };
    var response = await http.post('/app/user/updatePayPassword',
      data: formData
    );
    return response.data;
  }

  static Future<bool> updateLoginPassword(String oldPassword, String newPassword) async {
    var formData = {
      "oldPassword" : oldPassword,
      "newPassword" : newPassword,
    };
    var response = await http.post('/app/user/updatePassword',
      data: formData
    );
    return response.data;
  }

  static String generateMd5(String data) {
    if(data.isEmpty){
      return data;
    }
    var bytes = utf8.encode(data);
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  static Future<void> deleteAccount() async {
    await http.get('/app/user/delete',
      queryParameters: ({})
    );
  }

  static Future<List<AttentionModel>> attentionList(int pageNum, int pageSize) async {
    List<AttentionModel> list = [];
    var response = await http.get('/peiwan/app/user/followlist',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    list = response.data.map<AttentionModel>((item) => AttentionModel.fromJson(item)).toList();
    return list;
  }

  static Future<List<AttentionModel>> fansList(int pageNum, int pageSize) async {
    List<AttentionModel> list = [];
    var response = await http.get('/peiwan/app/user/fanslist',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    list = response.data.map<AttentionModel>((item) => AttentionModel.fromJson(item)).toList();
    return list;
  }
}
