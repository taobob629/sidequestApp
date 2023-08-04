
import 'package:wy/model/safe_convert.dart';

class ServiceInfoModel {
  final List<SkillItem> skill;
  // Mobile
  final String name;
  // 1
  final String id;

  ServiceInfoModel({
    required this.skill,
    this.name = "",
    this.id = "",
  });

  factory ServiceInfoModel.fromJson(Map<String, dynamic>? json) => ServiceInfoModel(
    skill: asT<List>(json, 'skill').map((e) => SkillItem.fromJson(e)).toList(),
    name: asT<String>(json, 'name'),
    id: asT<String>(json, 'id'),
  );

  Map<String, dynamic> toJson() => {
    'skill': skill.map((e) => e.toJson()).toList(),
    'name': name,
    'id': id,
  };
}

class SkillItem {
  final List<LevelItem> level;
  // Clash Royale
  final String name;
  // 6
  final String id;

  SkillItem({
    required this.level,
    this.name = "",
    this.id = "",
  });

  factory SkillItem.fromJson(Map<String, dynamic>? json) => SkillItem(
    level: asT<List>(json, 'level').map((e) => LevelItem.fromJson(e)).toList(),
    name: asT<String>(json, 'name'),
    id: asT<String>(json, 'id'),
  );

  Map<String, dynamic> toJson() => {
    'level': level.map((e) => e.toJson()).toList(),
    'name': name,
    'id': id,
  };
}

class LevelItem {
  // Legendary Arena
  final String name;
  // 36
  final int id;
  final int levelid;
  final bool pro;

  LevelItem({
    this.name = "",
    this.id = 0,
    this.levelid = 0,
    this.pro = false,
  });

  factory LevelItem.fromJson(Map<String, dynamic>? json) => LevelItem(
    name: asT<String>(json, 'name'),
    levelid: asT<int>(json, 'levelid'),
    pro: asT<bool>(json, 'pro'),
    id: asT<int>(json, 'id'),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'levelid': levelid,
    'pro': pro,
  };

  @override
  String toString() {
    return 'LevelItem{name: $name, id: $id}';
  }
}

