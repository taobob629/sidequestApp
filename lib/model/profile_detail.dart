import 'package:sq_hub_app/model/safe_convert.dart';

class ProfileDetailBean {
  // test1
  final String nick;
  // 0
  final String gender;
  final String country;
  // 1234567
  final String phone;
  final String signature;
  // English
  final String language;
  final List<String> languageList;
  final List<String> genderList;

  ProfileDetailBean({
    this.nick = "",
    this.country="",
    this.gender = "",
    this.phone = "",
    this.signature = "",
    this.language = "",
    required this.languageList,
    required this.genderList,
  });

  factory ProfileDetailBean.fromJson(Map<String, dynamic>? json) => ProfileDetailBean(
    nick: asT<String>(json, 'nick'),
    country: asT<String>(json, 'country'),
    gender: asT<String>(json, 'gender'),
    phone: asT<String>(json, 'phone'),
    signature: asT<String>(json, 'signature'),
    language: asT<String>(json, 'language'),
    languageList: asT<List>(json, 'languageList').map((e) => e.toString()).toList(),
    genderList: asT<List>(json, 'genderList').map((e) => e.toString()).toList(),
  );

  Map<String, dynamic> toJson() => {
    'nick': nick,
    'gender': gender,
    'country': country,
    'phone': phone,
    'signature': signature,
    'language': language,
    'languageList': languageList.map((e) => e).toList(),
    'genderList': genderList.map((e) => e).toList(),
  };
}

