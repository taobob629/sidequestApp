class JumpMatchSucBean {

  int uid;
  int distance;
  String memberCode;
  String orderId;
  String avatar;
  String nickname;
  int sex;
  int age;
  dynamic stars;
  String levelNameEn;
  List<Language> tags;
  dynamic price;

  String category;
  String game;
  String priceRange;
  String unit;
  String launguage;

  int skillAuthId;
  int liveuid;
  int serviceItemId;

  JumpMatchSucBean({
    required this.uid,
    required this.distance,
    required this.memberCode,
    required this.orderId,
    required this.avatar,
    required this.nickname,
    required this.sex,
    required this.age,
    required this.stars,
    required this.levelNameEn,
    required this.tags,
    required this.price,
    required this.category,
    required this.game,
    required this.priceRange,
    required this.unit,
    required this.launguage,
    required this.skillAuthId,
    required this.liveuid,
    required this.serviceItemId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JumpMatchSucBean &&
          runtimeType == other.runtimeType &&
          memberCode == other.memberCode;

  @override
  int get hashCode =>
      uid.hashCode ^
      orderId.hashCode ^
      avatar.hashCode ^
      nickname.hashCode ^
      sex.hashCode ^
      age.hashCode ^
      stars.hashCode ^
      tags.hashCode ^
      category.hashCode ^
      game.hashCode ^
      priceRange.hashCode ^
      unit.hashCode ^
      launguage.hashCode ^
      skillAuthId.hashCode ^
      liveuid.hashCode ^
      serviceItemId.hashCode ^
      levelNameEn.hashCode;
}

class Language {
  Language({
    required this.name,
    required this.value,
  });

  String name;
  String value;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Language && runtimeType == other.runtimeType && name == other.name && value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
