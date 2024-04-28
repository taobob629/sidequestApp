import 'dart:convert';

import 'package:get/get.dart';

import '../ui/pages/social/post/release_post_controller.dart';

var gidPrefix = 'SiqdequestGid';
RegExp exp = RegExp(r'SiqdequestGid=([^]*?)=');

class PostItemModel {
  int commentNum = 0;
  String images = "";
  String nickname = "";
  int praiseNum = 0;
  String head = "";
  String createTime = "";
  RxBool isPraise = RxBool(false);
  var newComment = RxInt(0);
  var newPraise = RxInt(0);
  String content = "";
  int uid = 0;
  int id = 0;
  int type = 0;
  int addTime = 0;
  int isAuth = 0;
  int userLevel = 0;
  int titlesLevel = 0;

  showContent() {
    if (type == TYPE_DEFAULT) return content;
    return content.substring(0, content.lastIndexOf(gidPrefix));
  }

  List<String> get imageList {
    if (images.contains("[") && images.contains("]")) {
      return jsonDecode(images).cast<String>();
    } else {
      return [];
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
    newComment.value = json["newComment"] ?? 0;
    newPraise.value = json["newPraise"] ?? 0;
    content = json["content"] ?? "";
    uid = json["uid"] ?? 0;
    id = json["id"] ?? 0;
    type = json["type"] ?? 0;
    addTime = json["addtime"] ?? 0;
    isAuth = json["isauth"] ?? 0;
    userLevel = json["userLevel"] ?? 1;
    titlesLevel = json["titlesLevel"] ?? 1;
  }
}
