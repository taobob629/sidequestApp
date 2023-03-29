import '../match_init_model.dart';

class JumpMatchSucBean {
  bool? ifPlayer;

  String orderId;
  String avatar;
  String nickname;
  int sex;
  int age;
  dynamic stars;
  String levelNameEn;
  List<Language> tags;

  String category;
  String game;
  String priceRange;
  String unit;
  String launguage;

  int skillAuthId;
  int liveuid;
  int serviceItemId;

  JumpMatchSucBean({
    required this.orderId,
    required this.avatar,
    required this.nickname,
    required this.sex,
    required this.age,
    required this.stars,
    required this.levelNameEn,
    required this.tags,
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
          orderId == other.orderId;

  @override
  int get hashCode =>
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
