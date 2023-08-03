import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/api/common.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/login_model.dart';
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
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/tips_widget.dart';
import 'package:wy/widget/views.dart';

import '../../../image_utils.dart';
import '../../../model/beans/game_role_bean.dart';
import '../../../model/selector_item.dart';
import '../../../model/service_info_model.dart';
import '../../../utils/global_key_constants.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import '../../playwith/balance/my_earnings_page.dart';
import 'controller.dart';
import 'widget/fields_widget.dart';

///添加游戏
class AddGamePage extends StatefulWidget {
  final Map data;

  const AddGamePage(this.data, {Key? key}) : super(key: key);

  @override
  _AddGamePageState createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  AddGamePageController controller = Get.put(AddGamePageController());

  ///是否正在上传文件
  bool isUploadFile = false;

  bool isSending = false;

  @override
  void initState() {
    super.initState();
    controller.id = widget.data['id'];
    controller.isEdit = widget.data.isNotEmpty;
    controller.initData();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<AddGamePageController>();
  }

  @override
  Widget build(BuildContext context) {
    controller.privacyCheckController = PrivacyCheckController();

    bool? sideKickNextKey = StorageManager.getBoolByKey('sideKickNextKey');
    // if (sideKickNextKey == null || sideKickNextKey == false) {
    //   ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
    //         (_) =>
    //         ShowCaseWidget.of(controller.myContext!).startShowCase([
    //           GlobalKeyConstants.sideKickNextKey,
    //         ]),
    //   );
    // }

    return ShowCaseWidget(
      autoPlay: true,
      autoPlayDelay: Duration(seconds: 5),
      onFinish: () => StorageManager.setBoolValue('sideKickNextKey', true),
      builder: Builder(builder: (builder) {
        controller.myContext = builder;
        return ScaffoldWidget(
          appBar: AppBar(
            title: Obx(() => PageTitle(
                  title: controller.isEdit
                      ? '${controller.game?.name ?? ''}'
                      : 'Add Service'.tr,
                )),
            centerTitle: true,
            elevation: 0,
            actions: controller.isEdit
                ? [
                    IconButton(
                        onPressed: () => controller.toBioPage(),
                        icon: Text('Bio'))
                  ]
                : [],
          ),
          body: Obx(() => SingleChildScrollView(
                child: Column(
                  children: [
                    controller.isEdit && controller.serviceModel == null
                        ? buildLoad()
                        : gameMaterialsView(context),
                  ],
                ),
              )),
          btnBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrivacyCheck(
                controller: controller.privacyCheckController,
                type: TYPE_ADD_BANK,
              ),
              Showcase(
                overlayOpacity: 0,
                key: GlobalKeyConstants.sideKickNextKey,
                description: 'Please fill in and click next'.tr,
                child: FloatingButton(
                  label: '${controller.isEdit ? 'Confirm'.tr : 'Next'.tr}',
                  onTap: () => controller.privacyCheckController.check()
                      ? controller.isEdit
                          ? controller.updateService()
                          : update()
                      : null,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  update() async {
    if (controller.privacyCheckController.check() == false) return;
    // var fields = buildFiledsParams();
    // flog('fields ${json.encode(fields)}');
    // var priceRanges = controller.mPriceRanges;
    // flog('priceRanges ${json.encode(priceRanges)}');
    //   return;
    if (isUploadFile)
      return showToast('Uploading failed, please try again later'.tr);
    //  if (isSending) return SmartDialog.showToast('Submitting');
    if (controller.platform == null)
      return showToast('Please select category'.tr);
    if (controller.game == null) return showToast('Please select service'.tr);
    if (controller.platformIndex == null)
      return showToast('Please select category'.tr);
    var list = controller.services[controller.platformIndex].skill;
    if (controller.gameIndex == null)
      return showToast('Please select service'.tr);
    var levels = list[controller.gameIndex].level;
    if (levels.isNotEmpty) {
      if (controller.gameLv.value.name.isEmpty)
        return showToast('Please select rank'.tr);
    }
    var fields = controller.buildFiledsParams();
    if (levels.isNotEmpty) {
      if (controller.gamePhotos.isEmpty)
        return showToast('Please upload screenshot'.tr);
    }

    //var priceRanges = json.encode(controller.mPriceRanges);
    controller.toAddServiceTypePage();
    return;
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 45.h, Color(0xFF2D2E3C)],
        {'br': 10.r, 'pd': PFun.lg(0, 0, 16, 14), 'fun': fun});
  }

  // List<Widget> get item {
  //   return [
  //     gameMaterialsView(),
  //   ];
  // }

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
        showLoading();
        var url = await Common.uploadFile(value!, (p0, p1) => flog("$p0,$p1"));
        dismissLoading();
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
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: 10).h,
      child: Text(
        "$lable",
        style: PageStyle.labelStyle,
      ),
    );
  }

  ///技能录入
  Widget gameMaterialsView(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10).h,
          child: TipsWidegt(
            title: 'Service detail'.tr,
            tips: 'service_detail_tips'.tr,
          ),
        ),
        outerBg(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!controller.isEdit)
                  Visibility(
                    child: itemBg(
                      PWidget.row([
                        PWidget.text('Category'.tr, [textColor]),
                        PWidget.boxw(8),
                        PWidget.text(
                            controller.platform == null
                                ? 'Please select'.tr
                                : controller.platform?.name,
                            [textColor, 12.sp],
                            {'ali': 1, 'exp': true}),
                        rightJtView(14.sp, textColor),
                      ]),
                      fun: () async {
                        if (controller.isEdit) return;
                        flog('${controller.services.isEmpty}');
                        if (controller.services.isEmpty)
                          return showToast(
                              'Please check the network settings'.tr);
                        var res = await Get.dialog(
                          Obx(() => SelectorDialog(
                                items: List.generate(controller.services.length,
                                    (i) {
                                  return VerifyField.fromJson({
                                    'name': '$i',
                                    'label': controller.services[i].name
                                  });
                                }),
                                title: "Select Category".tr,
                                showInfo: true,
                              )),
                          barrierColor: Colors.black26,
                        );
                        if (res != null) {
                          setState(() {
                            controller.platformIndex = int.parse(res.name);
                            controller.platform =
                                controller.services[controller.platformIndex];
                            controller.priceRanges.clear();
                            controller.gameIndex = null;
                            controller.game = null;
                            controller.gameLvIndex = null;
                            controller.gameLv.value = LevelItem(levelid: -1);
                          });
                        }
                      },
                    ),
                  ),
                if (!controller.isEdit) 10.verticalSpace,
                // if (controller.isEdit!)
                if (!controller.isEdit)
                  itemBg(
                    PWidget.row([
                      PWidget.text('Service'.tr, [textColor]),
                      PWidget.boxw(8),
                      PWidget.text(
                          controller.game == null
                              ? 'Please select'.tr
                              : controller.game?.name,
                          [textColor, 12.sp],
                          {'ali': 1, 'exp': true}),
                      rightJtView(14.sp, textColor),
                    ]),
                    fun: () async {
                      if (controller.isEdit) return;
                      if (controller.platformIndex == null)
                        return showToast('Please select category first'.tr);
                      var list =
                          controller.services[controller.platformIndex].skill;
                      if (list.isEmpty) return showToast('No service'.tr);
                      var res = await Get.dialog(
                        SelectorDialog(
                          items: List.generate(list.length, (i) {
                            return VerifyField.fromJson(
                                {'name': '$i', 'label': list[i].name});
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
                          controller.gameLv.value = LevelItem(levelid: -1);
                        });
                        // this.config();
                        controller.getPriceRange();
                      }
                    },
                  ),
                Builder(builder: (context) {
                  if (controller.platformIndex == null) return PWidget.boxh(0);
                  var list =
                      controller.services[controller.platformIndex].skill;
                  if (controller.gameIndex == null) return PWidget.boxh(0);
                  var levels = list[controller.gameIndex].level;
                  if (levels.isEmpty) return PWidget.boxh(0);
                  return PWidget.boxh(14.h);
                }),
                Builder(builder: (context) {
                  if (controller.platformIndex == null) return PWidget.boxh(0);
                  var list =
                      controller.services[controller.platformIndex].skill;
                  if (controller.gameIndex == null) return PWidget.boxh(0);
                  var levels = list[controller.gameIndex].level;
                  if (levels.isEmpty) return PWidget.boxh(0);
                  return itemBg(
                    PWidget.row([
                      PWidget.text('Rank'.tr, [textColor]),
                      PWidget.boxw(8),
                      PWidget.text(
                          controller.gameLv.value.name.isEmpty
                              ? 'Please select'.tr
                              : controller.gameLv.value.name,
                          [textColor, 12.sp],
                          {'ali': 1, 'exp': true}),
                      rightJtView(16, textColor),
                    ]),
                    fun: () async {
                      if (controller.platformIndex == null)
                        return showToast('Please select category first'.tr);
                      var list =
                          controller.services[controller.platformIndex].skill;
                      if (controller.gameIndex == null)
                        return showToast('Please select service first'.tr);
                      var levels = list[controller.gameIndex].level;
                      var res = await Get.dialog(
                        SelectorDialog(
                          items: List.generate(levels.length, (i) {
                            return VerifyField.fromJson(
                                {'name': '$i', 'label': levels[i].name});
                          }),
                          title: "Select Rank".tr,
                          showInfo: true,
                        ),
                        barrierColor: Colors.black26,
                      );
                      if (res != null) {
                        setState(() {
                          controller.gameLvIndex = int.parse(res.name);
                          controller.gameLv.value =
                              levels[controller.gameLvIndex];
                          if (!controller.isEdit) controller.getPriceRange();
                        });
                      }
                    },
                  );
                }),

                Obx(() => Visibility(
                      visible: (controller.gameLv.value.levelid >=
                              (controller.gameConfig?.techLevel ?? 0)) &&
                          (controller.gameConfig?.techLevel ?? 0) > 0,
                      child: 16.verticalSpace,
                    )),
                Obx(() => Visibility(
                      visible: (controller.gameLv.value.levelid >=
                              (controller.gameConfig?.techLevel ?? 0)) &&
                          (controller.gameConfig?.techLevel ?? 0) > 0,
                      child: itemBg(
                        PWidget.row([
                          PWidget.text(
                            'Role'.tr,
                            [textColor],
                          ),
                          GestureDetector(
                            onTapDown: (details) {
                              print(details.globalPosition);
                              Get.dialog(TableTipsDialog(
                                offset: details.globalPosition,
                                tips: 'tips',
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 8.w),
                              width: 12.w,
                              height: 12.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xffb2b9c9),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Image.asset(
                                ImageUtils.icon_help,
                                width: 10.w,
                                height: 10.w,
                              ),
                            ),
                          ),
                          PWidget.boxw(8),
                          PWidget.text(
                              controller.isTech.value == 0
                                  ? 'SideKicker'.tr
                                  : 'SideKick Pro'.tr,
                              [textColor, 12.sp],
                              {'ali': 1, 'exp': true}),
                          rightJtView(16, textColor),
                        ]),
                        fun: () async {
                          if (controller.platformIndex == null)
                            return showToast('Please select category first'.tr);
                          var list = controller
                              .services[controller.platformIndex].skill;
                          if (controller.gameIndex == null)
                            return showToast('Please select service first'.tr);

                          List<SelectorItem> items = [];
                          GameRoleBean bean = GameRoleBean();
                          bean.id = 0;
                          bean.name = 'SideKicker'.tr;
                          bean.desc =
                              'Simple and quick signup, no review required.'.tr;
                          items.add(bean);

                          bean = GameRoleBean();
                          bean.id = 1;
                          bean.name = 'SideKicker Pro'.tr;
                          bean.desc =
                              'Lower fees, higher order acceptance rate, higher order prices. Requires 2-3 working days for approval.'
                                  .tr;
                          items.add(bean);

                          var res = await Get.dialog(
                            SelectorDialog(
                              items: items,
                              title: "Select Role".tr,
                              showInfo: true,
                            ),
                            barrierColor: Colors.black26,
                          );
                          if (res != null) {
                            controller.isTech.value = res.id;
                          }
                        },
                      ),
                    )),

                if (controller.priceRanges.isNotEmpty) 16.verticalSpace,
                if (controller.priceRanges.isNotEmpty) fieldsRange(context),
                if (controller.priceRanges.isNotEmpty) 16.verticalSpace,
                16.verticalSpace,
                iDPhotoView()
              ],
            ),
            padding: EdgeInsets.fromLTRB(15, 5, 15, 15).r)
      ],
    );
  }

  TextStyle text_style() => TextStyle(
      color: textColor,
      fontSize: 14.sp,
      fontFamily: FONT_LIGHT,
      overflow: TextOverflow.ellipsis);

  fieldsRange(BuildContext? context) => FieldsWidget();

  ///游戏图像
  iDPhotoView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
              flog('controller.gamePhotos[i] ${controller.gamePhotos[i]}');
              return Stack(children: [
                Positioned.fill(
                    child: Container(
                  child: ImageUtil.networkImage(
                      url: controller.gamePhotos[i],
                      fit: BoxFit.cover,
                      border: 10.r),
                  margin: EdgeInsets.only(top: 10),
                  decoration: itemDecoration(),
                )),
                Positioned(
                  child: IconButton(
                    icon: ImageUtil.assetImage('ic_delete', width: 30),
                    onPressed: () {
                      controller.gamePhotos.removeAt(i);
                    },
                  ),
                  top: -10,
                  right: -10,
                ),
              ]);
            }
            return GestureDetector(
                onTap: () {
                  if (isUploadFile)
                    showToast('Uploading failed, please try again later'.tr);
                  this.selectAvatar(context!);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 10),
                  height: 105.h,
                  width: 105.h,
                  padding: EdgeInsets.all(30).r,
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
      ],
    );
  }
}

