class VisitorModel {
  VisitorModel({
    required this.vistTime,
    required this.signature,
    required this.uk,
    required this.sex,
    required this.name,
    required this.id,
    required this.avatar,
    required this.age,
    required this.status,
    required this.isAuth,
    required this.titlesLevel,
    required this.userLevel,
  });

  int vistTime;
  String signature;
  String uk;
  int sex;
  String name;
  int id;
  String avatar;
  int age;
  int status;
  int isAuth = 0;
  int titlesLevel = 0;
  int userLevel = 0;

  factory VisitorModel.fromJson(Map<String, dynamic> json) => VisitorModel(
        vistTime: json["vistTime"] ?? 0,
        signature: json["signature"],
        uk: json["uk"],
        sex: json["sex"],
        name: json["name"],
        id: json["id"],
        avatar: json["avatar"],
        age: json["age"],
        status: json["status"],
        isAuth: json['isauth'] ?? 0,
        userLevel: json['userLevel'] ?? 0,
        titlesLevel: json['titlesLevel'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "vistTime": vistTime,
        "signature": signature,
        "uk": uk,
        "sex": sex,
        "name": name,
        "id": id,
        "avatar": avatar,
        "age": age,
        "status": status,
        "isAuth": isAuth,
        "userLevel": userLevel,
        "titlesLevel": titlesLevel,
      };
}
