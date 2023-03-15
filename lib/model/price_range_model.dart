import 'dart:ffi';

import 'package:get/get.dart';
import 'package:wy/model/safe_convert.dart';

class GameConfig {
  final List<FieldsItem> fields;
  final List<PriceRangeModel> priceRange;

  GameConfig({
    required this.fields,
    required this.priceRange,
  });

  factory GameConfig.fromJson(Map<String, dynamic>? json) => GameConfig(
        fields: asT<List>(json, 'fields').map((e) => FieldsItem.fromJson(e)).toList(),
        priceRange: asT<List>(json, 'priceRange').map((e) => PriceRangeModel.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'fields': fields.map((e) => e.toJson()).toList(),
        'priceRange': priceRange.map((e) => e.toJson()).toList(),
      };
}

const int single = 1;
const int multiple = 2;

class FieldsItem {
  // Style
  final String name;
  final int type;
  final List<String> value;
  RxList<String> mSelects = RxList<String>([]);

  displaySelect() {
    return mSelects.join(',');
  }

  FieldsItem({
    this.name = "",
    this.type = 1,
    required this.value,
  });

  factory FieldsItem.fromJson(Map<String, dynamic>? json) => FieldsItem(
        name: asT<String>(json, 'name'),
        type: asT<int>(json, 'type', defaultValue: single),
        value: asT<List>(json, 'value').map((e) => e.toString()).toList(),
      );

  @override
  String toString() {
    return 'FieldsItem{name: $name, type: $type, value: $value}';
  }

  factory FieldsItem.fromJson2(Map<String, dynamic>? json) => FieldsItem(
        name: asT<String>(json, 'name'),
        type: asT<int>(json, 'type', defaultValue: single),
        value: asT<List>(json, 'value').map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson2() => {
        'name': name,
        'type': type,
        'value': mSelects.map((e) => e).toList(),
      };

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'value': value.map((e) => e).toList(),
      };
}

class PriceRangeModel {
  // 18
  final double gameCoinMin;

  // 42
  final double gameCoinMax;

  // 26
  final int id;

  // Hour
  final String unit;
  String name;
  RxDouble _curPrice = RxDouble(0);

  double get curPrice => _curPrice.value;

  set curPrice(double value) {
    _curPrice.value = value;
  }

  PriceRangeModel(
      {this.gameCoinMin = 0, this.gameCoinMax = 0, this.id = 0, this.unit = "", this.name = ''});

  factory PriceRangeModel.fromJson(Map<String, dynamic>? json) => PriceRangeModel(
        gameCoinMin: asT<double>(json, 'gameCoinMin'),
        gameCoinMax: asT<double>(json, 'gameCoinMax'),
        id: asT<int>(json, 'id'),
        unit: asT<String>(json, 'unit'),
        name: asT<String>(json, 'name'),
      );

  Map<String, dynamic> toJson() => {
        'gameCoinMin': gameCoinMin,
        'gameCoinMax': gameCoinMax,
        'id': id,
        'unit': unit,
        'name': name,
        'price': curPrice == 0 ? gameCoinMin : curPrice,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceRangeModel && runtimeType == other.runtimeType && unit == other.unit;

  @override
  int get hashCode => unit.hashCode;

  @override
  String toString() {
    return 'PriceRangeModel{gameCoinMin: $gameCoinMin, gameCoinMax: $gameCoinMax, id: $id, unit: $unit, name: $name, _curPrice: $_curPrice}';
  }
}
