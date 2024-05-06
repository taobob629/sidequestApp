import 'package:get/get.dart';
import 'package:sq_hub_app/model/safe_convert.dart';

import 'booking_model.dart';

class GameConfig {
  final int techLevel;
  final List<FieldsItem> fields;
  final List<PriceRangeModel> priceRange;
  final List<InfoItem> infoList;

  GameConfig({
    required this.techLevel,
    required this.fields,
    required this.priceRange,
    required this.infoList,
  });

  factory GameConfig.fromJson(Map<String, dynamic>? json) => GameConfig(
        techLevel: asT<int>(json, 'techLevel', defaultValue: 0),
        fields: asT<List>(json, 'fields')
            .map((e) => FieldsItem.fromJson(e))
            .toList(),
        priceRange: asT<List>(json, 'priceRange')
            .map((e) => PriceRangeModel.fromJson(e))
            .toList(),
        infoList:
            asT<List>(json, 'info').map((e) => InfoItem.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'fields': fields.map((e) => e.toJson()).toList(),
        'priceRange': priceRange.map((e) => e.toJson()).toList(),
      };
}

class InfoItem {
  String level;
  String orders;
  String pro;
  String sidekicker;

  InfoItem({
    this.level = "",
    this.orders = "",
    this.pro = "",
    this.sidekicker = "",
  });

  factory InfoItem.fromJson(Map<String, dynamic>? json) => InfoItem(
        level: asT<String>(json, 'level'),
        orders: asT<String>(json, 'orders'),
        pro: asT<String>(json, 'pro'),
        sidekicker: asT<String>(json, 'sidekicker'),
      );
}

const int single = 1;
const int multiple = 2;

class FieldsItem {
  // Style
  final String name;
  final int type;
  final List<String> value;
  RxList<String> mSelects = RxList<String>([]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldsItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;

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

class LocalPriceRangeBean {
  double price;
  String unit;
  String name;
  String? discount;

  LocalPriceRangeBean({
    required this.price,
    required this.unit,
    required this.name,
    this.discount,
  });

  Map<String, dynamic> toJson() => {
        'price': price,
        'unit': unit,
        'name': name,
        'discount': discount,
      };
}

class PromotionConfig {
  List<BookingSelectModel> promotionList = [];
  List<BookingSelectModel> discountList = [];
  List<BookingSelectModel> orderFreeList = [];
  List<BookingSelectModel> xAndYList = [];

  // 单例对象
  static final PromotionConfig _singleton = PromotionConfig._internal();

  // 私有构造函数
  PromotionConfig._internal();

  // 工厂构造函数，返回单例对象
  factory PromotionConfig() {
    return _singleton;
  }

  // 其他成员方法和属性
  void initData() {
    if (promotionList.isNotEmpty) {
      return;
    }
    BookingSelectModel model = BookingSelectModel();
    model.id = 0;
    model.name = "Discount".tr;
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "1st Order Discount".tr;
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "Buy X Get Y Free".tr;
    promotionList.add(model);

    model = BookingSelectModel();
    model.id = 0;
    model.name = "5% OFF";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "10% OFF";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "15% OFF";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 3;
    model.name = "20% OFF";
    discountList.add(model);

    model = BookingSelectModel();
    model.id = 0;
    model.name = "30% OFF";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "50% OFF";
    orderFreeList.add(model);
    // model = BookingSelectModel();
    // model.id = 2;
    // model.name = "80% OFF";
    // orderFreeList.add(model);
    // model = BookingSelectModel();
    // model.id = 3;
    // model.name = "100% OFF";
    // orderFreeList.add(model);

    for (int i = 1; i <= 10; i++) {
      model = BookingSelectModel();
      model.id = i;
      model.name = "$i";
      xAndYList.add(model);
    }
  }
}

class PriceRangeModel {
  // 18
  final double gameCoinMin;

  // 42
  final double gameCoinMax;

  final double price; //设置的价格

  // 26
  final int id;

  // Hour
  String unit;
  String name;

  var promotionSwitch = true.obs;

  var currentPromotion = BookingSelectModel().obs;

  var currentDiscount = BookingSelectModel().obs;

  var currentOrderFree = BookingSelectModel().obs;

  var currentBuyX = BookingSelectModel().obs;
  var currentGetY = BookingSelectModel().obs;

  RxDouble _curPrice = RxDouble(0);

  double get curPrice => _curPrice.value;

  set curPrice(double value) {
    _curPrice.value = value;
  }

  PriceRangeModel({
    this.gameCoinMin = 0,
    this.gameCoinMax = 0,
    this.id = 0,
    this.unit = "",
    this.name = '',
    this.price = 0,
  });

  void initData() {
    PromotionConfig().initData();
    currentPromotion.value = PromotionConfig().promotionList[0];
    currentDiscount.value = PromotionConfig().discountList[0];
    currentOrderFree.value = PromotionConfig().orderFreeList[0];
    currentBuyX.value = currentGetY.value = PromotionConfig().xAndYList[0];
  }

  factory PriceRangeModel.fromJson(Map<String, dynamic>? json) =>
      PriceRangeModel(
        gameCoinMin: asT<double>(json, 'gameCoinMin'),
        gameCoinMax: asT<double>(json, 'gameCoinMax'),
        price: asT<double>(json, 'price'),
        id: asT<int>(json, 'id'),
        unit: asT<String>(json, 'unit'),
        name: asT<String>(json, 'name'),
      );

  Map<String, dynamic> toJson() => {
        'gameCoinMin': gameCoinMin,
        'gameCoinMax': gameCoinMax,
        'price': price,
        'id': id,
        'unit': unit,
        'name': name,
        'price': curPrice == 0 ? gameCoinMin : curPrice,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceRangeModel &&
          runtimeType == other.runtimeType &&
          unit == other.unit;

  @override
  int get hashCode => unit.hashCode;

  @override
  String toString() {
    return 'PriceRangeModel{gameCoinMin: $gameCoinMin, gameCoinMax: $gameCoinMax, id: $id, unit: $unit, name: $name, _curPrice: $_curPrice}';
  }
}
