import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
import 'package:wy/ui/common/dialog_show_info.dart';
import 'package:wy/ui/frame/messages/chat/chat_tool.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/profile/voice_widget.dart';
import 'package:wy/widget/show_error_widget.dart';

import '../../api/wy_http.dart';
import '../../api_service/profile_api.dart';
import '../../config/icon_font.dart';
import '../../event_bus/beans/match_event.dart';
import '../../image_utils.dart';
import '../../model/match/match_order_player.dart';
import '../../utils/db_helper.dart';
import '../../utils/login_flag.dart';
import '../../utils/toast_utils.dart';
import '../common/dialog_match_top.dart';
import '../frame/messages/chat/chat_page.dart';
import '../frame/profile/model/profile_model.dart';

class UserController extends GetxController {
  bool hasDidVoiceCheck = false; //只检查一次
  static UserController instance() {
    return Get.find<UserController>();
  }

  static UserController get find => Get.find();

  Rx<UserModel> user = Rx(UserModel());

  // Rx<UserInfoModel> userInfoModel = UserInfoModel().obs;

  var _userProfile = ProfileModel().obs;

  Rx<ProfileModel> getRxuserProfile() {
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
  final online = false.obs;

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void onReady() async {
    super.onReady();
    flog('UserController onReady==');
    await switchLogin();
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      switchLogin();
    });
  }

  Future<void> switchLogin({bool checkLastLoginTime = false}) async {
    var password = StorageManager.getPassword();
    switch (password.toLowerCase()) {
      case LoginFlag.ios:
        await appleLogin(showLoadings: false);
        isSigningIn = false;
        break;

      case LoginFlag.google:
        await googleLogin(showLoadings: false);
        isSigningIn = false;
        break;

      case LoginFlag.discord:
        await discordLogin(showLoadings: false);
        isSigningIn = false;
        break;

      default:
        await login(showLoadings: false, checkLastLoginTime: checkLastLoginTime);
        isSigningIn = false;
        break;
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
      //    userInfoModel.value = await UserApi.info();
      userProfile = await ProfileApi.getProfileInfo();
      //判断是否有语音
      if (hasDidVoiceCheck) return;
      voiceCheck();
    }
  }

  void voiceCheck() {
    if (userProfile.isAuth == TYPE_VIP && userProfile.voice?.isEmpty == true) {
      hasDidVoiceCheck = true;
      Get.dialog(ConfirmDialog(
        title: 'Confirm'.tr,
        info: 'We suggest that you supplement the recording materials'.tr,
        concelBtn: 'CANCEL'.tr,
        onConfirm: () {
          Get.back();
          toRecordPage(Get.context!!);
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

    if (email == null) {
      email = StorageManager.getAccount();
    }
    if (password == null) {
      password = StorageManager.getPassword();
    }
    if (email.isEmpty || password.isEmpty) {
      return;
    }
    if (showLoadings == true) {
      showLoading();
    }
    LoginModel loginModel =
        await AuthApi.signIn(email, password).catchError((e) {
      dismissLoading();
    });

    setLocalInfo(loginModel, password, done);
  }

  Future<void> appleLogin({
    bool needAppleLogin = false,
    bool showLoadings = true,
    bool checkLastLoginTime = false,
    Function(LoginModel)? done,
  }) async {
    if (checkLastLoginTime) {
      if (DateTime.now().millisecondsSinceEpoch -
              lastLoginTime.millisecondsSinceEpoch <
          600000) {
        return;
      }
    }

    AuthorizationCredentialAppleID credential;
    String? userIdentifier = StorageManager.getString('userIdentifier');
    if (userIdentifier == null) {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      flog(
          "apple userInfo : userId=${credential.userIdentifier}   email=${credential.email}  giveName=${credential.givenName}   familyName=${credential.familyName}");
    } else {
      if (needAppleLogin) {
        credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        flog(
            "apple userInfo : userId=${credential.userIdentifier}   email=${credential.email}  giveName=${credential.givenName}   familyName=${credential.familyName}");
      } else {
        credential = AuthorizationCredentialAppleID(
          userIdentifier: userIdentifier,
          authorizationCode: '',
        );
      }
    }

    if (showLoadings) showLoading();
    LoginModel loginModel =
        await AuthApi.signInApple(credential).catchError((e) {
      dismissLoading();
    });

    StorageManager.setString(
      'userIdentifier',
      credential.userIdentifier.toString(),
    );

    setLocalInfo(loginModel, LoginFlag.ios, done);
  }

  Future<void> googleLogin({
    bool checkLastLoginTime = false,
    bool showLoadings = true,
    Function(LoginModel)? done,
  }) async {
    if (checkLastLoginTime) {
      if (DateTime.now().millisecondsSinceEpoch -
              lastLoginTime.millisecondsSinceEpoch <
          600000) {
        return;
      }
    }
    if (showLoadings) showLoading();

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      GoogleSignInAuthentication? authentication =
          await account?.authentication;

      flog('google sign in $account');
      LoginModel loginModel = await AuthApi.signInGoogle(
        account,
        authentication?.idToken,
      ).catchError((e) {
        dismissLoading();
      });

      setLocalInfo(loginModel, LoginFlag.google, done);
    } catch (e) {
      dismissLoading();
      flog('sign in err $e');
      showErrorWidget(e.toString());
    }
  }

  Future<void> discordLogin({
    bool needAppleLogin = false,
    bool checkLastLoginTime = false,
    bool showLoadings = true,
    Function(LoginModel)? done,
  }) async {
    if (checkLastLoginTime) {
      if (DateTime.now().millisecondsSinceEpoch -
              lastLoginTime.millisecondsSinceEpoch <
          600000) {
        return;
      }
    }
    if (showLoadings) showLoading();

    try {
      UserModel userModel = StorageManager.getUser();
      if (userModel.memberCode.isNotEmpty) {
        if (needAppleLogin) {
          _discordLogin(done);
          return;
        }
        LoginModel loginModel = await AuthApi.signInDiscord2(
          userModel.memberCode,
        ).catchError((e) {
          dismissLoading();
        });

        setLocalInfo(loginModel, LoginFlag.discord, done);
        return;
      }

      _discordLogin(done);
    } catch (e) {
      dismissLoading();
      flog('sign in err $e');
      showErrorWidget(e.toString());
    }
  }

  void _discordLogin(Function(LoginModel)? done) async {
    String clientId = '1043016152168792094';
    String redirectUri = 'https://sidequesthub.com/proxy/web/extra/appToken';
    final url = Uri.https('discord.com', '/api/oauth2/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': 'identify email',
    });

    final result = await FlutterWebAuth.authenticate(
            url: url.toString(), callbackUrlScheme: 'sidequest')
        .onError((error, stackTrace) {
      dismissLoading();
      return '';
    });
    final discordAppId = Uri.parse(result).queryParameters['discordAppId'];

    LoginModel loginModel = await AuthApi.signInDiscord(
      discordAppId,
    ).catchError((e) {
      dismissLoading();
    });

    setLocalInfo(loginModel, LoginFlag.discord, done);
  }

  void setLocalInfo(
    LoginModel loginModel,
    String password,
    Function(LoginModel)? done,
  ) async {
    if (loginModel.token.isEmpty) return;

    if (loginModel.validate == 0) {
      //老用户需要更新资料之后才可以使用
      lastLoginTime = DateTime.now();

      _updateUser(loginModel.user);
      StorageManager.setToken(loginModel.token);
      StorageManager.setAccount(loginModel.user.email);
      StorageManager.setPassword(password);
      StorageManager.setLoginTime(DateTime.now().millisecondsSinceEpoch);
      await updateInfo();
    }
    if (loginModel.user.id != 0) {
      db = DBHelper(loginModel.user.id);
    }
    await imLogin();
    done?.call(loginModel);
  }

  uploadOfflinePushInfoToken() async {
    if (!kIsWeb) {
      ChannelPush.requestPermission();
      Future.delayed(const Duration(seconds: 5), () async {
        final bool isUploadSuccess =
            await ChannelPush.uploadToken(PushConfig.appInfo);
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
        var conversationManager =
            TencentImSDKPlugin.v2TIMManager.getConversationManager();
        V2TimValueCallback<V2TimConversation> conv =
            await conversationManager.getConversation(conversationID: convId);
        if (conv.data != null) {
          Get.to(() => ChatPage(selectedConversation: conv.data!));
        }
      });
    }
  }

  jumpChat(uk) async {
    if (uk == null) {
      return;
    }

    if (Get.isRegistered<ChatController>(tag: "ChatKey")) {
      Get.back();
    } else {
      var conversationManager =
          TencentImSDKPlugin.v2TIMManager.getConversationManager();
      V2TimValueCallback<V2TimConversation> conv = await conversationManager
          .getConversation(conversationID: "c2c_${uk}");
      if (conv.data != null)
        Get.to(() => ChatPage(
              selectedConversation: conv.data!,
            ));
    }
  }

  initOfflinePush() async {
    await ChannelPush.init(handleClickNotification);
    uploadOfflinePushInfoToken();
  }

  imLogin() async {
    flog('imLogin --${imLoginDone.value}');
    if (imLoginDone.value == false) {
      ImSigModel userSig = await ImApi.login();
      if (userSig.token.isEmpty) return;
      // if(userSig == ""){
      //   userSig = "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwoZQweKU7MSCgswUJSsTAxAwN4KIp1YUZBalKlkZmpqaGgHFIaIlmbkgMTMzIDIztzSHmpGZDjIxozIovcIrSjvRvyBG39vA0T-Q2bHMLyOyoCzEPzAxvNDc0MPfMTs7MTLVwlapFgDpNC9g";
      // }
      // print("~~~~~~~~~${userSig.token}~~~~~~~~~~~~~");
      await _coreInstance
          .login(userID: "${userSig.uid}", userSig: userSig.token)
          .then((value) async {
        if (value.code != 0) {
          showToast(value.desc);
        } else {
          imLoginDone.value = true;
        }
        //执行登录 IM 成功后调用。初始化push
        initOfflinePush();
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
          if (msg.customElem?.data != null) {
            var data = msg.customElem!.data!;
            if (data.contains(ChatTool.converFilters.first)) {
              if (unreadMsgCount > 0) {
                unreadMsgCount.value -= 1;
                FlutterAppBadger.updateBadgeCount(unreadMsgCount.value);
              }
            } else {
              FlutterRingtonePlayer.playNotification();
            }
          } else {
            FlutterRingtonePlayer.playNotification();
          }
          _dealMsg(msg);
        }));

        unreadMsgCount.value = await ChatTool.getUnreadMsgCount();

        ///获取未读数量
        // var v2timValueCallback = await TencentImSDKPlugin.v2TIMManager.getConversationManager().getTotalUnreadMessageCount();
        // if (v2timValueCallback.code == 0) {
        //   flog(v2timValueCallback.data, 'getTotalUnreadMessageCount');
        //   unreadMsgCount.value = v2timValueCallback.data!;
        //   FlutterAppBadger.isAppBadgeSupported().then((value) {
        //     if (unreadMsgCount.value == 0) {
        //       FlutterAppBadger.removeBadge();
        //     } else {
        //       flog(value, 'getTotalUnreadMessageCount');
        //       FlutterAppBadger.updateBadgeCount(unreadMsgCount.value, title: 'New Message');
        //     }
        //   });
        // }
      });
    }
  }

  void _dealMsg(V2TimMessage msg) {
    if (msg.customElem == null || msg.customElem?.data == null) {
      return;
    }

    Map<String, dynamic> map = json.decode(msg.customElem!.data!);

    switch (map["type"]) {
      case 'match_order_player':
        MatchOrderPlayer player = MatchOrderPlayer.fromJson(map["message"]);

        int inSeconds = DateTime.now()
            .difference(
                DateTime.fromMillisecondsSinceEpoch(map["timestamp"] * 1000))
            .inSeconds;

        if (inSeconds < 15 * 60) {
          // 15分钟以内的才弹出
          if (Get.isRegistered<DialogMatchTopController>()) {
            // 防止多次弹窗
            dismissLoading();
            DialogMatchTopController ctr = Get.find<DialogMatchTopController>();
            if (ctr.countDownUtil.isShow) {
              ctr.player = player;
              ctr.countDownUtil.updateSeconds(10);
              ctr.update();
            } else {
              SmartDialog.show(
                  builder: (_) =>
                      MatchTopDialog({'seconds': 10, 'player': player}));
            }
          } else {
            SmartDialog.show(
                builder: (_) =>
                    MatchTopDialog({'seconds': 10, 'player': player}));
          }
        }
        break;

      case 'match_order_completed':
        // 陪玩老板点击play后，player从这里跳转进去
        if (userProfile.pwId != map["message"]["uid"]) {
          String str = Get.routing.current;
          if (AppPages.side_kick_match_suc_page == str) {
            Get.back();
          }
          jumpChat(map["message"]["memberCode"]);
        }
        break;

      case 'match_order_boss_cancel':
        // 提示发单人未和接单人玩的
        String str = Get.routing.current;
        if (AppPages.side_kick_match_suc_page != str) {
          showInfoDialog(map['content']);
        }
        break;

      case 'gift_order':
        // 有礼物
        try {
          int inSeconds = DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(
                  map["message"]["createTime"] * 1000))
              .inSeconds;

          if (inSeconds < 15 * 60 && userProfile.uk == map["message"]["uk"]) {
            SmartDialog.show(
                displayTime: Duration(seconds: 2),
                alignment: Alignment.topCenter,
                builder: (builder) => Container(
                      height: 110.h,
                      width: Get.width - 30.w,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(Get.context!).padding.top),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            ImageUtils.matchTopBg,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      padding: EdgeInsets.only(left: 20.w, right: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30.h,
                            margin: EdgeInsets.only(left: 14.w, bottom: 10.h),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'You received a gift'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 50.w,
                                height: 50.w,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    '${map['message']['icon']}',
                                  ),
                                ),
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      map["message"]["game"],
                                      style: TextStyle(
                                        color: Color(0xff333333),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        fontFamily: FONT_MEDIUM,
                                      ),
                                    ),
                                    6.verticalSpace,
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ic_balance_money.webp",
                                          width: 15.w,
                                          height: 15.w,
                                        ),
                                        3.horizontalSpace,
                                        Text(
                                          '${map["message"]["price"]}',
                                          style: TextStyle(
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.sp,
                                            fontFamily: FONT_MEDIUM,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Spacer(),
                                        Text(
                                          'x${map["message"]["num"]}',
                                          style: TextStyle(
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.sp,
                                            fontFamily: FONT_MEDIUM,
                                          ),
                                        ),
                                        6.horizontalSpace,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
          }
        } catch (e) {
          if (userProfile.uk == map["message"]["uk"]) {
            showToast(e.toString());
          }
        }
        break;
    }

    eventBus.fire(MatchEvent(msg: msg));
  }

  void logout({Function? done}) async {
    user.value = UserModel();
    userProfile = ProfileModel();
    imLoginDone.value = false;
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
    showLoading();
    await AuthApi.signOut();
    await _coreInstance.logout();
    await AppConfig.flutterLocalNotificationsPlugin.cancelAll();
    dismissLoading();
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

  toRecordPage(BuildContext context, {int type = 0}) {
    pickVoiceDialog(context, userProfile.voice?.value, (result) {
      flog('callback $result');
      if (result != null) userProfile.voice?.value = result;
    }, recordType: type);
    // Get.toNamed(AppPages.Record,arguments:userProfile.voice)?.then((result) {
    //   if (result != null) userProfile.voice = result;
    // });
  }
}
