import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/api/pay_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/model/db_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/model/user_model.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../utils/db_helper.dart';

class UserController extends GetxController {
  Rx<UserModel> user = Rx(UserModel());
  Rx<UserInfoModel> userInfoModel = UserInfoModel().obs;

  late Timer _timer;

  Timer? _payNotifyTimer;

  int  _payNotifyTimes = 0;

  DBHelper? db;

  DateTime lastLoginTime = DateTime.parse("1970-01-01 00:00:00");

  var imLoginDone = false.obs;

  @override
  void onReady() async {
    super.onReady();
    await login();
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      login();
    });
    startPayNotify();
  }

  @override
  void onClose() {
    _timer.cancel();
    _cancelPayNotify();
    super.onClose();
  }

  ///开始定时回调支付结果
  void startPayNotify(){
    _cancelPayNotify();
    _payNotifyTimer = Timer.periodic(Duration(seconds: 2), (timer) async{
      if(db != null){
        List<PayRecord> list = await db!.selectPayRecords();
        if(list.isEmpty){
          print("no pay order need notify");
          _cancelPayNotify();
        }
        list.forEach((payRecord) async{
          print("notify pay order:${payRecord.orderId}-${payRecord.createTime}");
          bool ret = await PayApi.backgroundNotify(payRecord.orderId, payRecord.tranId);
          if(ret == true){
            await db!.deletePayRecord(payRecord.orderId);
          }
        });
      }
      _payNotifyTimes ++;
      if(_payNotifyTimes >= 60){
        _cancelPayNotify();
      }
    });
  }

  void _cancelPayNotify(){
    if(_payNotifyTimer != null) {
      _payNotifyTimer!.cancel();
      _payNotifyTimes = 0;
    }
  }

  Future<void> updateInfo() async{
    if(StorageManager.getToken().isNotEmpty) {
      userInfoModel.value = await UserApi.info();
    }
  }

  void _updateUser(UserModel userModel){
    user.value = userModel;
    StorageManager.setUser(userModel);
  }

  void checkLogin(Function done){
    if(user.value.id == 0){
      Get.to(()=>LoginPage());
    }else{
      done.call();
    }
  }
  
  Future<void> login(
    {String? email, String? password, bool showLoading = false, bool checkLastLoginTime = false,
    Function(LoginModel)? done}) async{
    if(checkLastLoginTime) {
      if(DateTime.now().millisecondsSinceEpoch - lastLoginTime.millisecondsSinceEpoch < 600000){
        return;
      }
    }

    if(email == null){
      email = StorageManager.getAccount();
    }
    if(password == null){
      password = StorageManager.getPassword();
    }
    if(email.isEmpty || password.isEmpty){
      return;
    }
    if(showLoading == true){
      EasyLoading.show();
    }
    LoginModel loginModel = await AuthApi.signIn(email, password);

    if(loginModel.validate == 0) {//老用户需要更新资料之后才可以使用
      lastLoginTime = DateTime.now();
      _updateUser(loginModel.user);
      StorageManager.setToken(loginModel.token);
      StorageManager.setAccount(email);
      StorageManager.setPassword(password);
      StorageManager.setLoginTime(DateTime.now().millisecondsSinceEpoch);
      await updateInfo();
    }
    if(showLoading == true){
      EasyLoading.dismiss();
    }
    if(loginModel.user.id != 0){
      db = DBHelper(loginModel.user.id);
    }
    done?.call(loginModel);
  }

  void logout({Function? done}) async{
    user.value = UserModel();
    userInfoModel.value = UserInfoModel();
    StorageManager.clear(StorageManager.kUser);
    StorageManager.clear(StorageManager.kPassword);
    StorageManager.clear(StorageManager.kLoginTime);
    StorageManager.clear(StorageManager.kToken);
    done?.call();
  }

}