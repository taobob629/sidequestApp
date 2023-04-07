import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/api/pay_api.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/event_bus/event_bus.dart';
import 'package:wy/model/db_model.dart';
import 'package:wy/model/im_sig_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/model/user_model.dart';
import 'package:wy/service/push_service.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/profile/voice_widget.dart';

import '../../api_service/profile_api.dart';
import '../../event_bus/beans/match_event.dart';
import '../../model/match/match_order_player.dart';
import '../../utils/db_helper.dart';
import '../common/dialog_match_top.dart';
import '../frame/messages/chat/chat_page.dart';
import '../frame/profile/model/profile_model.dart';

class UserController extends GetxController {
  static UserController instance() {
    return Get.find<UserController>();
  }

  static UserController get find => Get.find();

  Rx<UserModel> user = Rx(UserModel());

  // Rx<UserInfoModel> userInfoModel = UserInfoModel().obs;

  var _userProfile = ProfileModel().obs;

  getRxuserProfile() {
    return _userProfile;
  }

  ProfileModel get userProfile => _userProfile.value;

  set userProfile(ProfileModel value) {
    _userProfile.value = value;
  }

  RxList<String> imBlackList = RxList();

  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  late Timer _timer;

  Timer? _payNotifyTimer;

  int _payNotifyTimes = 0;

