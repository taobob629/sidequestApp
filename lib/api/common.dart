import 'dart:io';
import 'package:dio/dio.dart';
import 'package:wy/api/wy_http.dart';
import 'package:http_parser/http_parser.dart';

class Common {
  ///图片上传
  static Future<String> uploadFile(File image, Function(int, int)? sendCallback,
      {var isVoiceFile = false}) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      //这里写其他需要传递的参数
      "file": await MultipartFile.fromFile(path,
          filename: name, contentType: MediaType('audio', 'mpeg'))
    });
    var response = await http.post(
        isVoiceFile ? '/peiwan/app/profile/uploadVoice' : '/peiwan/app/start/upload',
        data: formData,
       // options: Options(contentType: isVoiceFile ? 'audio/m4a' : null),
        onSendProgress: sendCallback);

    return response.data['url'];
  }
}
