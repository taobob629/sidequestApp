

class PlayDetailModel {
  late int userId = 0;
  late String memberId = "";
  late List<String> imageList = [];
  late String name = "";
  late String avatar = "";
  late int age = 0;
  late int level = 0;
  late int follows = 0;
  late int fans = 0;

  late List<SkillModel> skills = [];

  PlayDetailModel();

  PlayDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['basicInfo']['id'];
    memberId = json['basicInfo']['userLogin'];
    imageList = json['thumb'] == null ? [] : (json['thumb'] as List).map<String>((e) => e.toString()).toList();
    name = json['basicInfo']['userNickname'] ?? '';
    avatar = json['basicInfo']['avatar'] ?? '';
    age = json['basicInfo']['age'] ?? 0;
    level = json['level'] ?? 0;
    follows = json['followers'] ?? 0;
    fans = json['fans'] ?? 0;

    skills = json["games"].map<SkillModel>((item) => SkillModel.fromJson(item)).toList();
  }

}

class SkillModel{
  late String id = "";
  late int coinType = 0;
  late String thumb = "";
  late String name = "";
  late String label = "";
  late int coin = 0;
  SkillModel();

  SkillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coinType = json['coinType'];
    thumb = json['thumb'];
    name = json['name'];
    coin = json['coin'];
    label = json['label'];
  }

}