  int nums = 1;

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
    AudioManager.instance.stop();
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
          print("notify pay order:${payRecord.orderId}-${payRecord.createTime}");
          bool ret = await PayApi.backgroundNotify(payRecord.orderId, payRecord.tranId);
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
      //    userInfoModel.value = await UserApi.info();
      userProfile = await ProfileApi.getProfileInfo();
      //判断是否有语音
      voiceCheck();
    }
  }

  void voiceCheck() {
    if (userProfile.isAuth == TYPE_VIP && userProfile.voice.isEmpty) {
      Get.dialog(ConfirmDialog(
        title: 'Confirm'.tr,
        info: 'We suggest that you supplement the recording materials',
        concelBtn: 'CANCEL'.tr,
        onConfirm: () {
          Get.back();
          Get.toNamed(AppPages.Record);
        },
      ));
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
      if (DateTime.now().millisecondsSinceEpoch - lastLoginTime.millisecondsSinceEpoch < 600000) {
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
    LoginModel loginModel = await AuthApi.signIn(email, password).catchError((e) {
      EasyLoading.dismiss();
    });

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
    imLogin();
    done?.call(loginModel);
  }

  uploadOfflinePushInfoToken() async {
    if (!kIsWeb) {
      ChannelPush.requestPermission();
      Future.delayed(const Duration(seconds: 5), () async {
        final bool isUploadSuccess = await ChannelPush.uploadToken(PushConfig.appInfo);
        // ignore: avoid_print
        print("Push token upload result: $isUploadSuccess");
      });
    }
  }

  ///处理推送点击事件
  void handleClickNotification(Map<String, dynamic> msg) async {
    String ext = msg['ext'] ?? "";
    Map<String, dynamic> extMsp = jsonDecode(ext);
    String convId = extMsp["conversationID"] ?? "";
    if (convId.isNotEmpty) {
      Future.delayed(Duration(seconds: 1)).then((value) async {
        var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
        V2TimValueCallback<V2TimConversation> conv =
            await conversationManager.getConversation(conversationID: convId);
        if (conv.data != null) {
          Get.to(ChatPage(selectedConversation: conv.data!));
        }
      });
    }
  }

  jumpChat(uk) async {
    if (uk == null) {
      return;
    }
    var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
    V2TimValueCallback<V2TimConversation> conv =
        await conversationManager.getConversation(conversationID: "c2c_${uk}");
    if (conv.data != null)
      Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              selectedConversation: conv.data!,
            ),
          ));
  }

  initOfflinePush() async {
    await ChannelPush.init(handleClickNotification);
    uploadOfflinePushInfoToken();
  }

  void imLogin() async {
    if (imLoginDone.value == false) {
      ImSigModel userSig = await ImApi.login();
      // if(userSig == ""){
      //   userSig = "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwoZQweKU7MSCgswUJSsTAxAwN4KIp1YUZBalKlkZmpqaGgHFIaIlmbkgMTMzIDIztzSHmpGZDjIxozIovcIrSjvRvyBG39vA0T-Q2bHMLyOyoCzEPzAxvNDc0MPfMTs7MTLVwlapFgDpNC9g";
      // }
      // print("~~~~~~~~~${userSig.token}~~~~~~~~~~~~~");
      _coreInstance.login(userID: "${userSig.uid}", userSig: userSig.token).then((value) async {
        imLoginDone.value = true;
        //执行登录 IM 成功后调用。初始化push
        initOfflinePush();
        // print("~~~~~~~~~im login done~~~~~~~~~~~~~");
        TencentImSDKPlugin.v2TIMManager.getConversationManager().addConversationListener(
                listener: V2TimConversationListener(onTotalUnreadMessageCountChanged: (count) {
              flog(count, 'onTotalUnreadMessageCountChanged');
              unreadMsgCount.value = count;
              FlutterAppBadger.isAppBadgeSupported().then((value) {
                flog(value, 'onTotalUnreadMessageCountChanged');
                if (unreadMsgCount.value == 0) {
                  FlutterAppBadger.removeBadge();
                } else {
                  FlutterAppBadger.updateBadgeCount(unreadMsgCount.value, title: 'New Message');
                }
              });
            }, onConversationChanged: (v) {
              flog(v.length, 'onConversationChanged');
            }, onNewConversation: (v) {
              flog(v.length, 'onNewConversation');
            }));
        TencentImSDKPlugin.v2TIMManager.getMessageManager().addAdvancedMsgListener(
            listener: V2TimAdvancedMsgListener(onRecvNewMessage: (V2TimMessage msg) {
          //播放提示音
          FlutterRingtonePlayer.playNotification();
          _dealMsg(msg);
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
              FlutterAppBadger.updateBadgeCount(unreadMsgCount.value, title: 'New Message');
            }
          });
        }
      });
    }
  }

  void _dealMsg(V2TimMessage msg) {
    Map<String, dynamic> map = json.decode(msg.textElem!.text!);

    switch (map["type"]) {
      case 'match_order_player':
        MatchOrderPlayer player = MatchOrderPlayer.fromJson(map["message"]);

        if (Get.isRegistered<DialogMatchTopController>()) {
          // 防止多次弹窗
          DialogMatchTopController ctr = Get.find<DialogMatchTopController>();
          if (ctr.countDownUtil.isShow) {
            ctr.player = player;
            ctr.countDownUtil.updateSeconds(10);
            ctr.update();
          } else {
            Get.dialog(
              MatchTopDialog(),
              arguments: {'seconds': 10, 'player': player},
              barrierColor: Colors.black26,
            );
          }
        } else {
          Get.dialog(
            MatchTopDialog(),
            arguments: {'seconds': 10, 'player': player},
            barrierColor: Colors.black26,
          );
        }
        break;

      case 'match_order_completed':
        // 陪玩老板点击play后，player从这里跳转进去
        if (userProfile?.pwId != map["message"]["uid"]) {
          String str = Get.routing.current;
          if (AppPages.side_kick_match_suc_page == str) {
            Get.back();
          }
          jumpChat(map["message"]["memberCode"]);
        }
        break;
    }

    eventBus.fire(MatchEvent(msg: msg));
  }

  void logout({Function? done}) async {
    user.value = UserModel();
    userProfile = ProfileModel();
    StorageManager.clear(StorageManager.kUser);
    StorageManager.clear(StorageManager.kPassword);
    StorageManager.clear(StorageManager.kLoginTime);
    StorageManager.clear(StorageManager.kToken);
    await _coreInstance.logout();
    imLoginDone.value = false;
    unreadMsgCount.value = 0;
    done?.call();
  }

  Future<void> appLogout() async {
    EasyLoading.show();
    await AuthApi.signOut();
    await AppConfig.flutterLocalNotificationsPlugin.cancelAll();
    EasyLoading.dismiss();
    logout(done: () => Get.offAllNamed(AppPages.Login));
  }

  String gradeImg() {
    int isauth = userProfile?.isAuth ?? 0;
    int level = userProfile?.sidekickLevel ?? 0;
    if (level == 0) {
      if (isauth == TYPE_VIP)
        return 'assets/images/grade/${isauth == TYPE_VIP ? 'v_' : ''}grade1.webp';
    }
    return 'assets/images/grade/${isauth == TYPE_VIP ? 'v_' : ''}grade${level}.webp';
  }

  toRecordPage(BuildContext context){
    pickVoiceDialog(context,userProfile.voice,(result){
      flog('callback $result');
      if (result != null) userProfile.voice = result;
    });
    // Get.toNamed(AppPages.Record,arguments:userProfile.voice)?.then((result) {
    //   if (result != null) userProfile.voice = result;
    // });
  }
}
