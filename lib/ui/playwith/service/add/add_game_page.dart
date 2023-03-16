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
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/service_info_model.dart';
import 'package:wy/res/index.dart';
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
import 'package:wy/widget/views.dart';

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
  // var platformIndex;
  // var gameIndex;
  // LevelItem? gameLv;
  // var gameLvIndex;
  // var isWswitch = 0;
  PrivacyCheckController privacyCheckController = new PrivacyCheckController();
  AddGamePageController controller = Get.put(AddGamePageController());

  ///是否正在上传文件
  bool isUploadFile = false;

  bool isSending = false;

  @override
  void initState() {
    this.initData();
    controller.id = widget.data['id'];
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
    // if (controller.isEdit) {
    //   skillInfo();
    // }
    //  await this.skill();
  }

  // ///技能详情
  // var skillInfoDm = DataModel<Map>(object: {});
  //
  // Future<int> skillInfo({int page = 1, bool isRef = false}) async {
  //   await http.get('/peiwan/app/service/skill?id=${widget.data['id']}').then((res) async {
  //     skillInfoDm.addObject(res.data);
  //     if (controller.isEdit) {
  //      // isWswitch = skillInfoDm.object?['pwSkillAuth']['wswitch'];
  //       platformIndex =
  //           controller.services.indexWhere((w) => w.id == skillInfoDm.object?['platfromId']);
  //       controller.platform = controller.services[platformIndex];
  //       gameIndex = controller.platform?.skill
  //           ?.indexWhere((item) => item.id == skillInfoDm.object?['gameId']);
  //       controller.game = controller.platform?.skill[gameIndex];
  //       gameLvIndex =
  //           controller.game?.level?.indexWhere((w) => w.id == skillInfoDm.object?['levelId']);
  //       if (gameLvIndex != -1) gameLv = controller.game?.level[gameLvIndex];
  //     //  priceRangeCon.text = '';
  //       if (skillInfoDm.object?['pwSkillAuth']['thumb'] != null)
  //         gamePhotos = '${skillInfoDm.object?['pwSkillAuth']['thumb']}'.split(',');
  //     //  this.config();
  //     }
  //   }).catchError((e) {
  //     skillInfoDm.toError(e.toString());
  //   });
  //   setState(() {});
  //   return skillInfoDm.flag;
  // }

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

  // ///游戏价格区间
  // var configDm = DataModel<Map>(object: {});
  //
  // Future<int> config({int page = 1, bool isRef = false}) async {
  //   await http.get('/peiwan/app/home/config?gameId=${controller.game?.id}').then((res) async {
  //     configDm.addObject(res.data);
  //     var gameCoinMin = configDm.object?['gameCoinMin'];
  //     if (controller.isEdit) {
  //       var coin = skillInfoDm.object?['pwSkillAuth']['coin'];
  //      priceRangeCon.text = '${coin < gameCoinMin ? gameCoinMin : coin}';
  //     } else {
  //       priceRangeCon.text = '${configDm.object?['gameCoinMin']}';
  //     }
  //   }).catchError((e) {
  //     configDm.toError(e.toString());
  //   });
  //   setState(() {});
  //   return configDm.flag;
  // }

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
          child: Obx(() => controller.serviceModel == null
              ? buildLoad()
              : MyListView(
                  isShuaxin: false,
                  flag: false,
                  item: (i) => item[i],
                  itemCount: item.length,
                  padding: EdgeInsets.all(20).w,
                  divider: Divider(height: 15.h, color: Colors.transparent),
                )),
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

  List? buildFiledsParams() {
    if (controller.fieldItems.isEmpty) return [];
    var list = [];
    controller.fieldItems.forEach((item) {
      if (item.mSelects.isNotEmpty) {
        var itemCopy = FieldsItem.fromJson(item.toJson2());
        list.add(itemCopy);
      }
    });
    flog(' fielditems ${list}');
    return list;
  }

  update() async {
    var fields = buildFiledsParams();
   // flog('fields ${json.encode(fields)}');
    var priceRanges = controller.mPriceRanges;
   // flog('priceRanges ${json.encode(priceRanges)}');
  //   return;
    if (isUploadFile) return EasyLoading.showToast('Uploading failed, please try again later'.tr);
    //  if (isSending) return EasyLoading.showToast('Submitting');
    if (privacyCheckController.check() == false) return;
    if (controller.platform == null) return EasyLoading.showToast('Please select category'.tr);
    if (controller.game == null) return EasyLoading.showToast('Please select service'.tr);
    if (controller.platformIndex == null) return EasyLoading.showToast('Please select category'.tr);
    var list = controller.services[controller.platformIndex].skill;
    if (controller.gameIndex == null) return EasyLoading.showToast('Please select service'.tr);
    var levels = list[controller.gameIndex].level;
    if (levels.isNotEmpty) {
      if (controller.gameLv == null) return EasyLoading.showToast('Please select service level'.tr);
    }
    if (levels.isNotEmpty) {
      if (controller.gamePhotos.isEmpty)
        return EasyLoading.showToast('Please upload screenshot'.tr);
    }
    flog(json.encode(controller.mPriceRanges));
    //var priceRanges = json.encode(controller.mPriceRanges);

    var data = {
      if (controller.isEdit) "id": widget.data['id'],
      "skillid": controller.game?.id,
      "thumb": controller.gamePhotos.join(','),
      "levelid": controller.gameLv == null ? '' : controller.gameLv?.id,
      "wswitch": controller.isWswitch,
      "coinid": 0,
      // "coin": priceRangeCon.text,
      'serviceTypes': priceRanges,
      'fieldItems': fields
      // "des": beGoodAtCon.text,
    };
    flog(data);
    isSending = true;
    await http
        .post('/peiwan/app/service/addService',
            data: data)
        .then((v) {
      isSending = false;
      EasyLoading.showToast('Submitted successfully'.tr);
      Get.back(result: true);
    }).catchError((e) {
      isSending = false;
      EasyLoading.showToast('Network exception'.tr);
    }).whenComplete(() => isSending = false);
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 45.h, Color(0xFF2D2E3C)],
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
        setState(() => controller.gamePhotos.add('$url'));
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
    return controller.serviceModel == null
        ? buildLoad()
        : PWidget.column([
            itemLable('Service detail'.tr),
            itemBg(
              PWidget.row([
                PWidget.text('Category'.tr, [textColor]),
                PWidget.boxw(8),
                PWidget.text(
                    controller.platform == null ? 'Please select'.tr : controller.platform?.name,
                    [textColor, 12.sp],
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
                    controller.platformIndex = int.parse(res.name);
                    controller.platform = controller.services[controller.platformIndex];
                    controller.priceRanges.clear();
                    controller.gameIndex = null;
                    controller.game = null;
                    controller.gameLvIndex = null;
                    controller.gameLv = null;
                  });
                }
              },
            ),
            10.verticalSpace,
            itemBg(
              PWidget.row([
                PWidget.text('Service'.tr, [textColor]),
                PWidget.boxw(8),
                PWidget.text(controller.game == null ? 'Please select'.tr : controller.game?.name,
                    [textColor, 12.sp], {'ali': 1, 'exp': true}),
                rightJtView(14.sp, textColor),
              ]),
              fun: () async {
                if (controller.isEdit) return;
                if (controller.platformIndex == null)
                  return EasyLoading.showToast('Please select category first'.tr);
                var list = controller.services[controller.platformIndex].skill;
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
                    controller.gameIndex = int.parse(res.name);
                    controller.game = list[controller.gameIndex];
                    controller.gameLvIndex = null;
                    controller.gameLv = null;
                  });
                  // this.config();
                  controller.getPriceRange(controller.game?.id);
                }
              },
            ),
            Builder(builder: (context) {
              if (controller.platformIndex == null) return PWidget.boxh(0);
              var list = controller.services[controller.platformIndex].skill;
              if (controller.gameIndex == null) return PWidget.boxh(0);
              var levels = list[controller.gameIndex].level;
              if (levels.isEmpty) return PWidget.boxh(0);
              return PWidget.boxh(14.sp);
            }),
            Builder(builder: (context) {
              if (controller.platformIndex == null) return PWidget.boxh(0);
              var list = controller.services[controller.platformIndex].skill;
              if (controller.gameIndex == null) return PWidget.boxh(0);
              var levels = list[controller.gameIndex].level;
              if (levels.isEmpty) return PWidget.boxh(0);
              return itemBg(
                PWidget.row([
                  PWidget.text('Level'.tr, [textColor]),
                  PWidget.boxw(8),
                  PWidget.text(
                      controller.gameLv == null ? 'Please select'.tr : controller.gameLv?.name,
                      [textColor, 12.sp],
                      {'ali': 1, 'exp': true}),
                  rightJtView(16, textColor),
                ]),
                fun: () async {
                  if (controller.platformIndex == null)
                    return EasyLoading.showToast('Please select category first'.tr);
                  var list = controller.services[controller.platformIndex].skill;
                  if (controller.gameIndex == null)
                    return EasyLoading.showToast('Please select service first'.tr);
                  var levels = list[controller.gameIndex].level;
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
                      controller.gameLvIndex = int.parse(res.name);
                      controller.gameLv = levels[controller.gameLvIndex];
                    });
                  }
                },
              );
            }),
            if (controller.priceRanges.isNotEmpty) 16.verticalSpace,
            if (controller.priceRanges.isNotEmpty) fieldsRange(context),
            if (controller.priceRanges.isNotEmpty) 16.verticalSpace,
            if (controller.priceRanges.isNotEmpty) PriceSliderWidget(),
            if (controller.priceRanges.isNotEmpty && controller.isEdit) 16.verticalSpace,
            if (controller.priceRanges.isNotEmpty && controller.isEdit)
              itemBg(PWidget.row([
                PWidget.text('Enable'.tr, [textColor]),
                PWidget.spacer(),
                Builder(builder: (context) {
                  return CupertinoSwitch(
                    value: controller.isWswitch == 1,
                    onChanged: (v) async {
                      setState(() => controller.isWswitch = (controller.isWswitch == 1 ? 0 : 1));
                    },
                  );
                }),
              ])),
          ]);
  }

  fieldsRange(BuildContext? context) => FieldsWidget();

  ///游戏图像
  iDPhotoView() {
    return PWidget.column([
      itemLable('${'Screenshot'.tr}(${20 - controller.gamePhotos.length})'),
      GridView.builder(
        padding: EdgeInsets.only(top: 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
        ),
        itemCount: (controller.gamePhotos.length == 20)
            ? controller.gamePhotos.length
            : controller.gamePhotos.length + 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          if (controller.gamePhotos.length > i) {
            return PWidget.container(
              Stack(children: [
                Positioned.fill(
                    child:
                        CachedNetworkImage(imageUrl: controller.gamePhotos[i], fit: BoxFit.cover)),
                Positioned.fill(child: Container(color: Color(0xFF2D2E3C))),
                PWidget.positioned(
                  PWidget.icon(
                    Icons.highlight_remove_rounded,
                    [textColor],
                    {'pd': 8, 'fun': () => setState(() => controller.gamePhotos.removeAt(i))},
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
                    color: Color(0xFF2D2E3C),
                    borderRadius: BorderRadius.all(Radius.circular(10).r)),
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

Widget outerBg(Widget view) {
  return Container(
    padding: itemPaddingNormal,
    decoration: itemDecoration(color: Color(0xFF262731)),
    child: view,
  );
}

BoxDecoration innerDecoration() => itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r);

Widget innnerBg(Widget view) {
  return Container(
    padding: itemPaddingNormal,
    decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
    child: view,
  );
}
