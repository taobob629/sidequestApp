import 'dart:io';
import 'package:dio/dio.dart';
import 'package:wy/api/wy_http.dart';

class Common {
  static Future<String> uploadFile(File image, Function(int, int)? sendCallback) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(path, filename: name)
    });
    var response = await http.post('/common/upload', data: formData, onSendProgress: sendCallback);

    return response.data['url'];
  }
}
