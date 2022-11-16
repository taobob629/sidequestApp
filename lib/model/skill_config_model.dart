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
    level = json['level'];
    if (json['priceRangeMin'] != null) {
      priceRangeMin = double.parse(json['priceRangeMin'].toString());
    }
    if (json['priceRangeMax'] != null) {
      priceRangeMax = double.parse(json['priceRangeMax'].toString());
    }
    if (json['price'] != null) {
      price = double.parse(json['price'].toString());
    }
    name = json['name'];
    enabled = json['enabled'] ?? 1;
  }

  double? priceRangeMin;
  String? level;
  double? price;
  String? name;
  int? enabled;
  double? priceRangeMax;

  SkillItemConfigModel copyWith({
    double? priceRangeMin,
    String? level,
    double? priceRangeMax,
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
