import 'package:sq_hub_app/model/safe_convert.dart';

class ConsumListBean {
  // null
  final dynamic id;

  // Counter-Stike: Global Offensive
  final String gameName;

  // null
  final dynamic processName;

  // 378233
  final int memberId;

  // null
  final dynamic ip;

  // 0
  final int storeId;

  // 5332
  final int gameTime;

  // 0
  final int start;

  // 0
  final int end;

  // 11
  final int gameId;

  // null
  final dynamic storeName;

  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/730_library_600x900.jpg
  final String cover;

  // null
  final dynamic nickName;

  ConsumListBean({
    this.id,
    this.gameName = "",
    this.processName,
    this.memberId = 0,
    this.ip,
    this.storeId = 0,
    this.gameTime = 0,
    this.start = 0,
    this.end = 0,
    this.gameId = 0,
    this.storeName,
    this.cover = "",
    this.nickName,
  });

  factory ConsumListBean.fromJson(Map<String, dynamic>? json) => ConsumListBean(
        gameName: asT<String>(json, 'gameName'),
        processName: asT<dynamic>(json, 'processName'),
        memberId: asT<int>(json, 'memberId'),
        ip: asT<dynamic>(json, 'ip'),
        storeId: asT<int>(json, 'storeId'),
        gameTime: asT<int>(json, 'gameTime'),
        start: asT<int>(json, 'start'),
        end: asT<int>(json, 'end'),
        gameId: asT<int>(json, 'gameId'),
        storeName: asT<dynamic>(json, 'storeName'),
        cover: asT<String>(json, 'cover'),
        nickName: asT<dynamic>(json, 'nickName'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameName': gameName,
        'processName': processName,
        'memberId': memberId,
        'ip': ip,
        'storeId': storeId,
        'gameTime': gameTime,
        'start': start,
        'end': end,
        'gameId': gameId,
        'storeName': storeName,
        'cover': cover,
        'nickName': nickName,
      };

  formatGameTime() {
    if (gameTime > 0 && gameTime < 60) return '0 h 1 m';
    var min = gameTime ~/ 60; //转为分钟
    if (min < 60) {
      return '0 h ${min.toInt()} m';
    }
    var hour = min / 60;
    return '${hour.toInt()} h ${min % 60} m';
  }
}
