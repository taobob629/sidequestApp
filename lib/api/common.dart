import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sq_hub_app/api/wy_http.dart';

class Common {
  ///图片上传
  static Future<String> uploadFile(File image, Function(int, int)? sendCallback,
      {var isVoiceFile = false}) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(path, filename: name)
    });
    var response = await http.post(
        isVoiceFile
            ? '/peiwan/app/profile/uploadVoice'
            : '/peiwan/app/start/upload',
        data: formData,
        // options: Options(contentType: isVoiceFile ? 'application/json' : null),
        onSendProgress: sendCallback);

    return response.data['url'];
  }

  static Future<String> uploadServiceRecordFile(
      File image, Function(int, int)? sendCallback,
      {var isVoiceFile = false}) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(path, filename: name)
    });
    var response = await http.post('/peiwan/app/profile/uploadServiceVoice',
        data: formData,
        // options: Options(contentType: isVoiceFile ? 'application/json' : null),
        onSendProgress: sendCallback);

    return response.data['url'];
  }

  ///图片上传
  static Future<String> uploadAvatar(
      File image, Function(int, int)? sendCallback) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(path, filename: name)
    });
    var response = await http.post('/peiwan/app/profile/uploadAvatar',
        data: formData, onSendProgress: sendCallback);

    return response.data['url'];
  }
}
