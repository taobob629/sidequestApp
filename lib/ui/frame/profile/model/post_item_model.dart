import 'dart:convert';

import 'package:get/get.dart';

class PostItemModel {
  int commentNum = 0;
  String images = "";
  String nickname = "";
  int praiseNum = 0;
  String head = "";
  String createTime = "";
  RxBool isPraise = RxBool(false);
  String content = "";
  int uid = 0;

  List<String> get imageList {
    if (images.contains("[") && images.contains("]")) {
      return jsonDecode(images).cast<String>();
    } else {
      return [images, images];
    }
  }

  PostItemModel();

  PostItemModel.fromJson(Map<String, dynamic> json) {
    commentNum = json["commentNum"] ?? 0;
    images = json["images"] ?? "";
    nickname = json["nickname"] ?? "";
    praiseNum = json["praiseNum"] ?? 0;
    head = json["head"] ?? "";
    createTime = json["createTime"] ?? "";
    isPraise.value = (json["isPraise"] ?? 0) == 1;
    content = json["content"] ?? "";
    uid = json["uid"] ?? 0;
  }
}
