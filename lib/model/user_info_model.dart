import 'dart:convert';

const int TYPE_VIP = 1; //1是大神

class UserInfoModel {
  late int freeMins = 0;
  late int orderCount = 0;
  late int eventCount = 0;
  late String nick = "Guest";
  late String avatar = "";
  late int uid = 0;
  late int vipLevel = 0;
  late String balance = "0.00";
  late String coin = "0";
  late String votes = "0.00";
  late int coupons = 0;
  late int bookingCount = 0;
  late String email = "";
  late int total = 0;
  late int remain = 0;
  late int isauth = 0; //1 大神
  late int pwuserId = 0;
  late int level = 0; //用户等级
  late Location location;

  UserInfoModel();
  balanceMoney(){
    return '£$balance';
  }
  UserInfoModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    level = json['level'];
    email = json['email'];
    nick = json['nick'] ?? '';
    avatar = json['avatar'] == null ? "" : json['avatar'];
    vipLevel = json['vipLevel'];
    balance = "£"+json['balance'];
    votes = json['votes'].toString();
    coin = json['coin'].toString();
    freeMins = json['freeMins'];
    coupons = json['coupons'];
    orderCount = json['orderCount'];
    eventCount = json['eventCount'];
    bookingCount = json['bookingCount'];
    total = json['total'] == null ? 0 : json['total'];
    remain = json['remain'] == null ? 0 : json['remain'];
    isauth = json['isauth'] == null ? 0 : json['isauth'];
    pwuserId = json['pwuserId'] == null ? 0 : json['pwuserId'];
    location = Location.fromStr(json['location']);
  }
}

class Location {
  String? country;
  String? city;
  String? state;
  location(){
    if(country==null)return 'unknown';
    if(state==null)return country;
    if(city==null)return state;
    return city;
  }
  @override
  String toString() {
    return 'Location{country: $country, city: $city, state: $state}';
  }

  Location();

  Location.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    city = json['city'];
    state = json['state'];
  }

  Location.fromStr(String? str) {
    if (str == null || str.isEmpty == true) return;
    var map = json.decode(str);
    country = map['country'];
    city = map['city'];
    state = map['state'];
  }
}