class TableTipsDialog extends StatelessWidget {
  TableTipsDialog({Key? key, required this.offset, required this.tips})
      : super(key: key);
  final Offset offset;
  final String tips;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15,
          left: offset.dx - 10,
          child: ClipPath(
            clipper: Triangle(dir: -1),
            child: Container(
              width: 20.0,
              height: 10.0,
              color: Color(0xff282640),
              child: null,
            ),
          ),
        ),
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15 + 10,
          width: Get.width - offset.dx / 2,
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Color(0xff282640),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF616161),
                  width: 1.w,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Level',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Platform Fee\n(SideKicker)',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Platform Fee\n(SideKicker Pro)',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Orders',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.h,
                    color: Color(0xFF616161),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Lv1',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '20%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '20%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '10',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.h,
                    color: Color(0xFF616161),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Lv2',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '19%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '19%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '50',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.h,
                    color: Color(0xFF616161),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Lv3',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '18%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '18%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '50',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.h,
                    color: Color(0xFF616161),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Lv4',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '17%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '17%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '50',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.h,
                    color: Color(0xFF616161),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Lv5',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '16%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '16%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Color(0xFF616161),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '50',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget outerBg(Widget view, {EdgeInsets? padding}) {
  return Container(
    padding: padding ?? itemPaddingNormal,
    decoration: itemDecoration(color: Color(0xFF262731)),
    child: view,
  );
}

BoxDecoration innerDecoration() =>
    itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r);

Widget innnerBg(Widget view) {
  return Container(
    padding: itemPaddingNormal,
    decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
    child: view,
  );
}
