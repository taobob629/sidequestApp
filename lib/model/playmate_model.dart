class PlaymateModel {
  List<TopModel> top;

  PlaymateModel({
    required this.top,
  });

  factory PlaymateModel.fromJson(Map<String, dynamic> json) => PlaymateModel(
    top: List<TopModel>.from(json["top"].map((x) => TopModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "top": List<dynamic>.from(top.map((x) => x.toJson())),
  };
}

class TopModel {
  String memberCode;
  int birthday;
  String nickName;
  int sex;
  String num;
  int id;
  String avatar;
  double stars;

  String avatarTwo;
  int sexTwo;
  int birthdayTwo;
  int idTwo;
  String nickNameTwo;
  double starsTwo;
  String memberCodeTwo;

  TopModel({
    required this.memberCode,
    required this.birthday,
    required this.nickName,
    required this.sex,
    required this.num,
    required this.id,
    required this.avatar,
    required this.stars,

    required this.memberCodeTwo,
    required this.birthdayTwo,
    required this.nickNameTwo,
    required this.sexTwo,
    required this.idTwo,
    required this.avatarTwo,
    required this.starsTwo,
  });

  factory TopModel.fromJson(Map<String, dynamic> json) => TopModel(
    memberCode: json["memberCode"],
    birthday: json["birthday"],
    nickName: json["nickName"],
    sex: json["sex"],
    num: json["num"],
    id: json["id"],
    avatar: json["avatar"],
    stars: json["stars"],

    memberCodeTwo: json["memberCodeTwo"] ?? '',
    birthdayTwo: json["birthdayTwo"] ?? 0,
    nickNameTwo: json["nickNameTwo"] ?? '',
    sexTwo: json["sexTwo"] ?? 0,
    idTwo: json["idTwo"] ?? 0,
    avatarTwo: json["avatarTwo"] ?? '',
    starsTwo: json["starsTwo"] ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "memberCode": memberCode,
    "birthday": birthday,
    "nickName": nickName,
    "sex": sex,
    "num": num,
    "id": id,
    "avatar": avatar,
    "stars": stars,

    "memberCodeTwo": memberCodeTwo,
    "birthdayTwo": birthdayTwo,
    "nickNameTwo": nickNameTwo,
    "sexTwo": sexTwo,
    "idTwo": idTwo,
    "avatarTwo": avatarTwo,
    "starsTwo": starsTwo,
  };
}
