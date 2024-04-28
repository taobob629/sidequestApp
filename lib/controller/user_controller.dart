import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../api/auth_api.dart';
import '../api/pay_api.dart';
import '../api/profile_api.dart';
import '../config/lang/translations.dart';
import '../model/db_model.dart';
import '../model/login_model.dart';
import '../model/profile_model.dart';
import '../model/user_model.dart';
import '../ui/dialog/dialog_confirm.dart';
import '../ui/pages/login/login_page.dart';
import '../ui/pages/scan/qr_login_page.dart';
import '../ui/pages/scan/scan_page.dart';
import '../utils/db_helper.dart';
import '../utils/storage_manager.dart';
import '../utils/toast_utils.dart';

class UserController extends GetxController {
  bool hasDidVoiceCheck = false; //只检查一次
  static UserController instance() {
    return Get.find<UserController>();
  }

  static UserController get find => Get.find();

  Rx<UserModel> user = Rx(UserModel());

  // Rx<UserInfoModel> userInfoModel = UserInfoModel().obs;

  var _userProfile = ProfileModel().obs;

  DBHelper? db;

  Rx<ProfileModel> getRxuserProfile() {
    return _userProfile;
  }

  ProfileModel get userProfile => _userProfile.value;

  set userProfile(ProfileModel value) {
    _userProfile.value = value;
  }

  RxList<String> imBlackList = RxList();

  late Timer _timer;

  Timer? _payNotifyTimer;

  int _payNotifyTimes = 0;

  int nums = 1;

  DateTime lastLoginTime = DateTime.parse("1970-01-01 00:00:00");

  var imLoginDone = false.obs;

  var unreadMsgCount = 0.obs;
  final online = false.obs;

  @override
  void onInit() {
    super.onInit();
    Get.updateLocale(Get.locale ?? ENGLISH);
    initEasyLoadding();
  }

  initEasyLoadding() {
    // 全局配置SmartDialog的参数
    SmartDialog.config.toast = SmartConfigToast(alignment: Alignment.center);
    SmartDialog.config.loading = SmartConfigLoading(clickMaskDismiss: true);
  }

