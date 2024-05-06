import 'package:date_format/date_format.dart';

class RatingCommentModel {
  int id = 0;
  int uid = 0;
  int liveuid = 0;
  int skillid = 0;
  int orderid = 0;
  String content = "";
  double star = 0.0;
  String label = "";
  int addtime = 0;
  int performance = 0;
  int responsive = 0;
  int enjoyment = 0;
  int friendless = 0;
  String nickName = "";
  String userAvatar = "";
  String gameAvatar = "";
  String gameName = "";

  String get fmtTime {
    try {
      return formatDate(
        DateTime.fromMillisecondsSinceEpoch(addtime * 1000,isUtc:false),
        [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn],
      );
    } catch (e) {
      return "";
    }
  }

  RatingCommentModel();

  RatingCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? id;
    uid = json['uid'] ?? uid;
    liveuid = json['liveuid'] ?? liveuid;
    skillid = json['skillid'] ?? skillid;
    orderid = json['orderid'] ?? orderid;
    content = json['content'] ?? content;
    star = json['star'] ?? star;
    label = json['label'] ?? label;
    addtime = json['addtime'] ?? addtime;
    performance = json['performance'] ?? performance;
    responsive = json['responsive'] ?? responsive;
    enjoyment = json['enjoyment'] ?? enjoyment;
    friendless = json['friendless'] ?? friendless;
    nickName = json['nickName'] ?? nickName;
    userAvatar = json['userAvatar'] ?? userAvatar;
    gameAvatar = json['gameAvatar'] ?? gameAvatar;
    gameName = json['gameName'] ?? gameName;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['liveuid'] = this.liveuid;
    data['skillid'] = this.skillid;
    data['orderid'] = this.orderid;
    data['content'] = this.content;
    data['star'] = this.star;
    data['label'] = this.label;
    data['addtime'] = this.addtime;
    data['performance'] = this.performance;
    data['responsive'] = this.responsive;
    data['enjoyment'] = this.enjoyment;
    data['friendless'] = this.friendless;
    data['nickName'] = this.nickName;
    data['userAvatar'] = this.userAvatar;
    data['gameAvatar'] = this.gameAvatar;
    return data;
  }
}
