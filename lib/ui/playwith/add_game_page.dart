import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/another_xlider.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

///添加游戏
class AddGamePage extends StatefulWidget {
  final Map data;
  const AddGamePage(this.data, {Key? key}) : super(key: key);
  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  TextEditingController priceRangeCon = TextEditingController();
  var platform;
  var platformIndex;
  var game;
  var gameIndex;
  var gameLv;
  var gameLvIndex;
  var isWswitch = 0;
  PrivacyCheckController privacyCheckController = new PrivacyCheckController();

  ///是否正在上传文件
  bool isUploadFile = false;

  bool isSending = false;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    isEdit = widget.data.isNotEmpty;
    await this.skill();
    if (isEdit) this.skillInfo();
    mapFlog(widget.data, 'isEdit');
  }

  ///技能详情
  var skillInfoDm = DataModel<Map>(object: {});
  Future<int> skillInfo({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/skill/${widget.data['id']}').then((res) async {
      skillInfoDm.addObject(res.data);
      if (isEdit) {
        isWswitch = skillInfoDm.object?['pwSkillAuth']['wswitch'];
        platformIndex = skillDm.list.indexWhere((w) => w['id'] == skillInfoDm.object?['platfromId']);
        platform = skillDm.list[platformIndex];
        gameIndex = platform['skill'].indexWhere((w) => w['id'] == skillInfoDm.object?['gameId']);
        game = platform['skill'][gameIndex];
        gameLvIndex = (game['level'] ?? []).indexWhere((w) => w['id'] == skillInfoDm.object?['levelId']);
        if (gameLvIndex != -1) gameLv = (game['level'] ?? [])[gameLvIndex];
        priceRangeCon.text = '';
        if (skillInfoDm.object?['pwSkillAuth']['thumb'] != null) gamePhotos = '${skillInfoDm.object?['pwSkillAuth']['thumb']}'.split(',');
        this.config();
      }
    }).catchError((e) {
      skillInfoDm.toError(e.toString());
    });
    setState(() {});
    return skillInfoDm.flag;
  }

  ///游戏
  var skillDm = DataModel();
  Future<int> skill({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/skill?edit=${isEdit ? 1 : 0}').then((res) async {
      skillDm.addList(res.data, true, 0);
    }).catchError((e) {
      skillDm.toError(e.toString());
    });
    setState(() {});
    return skillDm.flag;
  }

  ///游戏价格区间
  var configDm = DataModel<Map>(object: {});
  Future<int> config({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/config?gameId=${game['id']}').then((res) async {
      configDm.addObject(res.data);
      var gameCoinMin = configDm.object?['gameCoinMin'];
      if (isEdit) {
        var coin = skillInfoDm.object?['pwSkillAuth']['coin'];
        priceRangeCon.text = '${coin < gameCoinMin ? gameCoinMin : coin}';
      } else {
        priceRangeCon.text = '${configDm.object?['gameCoinMin']}';
      }
    }).catchError((e) {
      configDm.toError(e.toString());
    });
    setState(() {});
    return configDm.flag;
  }

  ///是否编辑
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text(isEdit ? 'edit service'.tr : 'add service'.tr, style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: PWidget.column([
        if (1 != 1)
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
      btnBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrivacyCheck(
            controller: privacyCheckController,
            type: TYPE_ADD_GAME,
          ),
          FloatingButton(
            label: "OK",
            onTap: () async {
              if (isSending) return EasyLoading.showToast('Submitting');
              if (privacyCheckController.check() == false) return;
              if (platform == null) return EasyLoading.showToast('Please select category'.tr);
              if (game == null) return EasyLoading.showToast('Please select service'.tr);
              if (platformIndex == null) return EasyLoading.showToast('Please select category'.tr);
              var list = skillDm.list[platformIndex]['skill'] as List;
              if (gameIndex == null) return EasyLoading.showToast('Please select service'.tr);
              var levels = list[gameIndex]['level'] as List;
              if (levels.isNotEmpty) {
                if (gameLv == null) return EasyLoading.showToast('Please select service level'.tr);
              }
              // if (beGoodAtCon.text.isEmpty) return EasyLoading.showToast('Please enter beGoodAt');
              if (priceRangeCon.text.isEmpty) return EasyLoading.showToast('Please enter the price'.tr);
              if (double.parse(priceRangeCon.text) < configDm.object?['gameCoinMin']) {
                return EasyLoading.showToast('The price cannot be less than the minimum value'.tr);
              }
              if (double.parse(priceRangeCon.text) > configDm.object?['gameCoinMax']) {
                return EasyLoading.showToast('The price cannot be greater than the maximum value'.tr);
              }
              if (levels.isNotEmpty) {
                if (gamePhotos.isEmpty) return EasyLoading.showToast('Please upload screenshot'.tr);
              }
              flog(gameLv);
              var data = {
                if (isEdit) "id": widget.data['id'],
                "skillid": game['id'],
                "thumb": gamePhotos.join(','),
                "levelid": gameLv == null ? '' : gameLv['id'],
                "wswitch": isWswitch,
                "coinid": 0,
                "coin": priceRangeCon.text,
                // "des": beGoodAtCon.text,
              };
              flog(data, 'data');
              isSending = true;
              await http.post(isEdit ? '/peiwan/app/home/editSkill' : '/peiwan/app/user/setSkillAuth', data: data).then((v) {
                isSending = false;
                EasyLoading.showToast('Submitted successfully'.tr);
                Get.back(result: true);
              }).catchError((e) {
                isSending = false;
                EasyLoading.showToast('Network exception'.tr);
              });
            },
          )
        ],
      ),
    );
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 48, Color(0xff282640)], {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }

  List<Widget> get item {
    return [gameMaterialsView(), iDPhotoView()];
  }

  void selectAvatar(BuildContext context) async {
    var status = await PermissionHelper.requestPhotosPermission(context);
    if (status == false) {
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      Get.to<File?>(() => CropPage(image: _image))!.then((value) async {
        // flog(value!.path, 'selectAvatar');
        isUploadFile = true;
        var url = await Common.uploadFile(value!, (p0, p1) => flog("$p0,$p1"));
        isUploadFile = false;
        // var url = await UserApi.uploadAvatar(value!, (p0, p1) => flog("$p0,$p1"));
        setState(() => gamePhotos.add('$url'));
        // controller.setAvatar(value);
      });
    } else {
      print('No image selected.');
    }
  }

  ///技能录入
  Widget gameMaterialsView() {
    return PWidget.column([
      PWidget.text('Service detail'.tr, [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(
        PWidget.row([
          PWidget.text('Category'.tr, [Colors.white]),
          PWidget.boxw(8),
          PWidget.text(platform == null ? 'Please select'.tr : platform['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
          rightJtView(16, Colors.white54),
        ]),
        fun: () async {
          if (isEdit) return;
          if (skillDm.list.isEmpty) return EasyLoading.showToast('Please check the network settings'.tr);
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(skillDm.list.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': skillDm.list[i]['name']});
              }),
              title: "Select Category".tr,
              showInfo: true,
            ),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              platformIndex = int.parse(res.name);
              platform = skillDm.list[platformIndex];
              configDm.object?.clear();
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
          if (isEdit) return;
          if (platformIndex == null) return EasyLoading.showToast('Please select category first'.tr);
          flog(skillDm.list[platformIndex],'platformIndex');
          var list = skillDm.list[platformIndex]['skill'] as List;
          if (list.isEmpty) return EasyLoading.showToast('No service'.tr);
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(list.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': list[i]['name']});
              }),
              title: "Select Service".tr,
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
            this.config();
          }
        },
      ),
      Builder(builder: (context) {
        if (platformIndex == null) return PWidget.boxh(0);
        var list = skillDm.list[platformIndex]['skill'] as List;
        if (gameIndex == null) return PWidget.boxh(0);
        var levels = list[gameIndex]['level'] as List;
        if (levels.isEmpty) return PWidget.boxh(0);
        return PWidget.boxh(16);
      }),
      Builder(builder: (context) {
        if (platformIndex == null) return PWidget.boxh(0);
        var list = skillDm.list[platformIndex]['skill'] as List;
        if (gameIndex == null) return PWidget.boxh(0);
        var levels = list[gameIndex]['level'] as List;
        if (levels.isEmpty) return PWidget.boxh(0);
        return itemBg(
          PWidget.row([
            PWidget.text('Level'.tr, [Colors.white]),
            PWidget.boxw(8),
            PWidget.text(gameLv == null ? 'Please select'.tr : gameLv['name'], [Color(0xff8291B4), 16], {'ali': 1, 'exp': true}),
            rightJtView(16, Colors.white54),
          ]),
          fun: () async {
            if (platformIndex == null) return EasyLoading.showToast('Please select category first'.tr);
            var list = skillDm.list[platformIndex]['skill'] as List;
            if (gameIndex == null) return EasyLoading.showToast('Please select service first'.tr);
            var levels = list[gameIndex]['level'] as List;
            var res = await Get.dialog(
              SelectorDialog(
                items: List.generate(levels.length, (i) {
                  return VerifyField.fromJson({'name': '$i', 'label': levels[i]['name']});
                }),
                title: "Select Level".tr,
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
        );
      }),
      if (configDm.object?.isNotEmpty ?? false) PWidget.boxh(16),
      if (configDm.object?.isNotEmpty ?? false)
        itemBg(PWidget.row([
          PWidget.text('Price range'.tr, [Colors.white]),
          PriceSlider(
            min: double.parse('${configDm.object?['gameCoinMin'] ?? '0.0'}'),
            max: double.parse('${configDm.object?['gameCoinMax'] ?? '0.0'}'),
            value: int.parse('${priceRangeCon.text}').toDouble(),
            fun: (v) => priceRangeCon.text = '${v.toInt()}',
          ),
          // PWidget.container(
          //   PWidget.column([
          //     PWidget.row([
          //       PWidget.boxw(4),
          //       PWidget.text("${configDm.object?['gameCoinMin']}", [Colors.white54, 12]),
          //       PWidget.spacer(),
          //       PWidget.text("${configDm.object?['gameCoinMax']}", [Colors.white54, 12]),
          //       PWidget.boxw(4),
          //     ]),
          //     PWidget.container(
          //       PWidget.row([
          //         PWidget.boxw(2),
          //         PWidget.container(
          //           PWidget.icon(Icons.remove_rounded, [Colors.white70, 20]),
          //           [24, 24, Colors.white10],
          //           {
          //             'br': 40,
          //             'ali': PFun.lg(0, 0),
          //             'fun': () {
          //               if (int.parse(priceRangeCon.text) <= configDm.object?['gameCoinMin']) return EasyLoading.showToast('The price cannot be less than the minimum value');
          //               return priceRangeCon.text = (int.parse(priceRangeCon.text) - 1).toString();
          //             },
          //           },
          //         ),
          //         buildTFView(context!, isInt: true, isEdit: false, hintText: '${configDm.object?['gameCoinMin']}-${configDm.object?['gameCoinMax']}', hintColor: Colors.white24, textColor: Colors.white, con: priceRangeCon, textAlign: TextAlign.center, isExp: true),
          //         PWidget.container(
          //           PWidget.icon(Icons.add_rounded, [Colors.white70, 20]),
          //           [24, 24, Colors.white10],
          //           {
          //             'br': 40,
          //             'ali': PFun.lg(0, 0),
          //             'fun': () {
          //               if (int.parse(priceRangeCon.text) >= configDm.object?['gameCoinMax']) return EasyLoading.showToast('The price cannot be greater than the maximum value');
          //               return priceRangeCon.text = (int.parse(priceRangeCon.text) + 1).toString();
          //             },
          //           },
          //         ),
          //       ]),
          //       [null, null, Colors.white.withOpacity(0.05)],
          //       {'pd': 4, 'br': 56},
          //     ),
          //   ]),
          //   [100],
          // ),
        ])),
      if ((skillInfoDm.object?.isNotEmpty ?? false) && isEdit) PWidget.boxh(16),
      if ((skillInfoDm.object?.isNotEmpty ?? false) && isEdit)
        itemBg(PWidget.row([
          PWidget.text('Enable'.tr, [Colors.white]),
          PWidget.spacer(),
          Builder(builder: (context) {
            return CupertinoSwitch(
              value: isWswitch == 1,
              onChanged: (v) async {
                setState(() => isWswitch = (isWswitch == 1 ? 0 : 1));
                // var jsonData = {"skillid": skillInfoDm.object?['pwSkillAuth']['skillid'], "wswitch": wswitch};
                // await http.post('/peiwan/app/user/setSwitch', data: jsonData).then((v) {}).catchError((e) {
                //   setState(() => skillInfoDm.object?['pwSkillAuth']['wswitch'] = (wswitch == 1 ? 0 : 1));
                //   EasyLoading.showToast('Network exception');
                // }).then((v) {
                //   EasyLoading.showToast('Operation succeeded');
                // });
              },
            );
          }),
        ])),
    ]);
  }

  var gamePhotos = [];

  ///游戏图像
  iDPhotoView() {
    return PWidget.column([
      PWidget.text('${'Screenshot'.tr}(${20 - gamePhotos.length})', [Colors.white, 20], {'ff': 'DIN'}),
      GridView.builder(
        padding: EdgeInsets.only(top: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
        ),
        itemCount: (gamePhotos.length == 20) ? gamePhotos.length : gamePhotos.length + 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          if (gamePhotos.length > i) {
            return PWidget.container(
              Stack(children: [
                Positioned.fill(child: CachedNetworkImage(imageUrl: gamePhotos[i], fit: BoxFit.cover)),
                Positioned.fill(child: Container(color: Colors.black54)),
                PWidget.positioned(
                  PWidget.icon(
                    Icons.highlight_remove_rounded,
                    [Colors.white],
                    {'pd': 8, 'fun': () => setState(() => gamePhotos.removeAt(i))},
                  ),
                  [0, null, null, 0],
                ),
              ]),
              {'crr': 16},
            );
          }
          return PWidget.container(
            PWidget.image('assets/images/paly_add.png', [32, 32]),
            [null, null, Color(0xff282640)],
            {
              'crr': 16,
              'pd': 16,
              'ali': PFun.lg(0, 0),
              'fun': () {
                if (isUploadFile) return EasyLoading.showToast('Uploading failed, please try again later'.tr);
                this.selectAvatar(context!);
              }
            },
          );
        },
      ),
    ]);
  }
}

// 价格滑块
class PriceSlider extends StatefulWidget {
  final double? max;
  final double? min;
  final double? value;
  final Function(double)? fun;

  const PriceSlider({Key? key, this.max, this.min, this.fun, this.value}) : super(key: key);
  @override
  _PriceSliderState createState() => _PriceSliderState();
}

class _PriceSliderState extends State<PriceSlider> {
  var value = 0.0;
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async => value = widget.value!;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlutterSlider(
        values: [value],
        max: widget.max!,
        min: widget.min!,
        handlerWidth: 80,
        trackBar: FlutterSliderTrackBar(
          inactiveTrackBar: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
          activeTrackBar: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        ),
        tooltip: FlutterSliderTooltip(
          positionOffset: FlutterSliderTooltipPositionOffset(top: -16),
          custom: (v) => PWidget.container(
            PWidget.row([
              Image.asset("assets/images/ic_balance_money.webp", width: 16, height: 16),
              PWidget.boxw(4),
              PWidget.text('${double.parse('$v').toInt()}'),
            ]),
            [null, null, Colors.white],
            {'pd': PFun.lg(4, 4, 8, 8), 'br': 56},
          ),
        ),
        handler: FlutterSliderHandler(
          child: PWidget.container(PWidget.text('${value.toInt()}', [Colors.black.withOpacity(0.75)]), [null, null, Colors.white], {'pd': PFun.lg(1, 0, 8, 8), 'br': 56}),
          foregroundDecoration: BoxDecoration(),
          decoration: BoxDecoration(),
        ),
        handlerAnimation: FlutterSliderHandlerAnimation(curve: Curves.elasticOut, reverseCurve: Curves.elasticIn, duration: Duration(milliseconds: 250)),
        onDragging: (i, v1, v2) => setState(() => value = v1),
        onDragCompleted: (i, v1, v2) => widget.fun!(v1),
      ),
    );
  }
}
