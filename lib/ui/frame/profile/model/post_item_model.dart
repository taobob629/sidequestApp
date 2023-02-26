import 'dart:convert';

class PostItemModel {
  int commentNum = 0;
  String images = "";
  String nickname = "";
  int praiseNum = 0;
  String head = "";
  String createTime = "";
  int isPraise = 0;
  String content = "";
  int uid = 0;

  List<String> get imageList {
    if (images.contains("[") && images.contains("]")) {
      return jsonDecode(images).cast<String>();
    } else {
      return [images, images];
    }
  }

  PostItemModel({
    this.commentNum = 0,
    this.images = "",
    this.nickname = "",
    this.praiseNum = 0,
    this.head = "",
    this.createTime = "",
    this.isPraise = 0,
    this.content = "",
    this.uid = 0,
  });

  PostItemModel.fromJson(Map<String, dynamic> json) {
    commentNum = json["commentNum"] ?? 0;
    images = json["images"] ?? "";
    nickname = json["nickname"] ?? "";
    praiseNum = json["praiseNum"] ?? 0;
    head = json["head"] ?? "";
    createTime = json["createTime"] ?? "";
    isPraise = json["isPraise"] ?? 0;
    content = json["content"] ?? "";
    uid = json["uid"] ?? 0;
  }
}
