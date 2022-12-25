import 'dart:async';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/constants/emoji.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';
import 'package:tim_ui_kit_sticker_plugin/tim_ui_kit_sticker_plugin.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/api/pay_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/model/db_model.dart';
import 'package:wy/model/im_sig_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/model/user_model.dart';
import 'package:wy/provider/custom_sticker_package_data.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/tim_ui/my_constant.dart';

import '../../utils/db_helper.dart';

class UserController extends GetxController {
  Rx<UserModel> user = Rx(UserModel());
  Rx<UserInfoModel> userInfoModel = UserInfoModel().obs;

  RxList<String> imBlackList = RxList();

  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  late Timer _timer;

  Timer? _payNotifyTimer;

  int _payNotifyTimes = 0;

  DBHelper? db;

  DateTime lastLoginTime = DateTime.parse("1970-01-01 00:00:00");

  var imLoginDone = false.obs;

  var unreadMsgCount = 0.obs;

  @override
  void onReady() async {
    super.onReady();
    await login();
    // setCustomSticker();
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      login();
    });
    //startPayNotify();
  }

  static setCustomSticker() async {
    // 添加自定义表情包
    // Add custom sticker package
    List<CustomStickerPackage> customStickerPackageList = [];
    final defEmojiList = emojiData.asMap().keys.map((emojiIndex) {
      final emo = Emoji.fromJson(emojiData[emojiIndex]);
      return CustomSticker(
          index: emojiIndex, name: emo.name, unicode: emo.unicode);
    }).toList();
    customStickerPackageList.add(CustomStickerPackage(
        name: "defaultEmoji",
        stickerList: defEmojiList,
        isEmoji: true,
        isDeafultEmoji: true,
        menuItem: defEmojiList[0]));
    customStickerPackageList.addAll(Const.emojiList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          isDeafultEmoji: true,
          isEmoji: true,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map((idx) =>
                  CustomSticker(index: idx, name: customEmojiPackage.list[idx]))
              .toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList());
    Provider.of<CustomStickerPackageData>(context!, listen: false)
        .customStickerPackageList = customStickerPackageList;
  }

  @override
  void onClose() {
    _timer.cancel();
    _cancelPayNotify();
    super.onClose();
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

  void _cancelPayNotify() {
    if (_payNotifyTimer != null) {
      _payNotifyTimer!.cancel();
      _payNotifyTimes = 0;
    }
  }

  Future<void> updateInfo() async {
    if (StorageManager.getToken().isNotEmpty) {
      userInfoModel.value = await UserApi.info();
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
      bool showLoading = false,
      bool checkLastLoginTime = false,
      Function(LoginModel)? done}) async {
    if (checkLastLoginTime) {
      if (DateTime.now().millisecondsSinceEpoch -
              lastLoginTime.millisecondsSinceEpoch <
          600000) {
        return;
      }
    }

    if (email == null) {
      email = StorageManager.getAccount();
    }
    if (password == null) {
      password = StorageManager.getPassword();
    }
    if (email.isEmpty || password.isEmpty) {
      return;
    }
    if (showLoading == true) {
      EasyLoading.show();
    }
    LoginModel loginModel = await AuthApi.signIn(email, password);

    if (loginModel.validate == 0) {
      //老用户需要更新资料之后才可以使用
      lastLoginTime = DateTime.now();
      _updateUser(loginModel.user);
      StorageManager.setToken(loginModel.token);
      StorageManager.setAccount(email);
      StorageManager.setPassword(password);
      StorageManager.setLoginTime(DateTime.now().millisecondsSinceEpoch);
      await updateInfo();
    }
    if (showLoading == true) {
      EasyLoading.dismiss();
    }
    if (loginModel.user.id != 0) {
      db = DBHelper(loginModel.user.id);
    }
    // imLogin();
    done?.call(loginModel);
  }

  void imLogin() async {
    if (imLoginDone.value == false) {
      ImSigModel userSig = await ImApi.login();
      // if(userSig == ""){
      //   userSig = "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwoZQweKU7MSCgswUJSsTAxAwN4KIp1YUZBalKlkZmpqaGgHFIaIlmbkgMTMzIDIztzSHmpGZDjIxozIovcIrSjvRvyBG39vA0T-Q2bHMLyOyoCzEPzAxvNDc0MPfMTs7MTLVwlapFgDpNC9g";
      // }
      // print("~~~~~~~~~${userSig.token}~~~~~~~~~~~~~");
      _coreInstance
          .login(userID: "${userSig.uid}", userSig: userSig.token)
          .then((value) async {
        imLoginDone.value = true;
        // print("~~~~~~~~~im login done~~~~~~~~~~~~~");
        TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .addConversationListener(
                listener: V2TimConversationListener(
                    onTotalUnreadMessageCountChanged: (count) {
              flog(count, 'onTotalUnreadMessageCountChanged');
              unreadMsgCount.value = count;
              FlutterAppBadger.isAppBadgeSupported().then((value) {
                flog(value, 'onTotalUnreadMessageCountChanged');
                if (unreadMsgCount.value == 0) {
                  FlutterAppBadger.removeBadge();
                } else {
                  FlutterAppBadger.updateBadgeCount(unreadMsgCount.value,
                      title: 'New Message');
                }
              });
            }, onConversationChanged: (v) {
              flog(v.length, 'onConversationChanged');
            }, onNewConversation: (v) {
              flog(v.length, 'onNewConversation');
            }));
        TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .addAdvancedMsgListener(listener:
                V2TimAdvancedMsgListener(onRecvNewMessage: (V2TimMessage msg) {
          //播放提示音
          FlutterRingtonePlayer.playNotification();
        }));

        ///获取未读数量
        var v2timValueCallback = await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getTotalUnreadMessageCount();
        if (v2timValueCallback.code == 0) {
          flog(v2timValueCallback.data, 'getTotalUnreadMessageCount');
          unreadMsgCount.value = v2timValueCallback.data!;
          FlutterAppBadger.isAppBadgeSupported().then((value) {
            if (unreadMsgCount.value == 0) {
              FlutterAppBadger.removeBadge();
            } else {
              flog(value, 'getTotalUnreadMessageCount');
              FlutterAppBadger.updateBadgeCount(unreadMsgCount.value,
                  title: 'New Message');
            }
          });
        }
      });
    }
  }

  void logout({Function? done}) async {
    user.value = UserModel();
    userInfoModel.value = UserInfoModel();
    StorageManager.clear(StorageManager.kUser);
    StorageManager.clear(StorageManager.kPassword);
    StorageManager.clear(StorageManager.kLoginTime);
    StorageManager.clear(StorageManager.kToken);
    await _coreInstance.logout();
    imLoginDone.value = false;
    unreadMsgCount.value = 0;
    done?.call();
  }
}
