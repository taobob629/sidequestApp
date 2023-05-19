import 'dart:convert';

import 'package:get/get.dart';
import 'package:wy/ui/frame/social/post/contorller/release_post_controller.dart';
import 'package:wy/ui/im/im_util.dart';

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
  int id = 0;
  int type = 0;
  int addTime = 0;

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
    content = json["content"] ?? "";
    uid = json["uid"] ?? 0;
    id = json["id"] ?? 0;
    type = json["type"] ?? 0;
    addTime = json["addtime"] ?? 0;
  }
}
