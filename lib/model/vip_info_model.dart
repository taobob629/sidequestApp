
class VipInfoModel {
  late int level = 1;
  late List<PrivilegeModel> intro = [];
  late String name = "";
  late double monthFee = 0.0;
  late double yearFee = 0.0;

  VipInfoModel();

  VipInfoModel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    name = json['name'];
    intro = (json['intro'] as List).map<PrivilegeModel>((e) => PrivilegeModel.fromJson(e)).toList();
    monthFee = json['monthFee']*1.0;
    yearFee = json['yearFee']*1.0;
  }
}

class PrivilegeModel{
  late String title;
  late String intro;

  PrivilegeModel();

  PrivilegeModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    intro = json['intro'];
  }
}