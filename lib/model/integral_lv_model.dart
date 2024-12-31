import 'package:get/get.dart';
import 'package:sq_hub_app/model/selector_item.dart';

class IntegralLvModel {
  int? dictCode;
  int? dictSort;
  String? dictLabel;
  String? dictValue;
  String? dictType;
  dynamic cssClass;
  String? listClass;
  String? isDefault;
  String? status;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? remark;
  Params? params;
  bool? integralLvModelDefault;

  IntegralLvModel({
    this.dictCode,
    this.dictSort,
    this.dictLabel,
    this.dictValue,
    this.dictType,
    this.cssClass,
    this.listClass,
    this.isDefault,
    this.status,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.params,
    this.integralLvModelDefault,
  });

  factory IntegralLvModel.fromJson(Map<String, dynamic> json) => IntegralLvModel(
    dictCode: json["dictCode"],
    dictSort: json["dictSort"],
    dictLabel: json["dictLabel"],
    dictValue: json["dictValue"],
    dictType: json["dictType"],
    cssClass: json["cssClass"],
    listClass: json["listClass"],
    isDefault: json["isDefault"],
    status: json["status"],
    createBy: json["createBy"],
    createTime: json["createTime"],
    updateBy: json["updateBy"],
    updateTime: json["updateTime"],
    remark: json["remark"],
    params: json["params"] == null ? null : Params.fromJson(json["params"]),
    integralLvModelDefault: json["default"],
  );

  Map<String, dynamic> toJson() => {
    "dictCode": dictCode,
    "dictSort": dictSort,
    "dictLabel": dictLabel,
    "dictValue": dictValue,
    "dictType": dictType,
    "cssClass": cssClass,
    "listClass": listClass,
    "isDefault": isDefault,
    "status": status,
    "createBy": createBy,
    "createTime": createTime,
    "updateBy": updateBy,
    "updateTime": updateTime,
    "remark": remark,
    "params": params?.toJson(),
    "default": integralLvModelDefault,
  };
}

class Params {
  Params();

  factory Params.fromJson(Map<String, dynamic> json) => Params(
  );

  Map<String, dynamic> toJson() => {
  };
}

class IntegralLevelModel extends SelectorItem {
  late double zhekou = 0.0;
  late String name = "";
  late int friendLimitCount = 2;

  var model = "".obs;

  IntegralLevelModel();

  @override
  String displayLabel() {
    return name;
  }

  @override
  String displayInfo() {
    return "";
  }

  @override
  bool selectable() {
    return true;
  }

  @override
  String toString() {
    return name;
  }

  IntegralLevelModel.deepCopy(IntegralLevelModel original)
      : this.zhekou = original.zhekou,
        this.name = original.name,
        this.model = original.model,
        this.friendLimitCount = original.friendLimitCount;
}
