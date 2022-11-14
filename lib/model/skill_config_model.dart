/// priceRangeMin : 0
/// level : "Guardian"
/// priceRangeMax : 10

class SkillItemConfigModel {
  SkillItemConfigModel({
    this.priceRangeMin,
    this.level,
    this.priceRangeMax,
  });

  SkillItemConfigModel.fromJson(dynamic json) {
    priceRangeMin = json['priceRangeMin'];
    level = json['level'];
    priceRangeMax = json['priceRangeMax'];
  }

  int? priceRangeMin;
  String? level;
  int? priceRangeMax;
  SkillItemConfigModel copyWith({
    int? priceRangeMin,
    String? level,
    int? priceRangeMax,
  }) =>
      SkillItemConfigModel(
        priceRangeMin: priceRangeMin ?? this.priceRangeMin,
        level: level ?? this.level,
        priceRangeMax: priceRangeMax ?? this.priceRangeMax,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['priceRangeMin'] = priceRangeMin;
    map['level'] = level;
    map['priceRangeMax'] = priceRangeMax;
    return map;
  }
}