  @override
  void onReady() async {
    super.onReady();
    await switchLogin();
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      switchLogin();
    });
  }

  ///开始定时回调支付结果
  void startPayNotify() {
    _cancelPayNotify();
    _payNotifyTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (db != null) {
        List<PayRecord> list = await db!.selectPayRecords();
        if (list.isEmpty) {
          print("no pay order need notify");
          _cancelPayNotify();
        }
        list.forEach((payRecord) async {
          print(
              "notify pay order:${payRecord.orderId}-${payRecord.createTime}");
          bool ret = await PayApi.backgroundNotify(
              payRecord.orderId, payRecord.tranId);
          if (ret == true) {
            await db!.deletePayRecord(payRecord.orderId);
          }
        });
      }
      _payNotifyTimes++;
      if (_payNotifyTimes >= 60) {
        _cancelPayNotify();
      }
    });
  }

  Future<void> switchLogin({bool checkLastLoginTime = false}) async {
    await login(
      showLoadings: false,
      checkLastLoginTime: checkLastLoginTime,
    );
  }

  Future<void> updateInfo() async {
    if (StorageManager.getToken().isNotEmpty) {
      //    userInfoModel.value = await UserApi.info();
      userProfile = await ProfileApi.getProfileInfo();
      //判断是否有语音
      if (hasDidVoiceCheck) return;
      //  voiceCheck();
    }
  }

  static setCustomSticker() async {
    // 添加自定义表情包
    // Add custom sticker package
    // List<CustomStickerPackage> customStickerPackageList = [];
    // final defEmojiList = emojiData.asMap().keys.map((emojiIndex) {
    //   final emo = Emoji.fromJson(emojiData[emojiIndex]);
    //   return CustomSticker(index: emojiIndex, name: emo.name, unicode: emo.unicode);
    // }).toList();
    // customStickerPackageList.add(CustomStickerPackage(name: "defaultEmoji", stickerList: defEmojiList, isEmoji: true, isDefaultEmoji: true, menuItem: defEmojiList[0]));
    // customStickerPackageList.addAll(Const.emojiList.map((customEmojiPackage) {
    //   return CustomStickerPackage(
    //       name: customEmojiPackage.name,
    //       isDefaultEmoji: true,
    //       isEmoji: true,
    //       baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
    //       stickerList: customEmojiPackage.list.asMap().keys.map((idx) => CustomSticker(index: idx, name: customEmojiPackage.list[idx])).toList(),
    //       menuItem: CustomSticker(
    //         index: 0,
    //         name: customEmojiPackage.icon,
    //       ));
    // }).toList());
    // Provider.of<CustomStickerPackageData>(context!, listen: false).customStickerPackageList = customStickerPackageList;
  }

  @override
  void onClose() {
    _timer.cancel();
    _cancelPayNotify();
    super.onClose();
  }

  void _cancelPayNotify() {
    if (_payNotifyTimer != null) {
      _payNotifyTimer!.cancel();
      _payNotifyTimes = 0;
    }
  }

  void _updateUser(UserModel userModel) {
    user.value = userModel;
    StorageManager.setUser(userModel);
  }

  void checkLogin(Function done) {
    if (user.value.id == 0) {
      Get.offAll(() => LoginPage());
    } else {
      done.call();
    }
  }

  Future<void> login(
      {String? email,
      String? password,
      bool showLoadings = false,
      bool checkLastLoginTime = false,
      Function(LoginModel)? done}) async {
    if (checkLastLoginTime) {
      if (DateTime.now().millisecondsSinceEpoch -
              lastLoginTime.millisecondsSinceEpoch <
          600000) {
        return;
      }
    }

    email ??= StorageManager.getAccount();
    password ??= StorageManager.getPassword();
    if (email.isEmpty || password.isEmpty) {
      return;
    }
    if (showLoadings == true) {
      showLoading(clickMaskDismiss: false);
    }
    LoginModel loginModel =
        await AuthApi.signIn(email, password).catchError((e) {
      dismissLoading();
    });

    setLocalInfo(
      loginModel,
      done,
      loginFlag: 'password',
      password: password,
    );
  }

  void setLocalInfo(
    LoginModel loginModel,
    Function(LoginModel)? done, {
    String? password,
    String? loginFlag,
    String? idToken,
    String? discordAppId,
    String? email,
    String? nickName,
    String? discriminator,
  }) async {
    if (loginModel.token.isEmpty) {
      dismissLoading();
      return;
    }

    if (loginFlag != null) {
      StorageManager.setString('loginFlag', loginFlag);
    }

    if (loginModel.validate == 0) {
      //老用户需要更新资料之后才可以使用
      lastLoginTime = DateTime.now();

      _updateUser(loginModel.user);
      StorageManager.setToken(loginModel.token);
      StorageManager.setAccount(loginModel.user.email);
      if (password != null) {
        StorageManager.setPassword(password);
      }
      StorageManager.setLoginTime(DateTime.now().millisecondsSinceEpoch);
    }
    if (loginModel.user.id != 0) {
      db = DBHelper(loginModel.user.id);
    }

    done?.call(loginModel);

    await updateInfo();
  }

  void logout({Function? done}) async {
    user.value = UserModel();
    userProfile = ProfileModel();
    imLoginDone.value = false;
    StorageManager.clear(StorageManager.kUser);
    StorageManager.clear(StorageManager.kPassword);
    StorageManager.clear(StorageManager.kLoginTime);
    StorageManager.clear(StorageManager.kToken);
    imLoginDone.value = false;
    unreadMsgCount.value = 0;
    done?.call();
  }

  Future<void> appLogout() async {
    showLoading();
    await AuthApi.signOut();
    dismissLoading();
    logout(done: () => Get.offAll(() => LoginPage()));
  }

  void scan() {
    Get.to(() => ScanPage())?.then((value) async {
      if (value == null) {
        return;
      }
      String data = value.toString();
      //String deData = decryptData(data);
      Get.to(() => QrLoginPage(
        code: data,
      ));
    });
  }
}
