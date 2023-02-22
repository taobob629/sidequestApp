
import 'package:wy/model/safe_convert.dart';
class ActivityTabModel {
  // 0
  final int amount;
  // Tournaments
  final String name;
  // 0
  final int defaut;
  // 0
  final String type;

  ActivityTabModel({
    this.amount = 0,
    this.name = "",
    this.defaut = 0,
    this.type = "",
  });

  factory ActivityTabModel.fromJson(Map<String, dynamic>? json) => ActivityTabModel(
    amount: asT<int>(json, 'amount'),
    name: asT<String>(json, 'name'),
    defaut: asT<int>(json, 'defaut'),
    type: asT<String>(json, 'type'),
  );

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'name': name,
    'defaut': defaut,
    'type': type,
  };

  @override
  String toString() {
    return '$name';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTabModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;
}

