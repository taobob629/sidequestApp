/// priceRangeMin : 0
/// level : "Guardian"
/// priceRangeMax : 10

class SkillItemConfigModel {
  SkillItemConfigModel({
    this.priceRangeMin,
    this.level,
    this.priceRangeMax,
    this.discount,
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
    unit = json['unit'];
    enabled = json['enabled'] ?? 1;
    discount = json['discount'];
  }

  double? priceRangeMin;
  String? level;
  double? price;
  String? unit;//单位
  String? name;
  int? enabled;
  double? priceRangeMax;
  String? discount;

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
    map['discount'] = discount;
    map['level'] = level;
    map['unit'] = unit;
    map['priceRangeMax'] = priceRangeMax;
    return map;
  }
}
