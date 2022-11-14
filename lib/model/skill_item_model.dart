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
    this.skillid,
    this.price,
    this.unit,
    this.enabled,
  });

  SkillItemModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    uid = json['uid'];
    skillName = json['skillName'];
    skillid = json['skillid'];
    price = double.parse(json['price']);
    unit = json['unit'];
    enabled = json['enabled'];
  }

  int? id;
  String? name;
  dynamic uid;
  String? skillName;
  int? skillid;
  double? price;
  dynamic unit;
  int? enabled;
}
