import 'dart:developer';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wy/model/credit_card_model.dart';
import 'package:wy/model/user_model.dart';
import 'dart:convert' as convert;

class StorageManager {
  /// app全局配置
  static late SharedPreferences sharedPreferences;

  /// 临时目录
  static Directory? temporaryDirectory;

  static const String kUser = 'kUser';
  static const String kToken = 'kToken';
  static const String kAccount = 'kAccount';
  static const String kPassword = 'kPassword';
  static const String kLoginTime = 'kLoginTime';
  static const String kCart = 'kCart';
  static const String kCredit = 'kCredit';
  static const String kPushToken = 'kPushToken';
  static const String kEnv= 'kEnv';
  static const String kPayPasswordCheckTime= 'kPayPasswordCheckTime';

  /// 必备数据的初始化操作
  ///
  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    temporaryDirectory = await getTemporaryDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static UserModel getUser(){
    String? value = sharedPreferences.getString(kUser);
    if(value == null) {
      return UserModel();
    }
    var userMap = convert.jsonDecode(value);
    return UserModel.fromJson(userMap);
  }

  static void setUser(UserModel user){
    String value = convert.jsonEncode(user.toJson());
    sharedPreferences.setString(kUser, value);
  }

  static void clearUser(){
    sharedPreferences.remove(kUser);
  }

  static String getToken(){
    String? value = sharedPreferences.getString(kToken);
    if(value == null){
      return "";
    }
    return value;
  }

  static void setToken(String value){
    sharedPreferences.setString(kToken, value);
  }

  static DateTime getPayPasswordCheckTime(){
    String? value = sharedPreferences.getString(kPayPasswordCheckTime);
    if(value == null){
      return DateTime.parse("1970-01-01 00:00:00");
    }
    return DateTime.fromMillisecondsSinceEpoch(int.parse(value));
  }

  static void setPayPasswordCheckTime(DateTime value){
    sharedPreferences.setString(kPayPasswordCheckTime, value.millisecondsSinceEpoch.toString());
  }

  static String getPushToken(){
    String? value = sharedPreferences.getString(kPushToken);
    if(value == null){
      return "";
    }
    return value;
  }

  static void setPushToken(String? value){
    log("PushToken::$value",name: "WY");
    sharedPreferences.setString(kPushToken, value == null ?"":value);
  }

  static String getAccount(){
    String? value = sharedPreferences.getString(kAccount);
    if(value == null){
      return "";
    }
    return value;
  }

  static void setAccount(String value){
    sharedPreferences.setString(kAccount, value);
  }

  static String getPassword(){
    String? value = sharedPreferences.getString(kPassword);
    if(value == null){
      return "";
    }
    return value;
  }

  static void setPassword(String value){
    sharedPreferences.setString(kPassword, value);
  }

  static int getLoginTime(){
    int? value = sharedPreferences.getInt(kLoginTime);
    if(value == null){
      return 0;
    }
    return value;
  }

  static void setLoginTime(int value){
    sharedPreferences.setInt(kLoginTime, value);
  }

  static String getCart(){
    String? value = sharedPreferences.getString(kCart);
    if(value == null){
      return "";
    }
    return value;
  }

  static void setCart(String value){
    sharedPreferences.setString(kCart, value);
  }

  static String getEnv(){
    String? value = sharedPreferences.getString(kEnv);
    if(value == null){
      return "prod";
    }
    return value;
  }

  static bool haveEnv(){
    String? value = sharedPreferences.getString(kEnv);
    if(value == null || value.isEmpty){
      return false;
    }
    return true;
  }

  static void setEnv(String value){
    sharedPreferences.setString(kEnv, value);
  }

  static void clear(String key){
    sharedPreferences.remove(key);
  }

  static CreditCardModel getCreditCardModel(){
    String? value = sharedPreferences.getString(kCredit);
    if(value == null) {
      return CreditCardModel();
    }
    var map = convert.jsonDecode(value);
    return CreditCardModel.fromJson(map);
  }

  static void setCreditCardModel(CreditCardModel model){
    String value = convert.jsonEncode(model.toJson());
    sharedPreferences.setString(kCredit, value);
  }
}
