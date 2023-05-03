import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/model/selector_item.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/code_widget.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

import '../../utils/toast_utils.dart';

// 认证页面
class AccompanyCertificationPage extends StatefulWidget {
  @override
  _AccompanyCertificationPageState createState() => _AccompanyCertificationPageState();
}

class _AccompanyCertificationPageState extends State<AccompanyCertificationPage> {
  TextEditingController phoneCon = TextEditingController();
  TextEditingController codeCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController idNumberCon = TextEditingController();
  TextEditingController beGoodAtCon = TextEditingController();
  var platform;
  var platformIndex;
  var game;
  var gameIndex;
  var gameLv;
  var gameLvIndex;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.skill();
  }

  ///游戏
  var skillDm = DataModel();
  Future<int> skill({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/skill').then((res) async {
      skillDm.addList(res.data, true, 0);
    }).catchError((e) {
      skillDm.toError(e.toString());
    });
    flog(skillDm.toJson(), 'skillDm');
    setState(() {});
    return skillDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Accompany Certification'.tr, style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: PWidget.column([
        PWidget.container(
          PWidget.row([
            PWidget.image('assets/images/hall_ic_notice.png', [24, 24]),
            PWidget.boxw(8),
            Expanded(
              child: TextScroll(
                'The following items are required. To ensure your interests, please fill them out truthfully'.tr,
                style: TextStyle(color: Color(0xff4488FF)),
              ),
            ),
          ]),
          [null, null, Color(0xffDEEAFF).withOpacity(0.1)],
          {'pd': 8},
        ),
        Expanded(
          child: MyListView(
            isShuaxin: false,
            flag: false,
            item: (i) => item[i],
            itemCount: item.length,
            padding: EdgeInsets.all(16),
            divider: Divider(height: 16, color: Colors.transparent),
          ),
        ),
      ]),
      btnBar: FloatingButton(
        label: "Reserve".tr,
        onTap: () {
          if (nameCon.text.isEmpty) return showToast('Please enter realName'.tr);
          if (idNumberCon.text.isEmpty) return showToast('Please enter idNumber'.tr);
          if (phoneCon.text.isEmpty) return showToast('Please enter phoneCon'.tr);
          if (codeCon.text.isEmpty) return showToast('Please enter verification code'.tr);
          if (front == null) return showToast('Please upload ID card front photo'.tr);
          if (back == null) return showToast('Please upload ID card back photo'.tr);

          if (platform == null) return showToast('Please select category'.tr);
          if (game == null) return showToast('Please add service type'.tr);
          // if (gameLv == null) return SmartDialog.showToast('Please select gameLv');
          if (beGoodAtCon.text.isEmpty) return showToast('Please enter be Good At'.tr);
        },
      ),
    );
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 48, Color(0xff282640)], {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }

  List<Widget> get item {
    return [
      basicInformationView(),
      gameMaterialsView(),
      iDPhotoView(),
    ];
  }

  Future<String> selectAvatar(BuildContext context) async {
    var status = await PermissionHelper.requestPhotosPermission(context);
    if (status == false) {
      return '';
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      String url = '';
      await Get.to<File?>(() => CropPage(image: _image))!.then((value) async {
        // flog(value!.path);
        url = await UserApi.uploadAvatar(value!, (p0, p1) => flog("$p0,$p1"));
        // controller.setAvatar(value);
      });
      return url;
    } else {
      print('No image selected.');
      return '';
    }
  }

  ///技能录入
  Widget gameMaterialsView() {
    return PWidget.column([
      PWidget.text('Service'.tr, [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Category'.tr, [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(platform == null ? 'Please select'.tr : platform['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          if (skillDm.list.isEmpty) return showToast('Please check the network settings'.tr);
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(skillDm.list.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': skillDm.list[i]['name']});
              }),
              title: "Category".tr,
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              platformIndex = int.parse(res.name);
              platform = skillDm.list[platformIndex];
              gameIndex = null;
              game = null;
              gameLvIndex = null;
              gameLv = null;
            });
          }
        },
      ),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Service'.tr, [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(game == null ? 'Please select'.tr : game['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          if (platformIndex == null) return showToast('Please select category first'.tr);
          var list = skillDm.list[platformIndex]['skill'] as List;
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(list.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': list[i]['name']});
              }),
              title: "Select service".tr,
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              gameIndex = int.parse(res.name);
              game = list[gameIndex];
              gameLvIndex = null;
              gameLv = null;
            });
          }
        },
      ),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Service Level'.tr, [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(gameLv == null ? 'Please select'.tr : gameLv['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          if (platformIndex == null) return showToast('Please select category first'.tr);
          var list = skillDm.list[platformIndex]['skill'] as List;
          if (gameIndex == null) return showToast('Please select service first'.tr);
          var levels = list[gameIndex]['level'] as List;
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(levels.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': levels[i]['name']});
              }),
              title: "Select level".tr,
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              gameLvIndex = int.parse(res.name);
              gameLv = levels[gameLvIndex];
            });
          }
        },
      ),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        PWidget.text('Be good at'.tr, [Colors.white]),
        PWidget.boxw(8),
        buildTFView(context!, hintText: 'Be good at'.tr, hintColor: Colors.white24, textColor: Colors.white, con: beGoodAtCon, isExp: true),
      ])),
    ]);
  }

  ///身份证正反面
  var front, back;

  ///身份证录入
  iDPhotoView() {
    flog(back, 'back');
    return PWidget.column([
      PWidget.text('ID Photo'.tr, [Colors.white, 20], {'ff': 'DIN'}),
      PWidget.boxh(16),
      PWidget.row([
        if (front != null) previewImage(front, () => setState(() => front = null)) else addImageBefore('front'),
        PWidget.boxw(16),
        if (back != null) previewImage(back, () => setState(() => back = null)) else addImageBefore('back'),
      ]),
    ]);
  }

  ///待添加
  Widget addImageBefore(text) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          var url = await this.selectAvatar(context!);
          if (url != '') {
            if (text == 'back') {
              setState(() => back = url);
            } else {
              setState(() => front = url);
            }
          }
        },
        child: PWidget.container(
          PWidget.ccolumn([
            PWidget.spacer(),
            PWidget.image('assets/images/paly_add.png', [32, 32]),
            PWidget.spacer(),
            PWidget.text('${'Upload ID photo'.tr} $text', [Colors.white, 12]),
            PWidget.spacer(),
          ]),
          [null, 112, Color(0xff282640)],
          {'br': 16, 'pd': 16},
        ),
      ),
    );
  }

  ///预览图像
  Widget previewImage(url, Function fun) {
    return PWidget.container(
      Stack(children: [
        Positioned.fill(child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black54)),
        PWidget.positioned(
          PWidget.icon(
            Icons.highlight_remove_rounded,
            [Colors.white],
            {'pd': 8, 'fun': fun},
          ),
          [0, null, null, 0],
        ),
      ]),
      [null, 112],
      {'crr': 16, 'exp': true},
    );
  }

  ///基本信息录入
  basicInformationView() {
    return PWidget.column([
      PWidget.text('Basic information'.tr, [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        PWidget.text('Real name'.tr, [Colors.white]),
        PWidget.boxw(8),
        buildTFView(context!, hintText: 'Real name'.tr, hintColor: Colors.white24, textColor: Colors.white, con: nameCon, isExp: true),
      ])),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        PWidget.text('ID number'.tr, [Colors.white]),
        PWidget.boxw(8),
        buildTFView(context!, hintText: 'ID number'.tr, hintColor: Colors.white24, textColor: Colors.white, con: idNumberCon, isExp: true),
      ])),
      PWidget.boxh(16),
      itemBg(buildTFView(context!, con: phoneCon, hintText: 'your phone number'.tr, hintColor: Colors.white24, textColor: Colors.white)),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        buildTFView(
          context!,
          hintText: 'verification code'.tr,
          hintColor: Colors.white24,
          textColor: Colors.white,
          con: codeCon,
          isExp: true,
        ),
        CodeWidget(
          text: 'Get code'.tr,
          phoneCon: phoneCon,
          successColor: const Color(0xff59C4FA),
          errorColor: const Color(0xff59C4FA),
          callApi: (v, e, s) async {
            // return await Request.post(
            //   '/home/code',
            //   isLoading: true,
            //   data: {"aesText": encryptedFun(getTime()), "phone": v, "type": widget.isRegister ? 2 : 1},
            //   catchError: (v) => e.call(v),
            //   success: (v) => s.call(null),
            // );
          },
          childBuilder: (s, c) {
            return PWidget.text('$s', [c], {'pd': 8});
          },
        ),
      ])),
    ]);
  }
}
