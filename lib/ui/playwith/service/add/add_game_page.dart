import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/model/service_info_model.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/another_xlider.dart';
import 'package:wy/widget/lable.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

import 'controller.dart';
import 'widget/fields_widget.dart';
import 'widget/price_slider.dart';

///添加游戏
class AddGamePage extends StatefulWidget {
  final Map data;

  const AddGamePage(this.data, {Key? key}) : super(key: key);

  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  TextEditingController priceRangeCon = TextEditingController();
  ServiceInfoModel? platform;
  var platformIndex;
  SkillItem? game;
  var gameIndex;
  LevelItem? gameLv;
  var gameLvIndex;
  var isWswitch = 0;
  PrivacyCheckController privacyCheckController = new PrivacyCheckController();
  AddGamePageController controller = Get.put(AddGamePageController());

  ///是否正在上传文件
  bool isUploadFile = false;

  bool isSending = false;

  @override
  void initState() {
    this.initData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<AddGamePageController>();
  }

  ///初始化函数
  Future initData() async {
    controller.isEdit = widget.data.isNotEmpty;
    await controller.initData();
    if (controller.isEdit) {
      skillInfo();
    }
    //  await this.skill();
  }

  ///技能详情
  var skillInfoDm = DataModel<Map>(object: {});

  Future<int> skillInfo({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/skill/${widget.data['id']}').then((res) async {
      skillInfoDm.addObject(res.data);
      if (controller.isEdit) {
        isWswitch = skillInfoDm.object?['pwSkillAuth']['wswitch'];
        platformIndex =
            controller.services.indexWhere((w) => w.id == skillInfoDm.object?['platfromId']);
        platform = controller.services[platformIndex];
        gameIndex = platform?.skill?.indexWhere((item) => item.id == skillInfoDm.object?['gameId']);
        game = platform?.skill[gameIndex];
        gameLvIndex =
            game?.level?.indexWhere((w) => w.id == skillInfoDm.object?['levelId']);
        if (gameLvIndex != -1) gameLv = game?.level[gameLvIndex];
        priceRangeCon.text = '';
        if (skillInfoDm.object?['pwSkillAuth']['thumb'] != null)
          gamePhotos = '${skillInfoDm.object?['pwSkillAuth']['thumb']}'.split(',');
        this.config();
      }
    }).catchError((e) {
      skillInfoDm.toError(e.toString());
    });
    setState(() {});
    return skillInfoDm.flag;
  }

  ///游戏
  // var skillDm = DataModel();

  // Future<int> skill({int page = 1, bool isRef = false}) async {
  //   await http.get('/peiwan/app/home/skill?edit=${controller.isEdit ? 1 : 0}').then((res) async {
  //   //  skillDm.addList(res.data, true, 0);
  //   }).catchError((e) {
  //   //  skillDm.toError(e.toString());
  //   });
  //   setState(() {});
  // //  return skillDm.flag;
  // }

  ///游戏价格区间
  var configDm = DataModel<Map>(object: {});

  Future<int> config({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/config?gameId=${game?.id}').then((res) async {
      configDm.addObject(res.data);
      var gameCoinMin = configDm.object?['gameCoinMin'];
      if (controller.isEdit) {
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

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: PageTitle(
          title: controller.isEdit ? 'edit service'.tr : 'add service'.tr,
        ),
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
                  'The following items are required. To ensure your interests, please fill them out truthfully'
                      .tr,
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
            padding: EdgeInsets.all(20).w,
            divider: Divider(height: 15.h, color: Colors.transparent),
          ),
        ),
      ]),
      btnBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrivacyCheck(
            controller: privacyCheckController,
            type: TYPE_ADD_BANK,
          ),
          FloatingButton(
            label: "OK",
            onTap: () => update(),
          )
        ],
      ),
    );
  }

  update() async {
    if (isUploadFile) return EasyLoading.showToast('Uploading failed, please try again later'.tr);
    if (isSending) return EasyLoading.showToast('Submitting');
    if (privacyCheckController.check() == false) return;
    if (platform == null) return EasyLoading.showToast('Please select category'.tr);
    if (game == null) return EasyLoading.showToast('Please select service'.tr);
    if (platformIndex == null) return EasyLoading.showToast('Please select category'.tr);
    var list = controller.services[platformIndex].skill;
    if (gameIndex == null) return EasyLoading.showToast('Please select service'.tr);
    var levels = list[gameIndex].level;
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
    flog(json.encode(controller.mPriceRanges));
    //var priceRanges = json.encode(controller.mPriceRanges);
    var priceRanges =controller.mPriceRanges;
    var data = {
      if (controller.isEdit) "id": widget.data['id'],
      "skillid": game?.id,
      "thumb": gamePhotos.join(','),
      "levelid": gameLv == null ? '' : gameLv?.id,
      "wswitch": isWswitch,
      "coinid": 0,
      "coin": priceRangeCon.text,
      'serviceTypes': priceRanges
      // "des": beGoodAtCon.text,
    };
    flog(data);
    isSending = true;
    await http
        .post(controller.isEdit ? '/peiwan/app/service/skill' : '/peiwan/app/service/addService',
            data: data)
        .then((v) {
      isSending = false;
      EasyLoading.showToast('Submitted successfully'.tr);
      Get.back(result: true);
    }).catchError((e) {
      isSending = false;
      EasyLoading.showToast('Network exception'.tr);
    }).whenComplete(() => isSending=false);
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 45.h, AppColor.itemBg2],
        {'br': 10.r, 'pd': PFun.lg(0, 0, 16, 14), 'fun': fun});
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
        EasyLoading.show();
        var url = await Common.uploadFile(value!, (p0, p1) => flog("$p0,$p1"));
        EasyLoading.dismiss();
        isUploadFile = false;
        // var url = await UserApi.uploadAvatar(value!, (p0, p1) => flog("$p0,$p1"));
        setState(() => gamePhotos.add('$url'));
        // controller.setAvatar(value);
      });
    } else {
      print('No image selected.');
    }
  }

  var textColor = Color(0xFFB2B9C9);

  Widget itemLable(var lable) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10).h,
      child: Text(
        "$lable",
        style: PageStyle.labelStyle,
      ),
    );
  }

  ///技能录入
  Widget gameMaterialsView() {
    return PWidget.column([
      itemLable('Service detail'.tr),
      itemBg(
        PWidget.row([
          PWidget.text('Category'.tr, [textColor]),
          PWidget.boxw(8),
          PWidget.text(platform == null ? 'Please select'.tr : platform?.name, [textColor, 12.sp],
              {'ali': 1, 'exp': true}),
          rightJtView(14.sp, textColor),
        ]),
        fun: () async {
          if (controller.isEdit) return;
          flog('${controller.services.isEmpty}');
          if (controller.services.isEmpty)
            return EasyLoading.showToast('Please check the network settings'.tr);
          var res = await Get.dialog(
            Obx(() => SelectorDialog(
                  items: List.generate(controller.services.length, (i) {
                    return VerifyField.fromJson(
                        {'name': '$i', 'label': controller.services[i].name});
                  }),
                  title: "Select Category".tr,
                  showInfo: true,
                )),
            barrierColor: Colors.black26,
          );
          if (res != null) {
            setState(() {
              platformIndex = int.parse(res.name);
              platform = controller.services[platformIndex];
              configDm.object?.clear();
              gameIndex = null;
              game = null;
              gameLvIndex = null;
              gameLv = null;
            });
          }
        },
      ),
      10.verticalSpace,
      itemBg(
        PWidget.row([
          PWidget.text('Service'.tr, [textColor]),
          PWidget.boxw(8),
          PWidget.text(game == null ? 'Please select'.tr : game?.name, [textColor, 12.sp],
              {'ali': 1, 'exp': true}),
          rightJtView(14.sp, textColor),
        ]),
        fun: () async {
         if (controller.isEdit) return;
          if (platformIndex == null)
            return EasyLoading.showToast('Please select category first'.tr);
          var list = controller.services[platformIndex].skill;
          if (list.isEmpty) return EasyLoading.showToast('No service'.tr);
          var res = await Get.dialog(
            SelectorDialog(
              items: List.generate(list.length, (i) {
                return VerifyField.fromJson({'name': '$i', 'label': list[i].name});
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
            controller.getPriceRange(game?.id);
          }
        },
      ),
      Builder(builder: (context) {
        if (platformIndex == null) return PWidget.boxh(0);
        var list = controller.services[platformIndex].skill;
        if (gameIndex == null) return PWidget.boxh(0);
        var levels = list[gameIndex].level;
        if (levels.isEmpty) return PWidget.boxh(0);
        return PWidget.boxh(14.sp);
      }),
      Builder(builder: (context) {
        if (platformIndex == null) return PWidget.boxh(0);
        var list = controller.services[platformIndex].skill;
        if (gameIndex == null) return PWidget.boxh(0);
        var levels = list[gameIndex].level;
        if (levels.isEmpty) return PWidget.boxh(0);
        return itemBg(
          PWidget.row([
            PWidget.text('Level'.tr, [textColor]),
            PWidget.boxw(8),
            PWidget.text(gameLv == null ? 'Please select'.tr : gameLv?.name, [textColor, 12.sp],
                {'ali': 1, 'exp': true}),
            rightJtView(16, textColor),
          ]),
          fun: () async {
            if (platformIndex == null)
              return EasyLoading.showToast('Please select category first'.tr);
            var list = controller.services[platformIndex].skill;
            if (gameIndex == null) return EasyLoading.showToast('Please select service first'.tr);
            var levels = list[gameIndex].level;
            var res = await Get.dialog(
              SelectorDialog(
                items: List.generate(levels.length, (i) {
                  return VerifyField.fromJson({'name': '$i', 'label': levels[i].name});
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
      if (configDm.object?.isNotEmpty ?? false)16.verticalSpace,
      if (configDm.object?.isNotEmpty ?? false)fieldsRange(context),
      if (configDm.object?.isNotEmpty ?? false) 16.verticalSpace,
      if (configDm.object?.isNotEmpty ?? false) PriceSliderWidget(),
      if ((skillInfoDm.object?.isNotEmpty ?? false) && controller.isEdit) 16.verticalSpace,
      if ((skillInfoDm.object?.isNotEmpty ?? false) && controller.isEdit)
        itemBg(PWidget.row([
          PWidget.text('Enable'.tr, [textColor]),
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

  fieldsRange(BuildContext? context)=>FieldsWidget();
  priceRange(BuildContext? context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context!,
        child: Obx(() => ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.priceRanges.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    itemLable('Price Range'.tr),
                    InkWell(
                        onTap: () => {},
                        child: Icon(
                          Icons.add,
                          color: Colors.green,
                        ))
                  ]);
                }
                var item = controller.priceRanges[index - 1];
                return PriceSlider(
                  min: item.gameCoinMin.toDouble(),
                  max: item.gameCoinMax.toDouble(),
                  value: item.gameCoinMin.toDouble(),
                  index: index,
                  model: item,
                );
              },
              separatorBuilder: (BuildContext context, int index) => index == 0
                  ? Divider(
                      height: 0,
                    )
                  : Divider(
                      color: Colors.transparent,
                      height: 16.h,
                    ),
            )));
  }

  var gamePhotos = [];

  ///游戏图像
  iDPhotoView() {
    return PWidget.column([
      itemLable('${'Screenshot'.tr}(${20 - gamePhotos.length})'),
      GridView.builder(
        padding: EdgeInsets.only(top: 0),
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
                Positioned.fill(
                    child: CachedNetworkImage(imageUrl: gamePhotos[i], fit: BoxFit.cover)),
                Positioned.fill(child: Container(color: Colors.black54)),
                PWidget.positioned(
                  PWidget.icon(
                    Icons.highlight_remove_rounded,
                    [textColor],
                    {'pd': 8, 'fun': () => setState(() => gamePhotos.removeAt(i))},
                  ),
                  [0, null, null, 0],
                ),
              ]),
              {'crr': 16},
            );
          }
          return GestureDetector(
              onTap: () {
                if (isUploadFile)
                  EasyLoading.showToast('Uploading failed, please try again later'.tr);
                this.selectAvatar(context!);
              },
              child: Container(
                height: 105.h,
                width: 105.h,
                padding: EdgeInsets.all(35).r,
                decoration: BoxDecoration(
                    color: AppColor.itemBg2, borderRadius: BorderRadius.all(Radius.circular(10).r)),
                child: ImageUtil.assetImage(
                  'add_pic',
                  imageType: IMG_PNG,
                  width: 50,
                  height: 50,
                  fit: BoxFit.scaleDown,
                ),
              ));
        },
      ),
    ]);
  }
}
