class PostCommentModel {
  int? uid;
  String createTime = "";
  String nickname = "";
  String content = "";
  String head = "";
  int replyId = 0;
  String replyHead = "";
  String replyNickname = "";
  int postId = 0;
  int addTime = 0;

  bool get isReply => replyId > 0;

  PostCommentModel({
    this.uid,
    this.createTime = "",
    this.nickname = "",
    this.content = "",
    this.head = "",
  });

  PostCommentModel.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    createTime = json["createTime"] ?? "";
    nickname = json["nickname"] ?? "";
    content = json["content"] ?? "";
    head = json["head"] ?? "";
    replyId = json["replyId"] ?? 0;
    replyHead = json["replyHead"] ?? "";
    replyNickname = json["replyNickname"] ?? "";
    postId = json["postId"] ?? 0;
    addTime = json["addtime"] ?? 0;
  }
}
