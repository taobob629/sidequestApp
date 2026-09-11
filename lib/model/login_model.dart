import 'package:sq_hub_app/model/selector_item.dart';
import 'package:sq_hub_app/model/user_model.dart';

class LoginModel {
  late UserModel user;
  late String token;
  late String login;
  late bool gotoLogin2;
  bool needsProfileCompletion = false;
  late int validate;
  late int secondary;

  late List<VerifyField> verifyFieldList;

  LoginModel();

  @override
  String toString() {
    return 'LoginModel{user: $user, token: $token, login: $login, gotoLogin2: $gotoLogin2, validate: $validate, secondary: $secondary, verifyFieldList: $verifyFieldList}';
  }

  LoginModel.fromJson(Map<String, dynamic> json) {
    login = json["login"] == null ? "" : json["login"];
    gotoLogin2 = json["gotoLogin2"] == null ? false : json["gotoLogin2"];
    needsProfileCompletion = json["needsProfileCompletion"] == null
        ? gotoLogin2
        : json["needsProfileCompletion"];
    token = json["token"] == null ? "" : json["token"];
    validate = json["validate"] == null ? 0 : json["validate"];
    secondary = json["Secondary"] == null ? 0 : json["Secondary"];
    if (json["user"] != null) {
      user = UserModel.fromJson(json["user"]);
    } else {
      user = UserModel();
    }
    if (json["fields"] != null) {
      verifyFieldList = json["fields"]
          .map<VerifyField>((item) => VerifyField.fromJson(item))
          .toList();
    } else {
      verifyFieldList = [];
    }
  }
}

class VerifyField extends SelectorItem {
  late String name;
  late String label;

  VerifyField();

  VerifyField.fromJson(Map<String, dynamic> json) {
    name = json["name"] == null ? "" : json["name"];
    label = json["label"] == null ? "" : json["label"];
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
      other is VerifyField &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  bool selectable() {
    return true;
  }
}

class LoginBtnModel {
  bool discordLogin = false;
  bool appleLogin = false;
  bool googleLogin = false;

  LoginBtnModel();

  LoginBtnModel.fromJson(Map<String, dynamic> json) {
    discordLogin = json["discordLogin"] == null ? false : json["discordLogin"];
    appleLogin = json["appleLogin"] == null ? false : json["appleLogin"];
    googleLogin = json["googleLogin"] == null ? false : json["googleLogin"];
  }
}
