import 'package:get/get.dart';
import 'package:wy/model/safe_convert.dart';

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
        'price': _curPrice.value,
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
