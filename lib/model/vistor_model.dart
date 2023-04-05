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
  });

  String vistTime;
  String signature;
  String uk;
  int sex;
  String name;
  int id;
  String avatar;
  int age;
  int status;

  factory VisitorModel.fromJson(Map<String, dynamic> json) => VisitorModel(
    vistTime: json["vistTime"],
    signature: json["signature"],
    uk: json["uk"],
    sex: json["sex"],
    name: json["name"],
    id: json["id"],
    avatar: json["avatar"],
    age: json["age"],
    status: json["status"],
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
  };
}
