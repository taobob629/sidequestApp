import 'package:get/get.dart';
import 'package:wy/model/safe_convert.dart';
import 'package:wy/utils/index.dart';

const int ONLINE = 1;
const int WOMAN = 1;
const int MAN = 0;
const int OTHERS = -1;

class GameUserModel {
  // 0
  final double distance;

  // 5
  final int star;

  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1673614260256.jpg
  final String thumb;

  // Hey there! I am using SideQuest.
  final String signature;

  // 1
  final int sex;

  // 宗师
  final String levelName;

  // 1
  final int userLevel;

  // null
  final dynamic backGround;

  // 50/Hour
  final String price;

  // som
  final String name;

  // 0
  final int online;

  // 0
  final int orders;

  // 73897
  final int id;

  // 25
  final int age;

  // uk123455
  final String uk;

  final List<SimpleGameInfo> games;
  RxList<SimpleGameInfo> showGames = RxList();

  initShowGames() {
    showGames.clear();
    if (games.length > 3) {
      showGames.addAll(games.sublist(0, 3));
    } else {
      showGames.addAll(games);
    }
  }

  expand() {
    flog('expand');

    if (showGames.length <= 3) {
      showGames.clear();
      showGames.addAll(games);
    } else {
      showGames.clear();
      showGames.addAll(games.sublist(0, 3));
    }
    flog('showGames${showGames.length}');
  }

  RxBool fold = RxBool(false);

  GameUserModel({
    this.distance = 0,
    this.star = 0,
    this.thumb = "",
    this.signature = "",
    this.sex = 0,
    this.levelName = "",
    this.userLevel = 0,
    this.backGround,
    this.price = "",
    this.name = "",
    this.online = 0,
    this.orders = 0,
    this.id = 0,
    this.age = 0,
    this.uk = "",
    required this.games,
  });

  factory GameUserModel.fromJson(Map<String, dynamic>? json) => GameUserModel(
        distance: asT<double>(json, 'distance'),
        star: asT<int>(json, 'star'),
        thumb: asT<String>(json, 'thumb'),
        signature: asT<String>(json, 'signature'),
        sex: asT<int>(json, 'sex'),
        levelName: asT<String>(json, 'levelName'),
        userLevel: asT<int>(json, 'userLevel'),
        backGround: asT<dynamic>(json, 'backGround'),
        price: asT<String>(json, 'price'),
        name: asT<String>(json, 'name'),
        online: asT<int>(json, 'online'),
        orders: asT<int>(json, 'orders'),
        id: asT<int>(json, 'id'),
        age: asT<int>(json, 'age'),
        uk: asT<String>(json, 'uk'),
        games: asT<List>(json, 'games').map((e) => SimpleGameInfo.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'distance': distance,
        'star': star,
        'thumb': thumb,
        'signature': signature,
        'sex': sex,
        'levelName': levelName,
        'userLevel': userLevel,
        'backGround': backGround,
        'price': price,
        'name': name,
        'online': online,
        'orders': orders,
        'id': id,
        'age': age,
      };
}

class SimpleGameInfo {
  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/ApexLegends.jpg
  final String ico;

  // Apex Legends
  final String name;

  SimpleGameInfo({
    this.ico = "",
    this.name = "",
  });

  factory SimpleGameInfo.fromJson(Map<String, dynamic>? json) => SimpleGameInfo(
        ico: asT<String>(json, 'ico'),
        name: asT<String>(json, 'name'),
      );

  Map<String, dynamic> toJson() => {
        'ico': ico,
        'name': name,
      };
}
