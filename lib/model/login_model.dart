
import 'package:wy/model/user_model.dart';

import 'selector_item.dart';

class LoginModel {
  late UserModel user;
  late String token;
  late int validate;
  late int secondary;

  late List<VerifyField> verifyFieldList;

  LoginModel();

  LoginModel.fromJson(Map<String, dynamic> json) {

    token = json["token"]==null ? "" : json["token"];
    validate = json["validate"]==null ? 0 : json["validate"];
    secondary = json["Secondary"]==null ? 0 : json["Secondary"];
    if(json["user"] != null){
      user = UserModel.fromJson(json["user"]);
    }else{
      user = UserModel();
    }
    if(json["fields"] != null){
      verifyFieldList = json["fields"]
        .map<VerifyField>((item) => VerifyField.fromJson(item))
        .toList();
    }else{
      verifyFieldList = [];
    }
  }
}

class VerifyField extends SelectorItem{
  late String name;
  late String label;

  VerifyField();

  VerifyField.fromJson(Map<String, dynamic> json) {
    name = json["name"]==null ? "" : json["name"];
    label = json["label"]==null ? "" : json["label"];
  }

  @override
  String toString() {
    return 'VerifyField{name: $name, label: $label}';
  }

  @override
  String displayLabel() {
    return label;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerifyField && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  bool selectable() {
    return true;
  }
}