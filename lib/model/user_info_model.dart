
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

  UserInfoModel();

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    nick = json['nick'];
    avatar = json['avatar'] == null ? "":json['avatar'];
    vipLevel = json['vipLevel'];
    balance = json['balance'];
    votes = json['votes'].toString();
    coin = json['coin'].toString();
    freeMins = json['freeMins'];
    coupons = json['coupons'];
    orderCount = json['orderCount'];
    eventCount = json['eventCount'];
    bookingCount = json['bookingCount'];
    total = json['total'] == null ? 0:json['total'];
    remain = json['remain'] == null ? 0:json['remain'];
  }
}