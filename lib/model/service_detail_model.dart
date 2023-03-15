
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/safe_convert.dart';
class ServiceDetailModel {
  // 5
  final String gameId;
  // 5
  final String skillid;
  // Call of Duty Mobile
  final String gameName;
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1678876196368.jpg
  final String thumb;
  // 25
  final int levelId;
  final PwSkillAuth pwSkillAuth;
  final List<PriceRangeModel> serviceTypes;
  final List<FieldsItem> fieldItems;
  // 1
  final String platfromId;
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/CallofDutyMobile2.jpg
  final String gameIcon;
  //final Levels levels;
  // 1
  final int status;

  ServiceDetailModel({
    this.gameId = "",
    this.skillid = "",
    this.gameName = "",
    this.thumb = "",
    this.levelId = 0,
    required this.pwSkillAuth,
    required this.serviceTypes,
    this.platfromId = "",
    required this.fieldItems,
    this.gameIcon = "",
    //required this.levels,
    this.status = 0,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic>? json) => ServiceDetailModel(
    gameId: asT<String>(json, 'gameId'),
    skillid: asT<String>(json, 'skillid'),
    gameName: asT<String>(json, 'gameName'),
    thumb: asT<String>(json, 'thumb'),
    levelId: asT<int>(json, 'levelId'),
    pwSkillAuth: PwSkillAuth.fromJson(asT<Map<String, dynamic>>(json, 'pwSkillAuth')),
    serviceTypes: asT<List>(json, 'serviceTypes').map((e) => PriceRangeModel.fromJson(e)).toList(),
    fieldItems: asT<List>(json, 'fieldItems').map((e) => FieldsItem.fromJson(e)).toList(),
    platfromId: asT<String>(json, 'platfromId'),
    gameIcon: asT<String>(json, 'gameIcon'),
  //  levels: Levels.fromJson(asT<Map<String, dynamic>>(json, 'levels')),
    status: asT<int>(json, 'status'),
  );

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'skillid': skillid,
    'gameName': gameName,
    'thumb': thumb,
    'levelId': levelId,
    'pwSkillAuth': pwSkillAuth.toJson(),
    'serviceTypes': serviceTypes.map((e) => e.toJson()).toList(),
    'platfromId': platfromId,
    'gameIcon': gameIcon,
   // 'levels': levels.toJson(),
    'status': status,
  };
}

class PwSkillAuth {
  // 763
  final int id;
  // 2
  final int uid;
  // 0
  final int sex;
  // 5
  final int skillid;
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1678876196368.jpg
  final String thumb;
  // 25
  final int levelid;
  // 1
  final int status;
  // ddd
  final String reason;
  // 1678876249
  final int addtime;
  // 1678878038034
  final int uptime;
  // 1
  final int wswitch;
  // 2
  final int coinid;
  // 18
  final int coin;
  final String label;
  final String voice;
  // 0
  final String voiceL;
  final String des;
  // 5.0
  final double star;
  // 0
  final int comments;
  // 0
  final int orders;
  // 5.0
  final double stars;
  // 0
  final int edit;
  // [{"name":"Server","type":1,"value":["EUW(Europe West)"]},{"name":"Style","type":2,"value":["Lovely","Attacking","Smurf"]}]
  final String fieldItems;

  PwSkillAuth({
    this.id = 0,
    this.uid = 0,
    this.sex = 0,
    this.skillid = 0,
    this.thumb = "",
    this.levelid = 0,
    this.status = 0,
    this.reason = "",
    this.addtime = 0,
    this.uptime = 0,
    this.wswitch = 0,
    this.coinid = 0,
    this.coin = 0,
    this.label = "",
    this.voice = "",
    this.voiceL = "",
    this.des = "",
    this.star = 0.0,
    this.comments = 0,
    this.orders = 0,
    this.stars = 0.0,
    this.edit = 0,
    this.fieldItems = "",
  });

  factory PwSkillAuth.fromJson(Map<String, dynamic>? json) => PwSkillAuth(
    id: asT<int>(json, 'id'),
    uid: asT<int>(json, 'uid'),
    sex: asT<int>(json, 'sex'),
    skillid: asT<int>(json, 'skillid'),
    thumb: asT<String>(json, 'thumb'),
    levelid: asT<int>(json, 'levelid'),
    status: asT<int>(json, 'status'),
    reason: asT<String>(json, 'reason'),
    addtime: asT<int>(json, 'addtime'),
    uptime: asT<int>(json, 'uptime'),
    wswitch: asT<int>(json, 'wswitch'),
    coinid: asT<int>(json, 'coinid'),
    coin: asT<int>(json, 'coin'),
    label: asT<String>(json, 'label'),
    voice: asT<String>(json, 'voice'),
    voiceL: asT<String>(json, 'voiceL'),
    des: asT<String>(json, 'des'),
    star: asT<double>(json, 'star'),
    comments: asT<int>(json, 'comments'),
    orders: asT<int>(json, 'orders'),
    stars: asT<double>(json, 'stars'),
    edit: asT<int>(json, 'edit'),
    fieldItems: asT<String>(json, 'fieldItems'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'sex': sex,
    'skillid': skillid,
    'thumb': thumb,
    'levelid': levelid,
    'status': status,
    'reason': reason,
    'addtime': addtime,
    'uptime': uptime,
    'wswitch': wswitch,
    'coinid': coinid,
    'coin': coin,
    'label': label,
    'voice': voice,
    'voiceL': voiceL,
    'des': des,
    'star': star,
    'comments': comments,
    'orders': orders,
    'stars': stars,
    'edit': edit,
    'fieldItems': fieldItems,
  };
}


class ServiceTypesItem {
  // Hour
  final String unit;
  // 18
  final int price;
  // 18
  final int gameCoinMin;
  // Normal
  final String name;
  // 42
  final int gameCoinMax;
  // 1045
  final int id;
  // 1
  final int enabled;

  ServiceTypesItem({
    this.unit = "",
    this.price = 0,
    this.gameCoinMin = 0,
    this.name = "",
    this.gameCoinMax = 0,
    this.id = 0,
    this.enabled = 0,
  });

  factory ServiceTypesItem.fromJson(Map<String, dynamic>? json) => ServiceTypesItem(
    unit: asT<String>(json, 'unit'),
    price: asT<int>(json, 'price'),
    gameCoinMin: asT<int>(json, 'gameCoinMin'),
    name: asT<String>(json, 'name'),
    gameCoinMax: asT<int>(json, 'gameCoinMax'),
    id: asT<int>(json, 'id'),
    enabled: asT<int>(json, 'enabled'),
  );

  Map<String, dynamic> toJson() => {
    'unit': unit,
    'price': price,
    'gameCoinMin': gameCoinMin,
    'name': name,
    'gameCoinMax': gameCoinMax,
    'id': id,
    'enabled': enabled,
  };
}



