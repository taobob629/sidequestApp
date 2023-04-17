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
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/page_title.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/profile/voice_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/tips_widget.dart';
import 'package:wy/widget/views.dart';

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
    return ScaffoldWidget(
      appBar: AppBar(
        title: Obx(() => PageTitle(
              title: controller.isEdit ? '${controller.game?.name ?? ''}' : 'add service'.tr,
            )),
        centerTitle: true,
        elevation: 0,
        actions: controller.isEdit?[IconButton(onPressed: () => Get.toNamed(AppPages.bio_page), icon: Text('Bio'))]:[],
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
          child: Obx(() => controller.isEdit && controller.serviceModel == null
              ? buildLoad()
              : gameMaterialsView(context)),
        ),
      ]),
      btnBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrivacyCheck(
            controller: controller.privacyCheckController,
            type: TYPE_ADD_BANK,
          ),
          FloatingButton(
            label: '${controller.isEdit ? 'Confirm'.tr : 'Next'.tr}',
            onTap: () => controller.privacyCheckController.check()
                ? controller.isEdit
                    ? controller.updateService()
                    : update()
                : null,
          )
        ],
      ),
    );
  }

  update() async {
    if (controller.isShowVoice && controller.voiceUrl.isEmpty) {
      return EasyLoading.showToast('Please record a voice'.tr);
    }
    if (controller.privacyCheckController.check() == false) return;
    // var fields = buildFiledsParams();
    // flog('fields ${json.encode(fields)}');
    var priceRanges = controller.mPriceRanges;
    // flog('priceRanges ${json.encode(priceRanges)}');
    //   return;
    if (isUploadFile) return EasyLoading.showToast('Uploading failed, please try again later'.tr);
    //  if (isSending) return EasyLoading.showToast('Submitting');
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
                  )),
                if (!controller.isEdit) 10.verticalSpace,
                // if (controller.isEdit!)
                if (!controller.isEdit)
                  itemBg(
                    PWidget.row([
                      PWidget.text('Service'.tr, [textColor]),
                      PWidget.boxw(8),
                      PWidget.text(
                          controller.game == null ? 'Please select'.tr : controller.game?.name,
                          [textColor, 12.sp],
                          {'ali': 1, 'exp': true}),
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
                        controller.getPriceRange();
                      }
                    },
                  ),
                Builder(builder: (context) {
                  if (controller.platformIndex == null) return PWidget.boxh(0);
                  var list = controller.services[controller.platformIndex].skill;
                  if (controller.gameIndex == null) return PWidget.boxh(0);
                  var levels = list[controller.gameIndex].level;
                  if (levels.isEmpty) return PWidget.boxh(0);
                  return PWidget.boxh(14.h);
                }),
                Builder(builder: (context) {
                  if (controller.platformIndex == null) return PWidget.boxh(0);
                  var list = controller.services[controller.platformIndex].skill;
                  if (controller.gameIndex == null) return PWidget.boxh(0);
                  var levels = list[controller.gameIndex].level;
                  if (levels.isEmpty) return PWidget.boxh(0);
                  return itemBg(
                    PWidget.row([
                      PWidget.text('Rank'.tr, [textColor]),
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
                          title: "Select Rank".tr,
                          showInfo: true,
                        ),
                        barrierColor: Colors.black26,
                      );
                      if (res != null) {
                        setState(() {
                          controller.gameLvIndex = int.parse(res.name);
                          controller.gameLv = levels[controller.gameLvIndex];
                          if (!controller.isEdit) controller.getPriceRange();
                        });
                      }
                    },
                  );
                }),
                if (controller.priceRanges.isNotEmpty) 16.verticalSpace,
                if (controller.priceRanges.isNotEmpty) fieldsRange(context),
                if (controller.priceRanges.isNotEmpty) 16.verticalSpace,
                //if (controller.priceRanges.isNotEmpty) PriceSliderWidget(),
                // if (controller.priceRanges.isNotEmpty && controller.isEdit) 16.verticalSpace,
                // if (controller.priceRanges.isNotEmpty && controller.isEdit)
                //   itemBg(PWidget.row([
                //     PWidget.text('Enable'.tr, [textColor]),
                //     PWidget.spacer(),
                //     Builder(builder: (context) {
                //       return CupertinoSwitch(
                //         value: controller.isWswitch == 1,
                //         onChanged: (v) async {
                //           setState(
                //               () => controller.isWswitch = (controller.isWswitch == 1 ? 0 : 1));
                //         },
                //       );
                //     }),
                //   ])),
                // Obx(() => Visibility(visible: controller.showVoice(), child: 16.verticalSpace)),
                // Obx(() => Visibility(
                //     visible: controller.isShowVoice,
                //     child: Obx(() => controller.voiceUrl.isEmpty
                //         ? InkWell(
                //             onTap: () => controller.toRecordPage(context),
                //             child: itemBg(Container(
                //               alignment: Alignment.centerLeft,
                //               child: Obx(() => Text(
                //                     '${controller.voiceUrl.isEmpty ? '+ Add Voice' : '${controller.voiceUrl}'}'
                //                         .tr,
                //                     maxLines: 1,
                //                     style: TextStyle(
                //                         color: textColor,
                //                         fontSize: 13.sp,
                //                         overflow: TextOverflow.ellipsis),
                //                   )),
                //             )),
                //           )
                //         : Container(
                //             constraints: BoxConstraints(minHeight: 45.h),
                //             padding: EdgeInsets.only(left: 15, right: 15).w,
                //             decoration: innerDecoration(),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   'Voice',
                //                   style: text_style(),
                //                 ),
                //                 Spacer(),
                //                 VoiceWidget(
                //                   maginBottom: 0,
                //                   pwId: UserController.find.userProfile.pwId,
                //                   voice: controller.voiceUrl,
                //                   play: () => AudioManager.instance.play(controller.voiceUrl),
                //                   toRecordPage: () => UserController.find.toRecordPage(context),
                //                 )
                //               ],
                //             ),
                //           )))),
                16.verticalSpace,
                iDPhotoView()
              ],
            ),
            padding: EdgeInsets.fromLTRB(15, 5, 15, 15).r)
      ],
    );
  }

  TextStyle text_style() => TextStyle(
      color: textColor, fontSize: 14.sp, fontFamily: FONT_LIGHT, overflow: TextOverflow.ellipsis);


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
                      url: controller.gamePhotos[i], fit: BoxFit.cover, border: 10.r),
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
                    EasyLoading.showToast('Uploading failed, please try again later'.tr);
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

Widget outerBg(Widget view, {EdgeInsets? padding}) {
  return Container(
    padding: padding ?? itemPaddingNormal,
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
