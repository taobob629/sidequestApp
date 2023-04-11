import 'package:get/get.dart';

/// id : 1
/// name : "121221"
/// uid : null
/// skillName : "DATA2 "
/// skillid : 22
/// price : "4.00"
/// unit : null
/// enabled : 1

class SkillItemModel {
  SkillItemModel({
    this.id,
    this.name,
    this.uid,
    this.skillName,
    this.skillAuthid,
    this.price,
    this.unit,
    this.isDefault,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['uid'] = uid;
    json['skillName'] = skillName;
    json['skillAuthid'] = skillAuthid;
    json['price'] = price;
    json['unit'] = unit;
    json['enabled'] = enabled;
    json['isDefault'] = isDefault;
    return json;
  }

  SkillItemModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    uid = json['uid'];
    skillName = json['skillName'];
    skillAuthid = json['skillAuthid'];
    price = double.parse(json['price']);
    unit = json['unit'];
    enabled = json['enabled'];
    isDefault = json['isDefault'];
  }

  int? id;
  String? name;
  dynamic uid;
  String? skillName;
  int? skillAuthid;
  double? price;
  dynamic unit;
  RxInt _enabled=RxInt(0);

  int get enabled => _enabled.value;

  set enabled(int value) {
    _enabled.value = value;
  }

  int? isDefault;
}
