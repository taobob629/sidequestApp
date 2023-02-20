class PostItemModel {
  int commentNum = 0;
  String images = "";
  String nickname = "";
  int praiseNum = 0;
  String head = "";
  int createTime = 0;
  int isPraise = 0;
  String content = "";
  int uid = 0;

  PostItemModel({
    this.commentNum = 0,
    this.images = "",
    this.nickname = "",
    this.praiseNum = 0,
    this.head = "",
    this.createTime = 0,
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
    createTime = json["createTime"] ?? 0;
    isPraise = json["isPraise"] ?? 0;
    content = json["content"] ?? "";
    uid = json["uid"] ?? 0;
  }
}
