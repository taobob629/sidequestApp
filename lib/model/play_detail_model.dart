

class PlayDetailModel {
  late int userId = 0;
  late List<String> imageList = [];
  late String name;
  late String avatar;
  late int age;
  late int level;
  late int follow;
  late int fans;

  PlayDetailModel();

  PlayDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    imageList = json['imageList'] == null ? [] : (json['imageList'] as List).map<String>((e) => e.toString()).toList();
    name = json['name'] ?? '';
    avatar = json['avatar'] ?? '';
    age = json['age'] ?? 0;
    level = json['level'] ?? 0;
    follow = json['follow'] ?? 0;
    fans = json['fans'] ?? 0;
  }

}