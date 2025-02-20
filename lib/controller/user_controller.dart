import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../api/wy_http.dart';
import '../../utils/toast_utils.dart';
import '../api/auth_api.dart';
import '../api/pay_api.dart';
import '../api/profile_api.dart';
import '../config/app_config.dart';
import '../event_bus/beans/user_info_suc_bean.dart';
import '../event_bus/event_bus.dart';
import '../model/db_model.dart';
import '../model/login_model.dart';
import '../model/profile_model.dart';
import '../model/user_info_model.dart';
import '../model/user_model.dart';
import '../service/voice_player.dart';
import '../ui/dialog/dialog_confirm.dart';
import '../ui/pages/login/login_page.dart';
import '../ui/pages/login/other_register/other_register_page.dart';
import '../ui/pages/login/secondary_page.dart';
import '../ui/pages/main_page.dart';
import '../ui/pages/profile/balance/balance_page.dart';
import '../ui/pages/register/register_page.dart';
import '../ui/pages/scan/qr_login_page.dart';
import '../ui/pages/scan/scan_page.dart';
import '../utils/db_helper.dart';
import '../utils/login_flag.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';
import '../widget/voice_widget.dart';

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
    var loginFlag = StorageManager.getString('loginFlag');
    switch (loginFlag?.toLowerCase()) {
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
        await login(
          showLoadings: false,
          checkLastLoginTime: checkLastLoginTime,
        );
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
      eventBus.fire(UserInfoSucBean());
      //判断是否有语音
      if (hasDidVoiceCheck) return;
      //  voiceCheck();
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
          toRecordPage(Get.context!);
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
      showLoading(clickMaskDismiss: false);
    }
    LoginModel loginModel =
        await AuthApi.signIn(email, password).catchError((e) {
      dismissLoading();
    });

    setLocalInfo(
      loginModel,
      done,
      loginFlag: LoginFlag.password,
      password: password,
    );
  }

  Future<void> appleLogin({
    bool needLogin = false,
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
      if (needLogin) {
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

    if (showLoadings) showLoading(clickMaskDismiss: false);
    LoginModel loginModel = await AuthApi.signInApple(
      credential,
      '/peiwan/app/user/appleNewLogin',
    ).catchError((e) {
      dismissLoading();
    });

    StorageManager.setString(
      'userIdentifier',
      credential.userIdentifier.toString(),
    );

    setLocalInfo(
      loginModel,
      done,
      loginFlag: LoginFlag.ios,
      credential: credential,
    );
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
    if (showLoadings) showLoading(clickMaskDismiss: false);

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      GoogleSignInAuthentication? authentication =
          await account?.authentication;

      flog('google sign in $account');
      LoginModel loginModel = await AuthApi.signInGoogle(
        '/peiwan/app/user/googleLogin1',
        account,
        authentication?.idToken,
      ).catchError((e) {
        dismissLoading();
      });

      setLocalInfo(
        loginModel,
        done,
        loginFlag: LoginFlag.google,
        account: account,
        idToken: authentication?.idToken,
      );
    } catch (e) {
      dismissLoading();
      flog('sign in err $e');
    }
  }

  Future<void> discordLogin({
    bool needLogin = false,
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
    if (showLoadings) showLoading(clickMaskDismiss: false);

    try {
      String? saveDiscordAppId = StorageManager.getString('discordAppId');
      String? saveEmail = StorageManager.getString('email');
      String? nickName;
      String? discriminator;
      if (saveDiscordAppId == null) {
        final result = await _discordLogin();
        saveDiscordAppId = Uri.parse(result).queryParameters['discordAppId'];
        saveEmail = Uri.parse(result).queryParameters['email'];
        nickName = Uri.parse(result).queryParameters['nickName'];
        discriminator = Uri.parse(result).queryParameters['discriminator'];
      } else {
        if (needLogin) {
          final result = await _discordLogin();
          saveDiscordAppId = Uri.parse(result).queryParameters['discordAppId'];
          saveEmail = Uri.parse(result).queryParameters['email'];
          nickName = Uri.parse(result).queryParameters['nickName'];
          discriminator = Uri.parse(result).queryParameters['discriminator'];
        }
      }

      LoginModel loginModel = await AuthApi.signInDiscord(
        '/peiwan/app/user/discordLogin1',
        saveDiscordAppId,
        saveEmail,
        nickName,
        discriminator,
      ).catchError((e) {
        dismissLoading();
      });

      StorageManager.setString(
        'discordAppId',
        saveDiscordAppId!,
      );
      StorageManager.setString(
        'email',
        saveEmail!,
      );

      setLocalInfo(
        loginModel,
        done,
        loginFlag: LoginFlag.discord,
        discordAppId: saveDiscordAppId,
        email: saveEmail,
        nickName: nickName,
        discriminator: discriminator,
      );
    } catch (e) {
      dismissLoading();
      flog('sign in err $e');
      showError(e.toString());
    }
  }

  Future<String> _discordLogin() async {
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

    return result;
  }

  void setLocalInfo(
    LoginModel loginModel,
    Function(LoginModel)? done, {
    String? password,
    String? loginFlag,
    AuthorizationCredentialAppleID? credential,
    GoogleSignInAccount? account,
    String? idToken,
    String? discordAppId,
    String? email,
    String? nickName,
    String? discriminator,
  }) async {
    if (loginModel.gotoLogin2) {
      StorageManager.setToken(loginModel.token);
      dismissLoading();
      if (loginFlag == LoginFlag.ios) {
        if (loginModel.validate == 0) {
          Get.offAll(() => MainPage());
        } else {
          if (loginModel.secondary == 1) {
            Get.off(() => SecondaryPage(
                  loginModel: loginModel,
                ));
          } else {
            Get.to(() => RegisterPage(),
                arguments: {}
                  ..['type'] = 1
                  ..['loginModel'] = loginModel);
          }
        }
      } else if (loginFlag == LoginFlag.google) {
        if (account != null && idToken != null) {
          Get.to(() => OtherRegisterPage(), arguments: {
            'account': account,
            'idToken': idToken,
          });
        }
      } else if (loginFlag == LoginFlag.discord) {
        if (discordAppId != null &&
            email != null &&
            nickName != null &&
            discriminator != null) {
          Get.to(() => OtherRegisterPage(), arguments: {
            'discordAppId': discordAppId,
            'email': email,
            'nickName': nickName,
            'discriminator': discriminator,
          });
        }
      }
      return;
    }

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
      await updateInfo();
    }
    if (loginModel.user.id != 0) {
      db = DBHelper(loginModel.user.id);
    }
    done?.call(loginModel);
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
    await AppConfig.flutterLocalNotificationsPlugin.cancelAll();
    dismissLoading();
    logout(done: () => Get.offAll(() => LoginPage()));
  }

  String gradeImg() {
    int isauth = userProfile.isAuth;
    int level = userProfile.sidekickLevel;
    if (level == 0) {
      if (isauth == TYPE_VIP) {
        return 'assets/images/${isauth == TYPE_VIP ? 'v_' : ''}grade1.webp';
      }
    }
    return 'assets/images/${isauth == TYPE_VIP ? 'v_' : ''}grade$level.webp';
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

  void scan() {
    Get.to(() => ScanPage())?.then((value) async {
      flog('value $value');
      if (value == null) {
        return;
      }
      String data = value.toString();
      //String deData = decryptData(data);
      if (data.indexOf("qlogin") >= 0) {
        Get.to(() => QrLoginPage(
              code: data,
            ));
        return;
      }
      if (data == "Eb13IPoTrQ2uJNr/sAA70A==") {
        // Eb13IPoTrQ2uJNr/sAA70A==  page:balance
        Get.to(() => BalancePage());
        return;
      }
    });
  }
}
