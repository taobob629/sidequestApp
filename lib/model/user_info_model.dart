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
  late int level = 0;//用户等级

  UserInfoModel();

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    level = json['level'];
    email = json['email'];
    nick = json['nick'] ?? '';
    avatar = json['avatar'] == null ? "" : json['avatar'];
    vipLevel = json['vipLevel'];
    balance = json['balance'];
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
  }
}
