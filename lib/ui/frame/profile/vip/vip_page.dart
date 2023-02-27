import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/frame/profile/profile_page.dart';
import 'package:wy/ui/profile/vip/vip_info_dialog.dart';
import 'package:wy/widget/custom_scroll_physics.dart';
import 'package:wy/widget/my_bouncing_scroll_physics.dart';

import '../../../../utils/navigator_helper.dart';
import '../../../controller/user_controller.dart';
import '../../../profile/vip/subscribe_dialog.dart';
import '../model/vip_info_model.dart';
import 'vip_benefit_item.dart';

class VipPage extends StatelessWidget {
  late final VipPageController controller = Get.put(VipPageController());
  final userController = UserController.find;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: true,
            // backgroundColor: AppColor.background,
            expandedHeight: Get.width - 100,
            title: Obx(() {
              return Text(
                "VIP",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: controller.titleColor.value, fontSize: 16),
              );
            }),
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  color: Colors.transparent,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Image.asset(
                          "assets/images/profile/vip_header_bg.webp",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 150,
                        child: Obx(() {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.black,
                            child: Text(
                              controller.vipInfoList.isNotEmpty ? "${controller.vipInfoList[controller.vipIndex.value].name}" : "",
                              style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: "DIN"),
                            ),
                          );
                        }),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: Get.statusBarHeight,
                        child: Obx(() {
                          return Swiper(
                            controller: controller.swiperController,
                            autoplay: false,
                            loop: false,
                            physics: PagePhysics(parent: MyBouncingScrollPhysics()),
                            index: controller.vipIndex.value,
                            itemBuilder: (BuildContext context, int index) {
                              final vipModel = controller.vipInfoList[controller.vipIndex.value];
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                                alignment: Alignment.center,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(child: Image.asset("assets/images/profile/vip_bg_${vipModel.name.toLowerCase()}.webp")),
                                    Positioned(
                                        top: -10,
                                        right: 10,
                                        child: Image.asset(
                                          "assets/images/profile/huizhang_${vipModel.name.toLowerCase()}.webp",
                                          height: 93,
                                        )),
                                    Positioned(
                                        left: 15,
                                        top: 20,
                                        child: Text(
                                          "Pre Month",
                                          style: TextStyle(color: Color(0xFF40280E), fontSize: 16),
                                        )),
                                    Positioned(
                                        left: 15,
                                        top: 40,
                                        child: Text(
                                          vipModel.name.toCapitalize,
                                          style: TextStyle(color: Color(0xFF40280E), fontSize: 22, fontWeight: FontWeight.bold),
                                        )),
                                    Positioned(
                                        bottom: 14,
                                        left: 15,
                                        child: Obx(() => Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => controller.openMonth(),
                                                  child: Container(
                                                      height: 32,
                                                      width: 124,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: userController.userProfile.value.vipLevel >= controller.vipInfoList[controller.vipIndex.value].level
                                                              ? Color(0xff707070)
                                                              : Color(0xFFEDA82D),
                                                          borderRadius: BorderRadius.circular(20)),
                                                      child: Text(
                                                        userController.userProfile.value.vipLevel >= controller.vipInfoList[controller.vipIndex.value].level
                                                            ? "Subscribed".tr
                                                            : "£ ${vipModel.monthFee.toString()} PM",
                                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                      )),
                                                ),
                                              ],
                                            ))),
                                    Positioned(
                                        right: 12,
                                        bottom: 20,
                                        child: Visibility(
                                          visible: userController.userProfile.value.vipLevel == controller.vipInfoList[controller.vipIndex.value].level,
                                          child: Container(
                                            child: Text(
                                              "Next Renewal: ".tr + controller.vipInfoList[controller.vipIndex.value].renewDateStr,
                                              style: TextStyle(color: Color(0xFF40280E), fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            },
                            itemCount: controller.vipInfoList.length,
                            onIndexChanged: (index) => controller.levelChange(index),
                            onTap: (index) {
                              controller.swiperController.move(index);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                )),
          ),
          // SliverToBoxAdapter(
          //   child: _buildTitle(),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Benefits",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Obx(() => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return VipBenefitItem(
                      model: controller.vipInfoList[controller.vipIndex.value].intro[index],
                      index: index,
                      showIndex: controller.showPrivilegeIndex.value,
                      title: controller.vipInfoList[controller.vipIndex.value].intro[index].title,
                      subTitle: controller.vipInfoList[controller.vipIndex.value].intro[index].intro,
                      content: controller.vipInfoList[controller.vipIndex.value].intro[index].intro,
                      onTap: (tapIndex) => controller.showPrivilegeIndex.value = tapIndex,
                    );
                  },
                  childCount: controller.vipInfoList.isNotEmpty ? controller.vipInfoList[controller.vipIndex.value].intro.length : 0,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMonthBtn() {
    Gradient gradient = LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFFFC3C02), Color(0xFF841FC3)]);
    Shader shader = gradient.createShader(Rect.fromLTWH(10, 0, 130, 46));
    return GestureDetector(
      onTap: () => controller.openMonth(),
      child: Container(
        height: 46,
        width: 140,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Obx(() => Text("£${controller.vipInfoList[controller.vipIndex.value].monthFee} PM", style: TextStyle(foreground: Paint()..shader = shader, fontSize: 20, fontFamily: "DIN"))),
        )),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildWing(true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "VIP Benefits".tr,
              style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 22),
            ),
          ),
          _buildWing(false)
        ],
      ),
    );
  }

  Widget _buildWing(bool left) {
    return Column(
      crossAxisAlignment: left ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          height: 3,
          width: 22,
          decoration: BoxDecoration(color: Color(0xFFEAD66F), borderRadius: BorderRadius.circular(2)),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 3,
          width: 18,
          decoration: BoxDecoration(color: Color(0xFFCBB336), borderRadius: BorderRadius.circular(2)),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 3,
          width: 14,
          decoration: BoxDecoration(color: Color(0xFFD2B23A), borderRadius: BorderRadius.circular(2)),
        )
      ],
    );
  }
}

class _BottomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height);
    var firstControlPoint = Offset(size.width / 2, 0); //曲线开始点
    var firstEndPoint = Offset(size.width, size.height); // 曲线结束点
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, size.height); //第四个点
    path.lineTo(size.width, size.height); // 第五个点
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class VipPageController extends GetxController {
  static VipPageController get find {
    try {
      return Get.find<VipPageController>();
    } catch (e) {
      return Get.put(VipPageController());
    }
  }

  late ScrollController scrollController;

  late SwiperController swiperController;

  var titleColor = Colors.white.obs;

  var headerHeight = 0.0.obs;

  var vipLevel = 5.obs;
  var vipIndex = 0.obs;
  var showPrivilegeIndex = 0.obs;

  RxList<VipInfoModel> vipInfoList = RxList();

  @override
  void onInit() {
    scrollController = ScrollController();
    swiperController = SwiperController();
    getVipDetail();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    swiperController.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
    scrollController.addListener(() {
      if (scrollController.offset >= headerHeight.value - kToolbarHeight) {
        if (titleColor.value == Colors.transparent) {
          changeTitleColor(Colors.white);
        }
      } else {
        if (titleColor.value == Colors.white) {
          changeTitleColor(Colors.transparent);
        }
      }
    });
  }

  getVipDetail() {
    ProfileApi.getVipDetail().then((value) {
      vipInfoList.value = value;
    });
  }

  void initData(int vipLevel, int vipIndex, double headerHeight) async {
    this.vipLevel.value = vipLevel;
    this.vipIndex.value = vipIndex;
    this.headerHeight.value = headerHeight;
  }

  void levelChange(int index) {
    vipLevel.value = vipInfoList[index].level;
    vipIndex.value = index;
  }

  void changeTitleColor(Color titleColor) {
    this.titleColor.value = titleColor;
  }

  void openMonth() {
    VipInfoModel vipInfoModel = vipInfoList[vipIndex.value];
    var userController = Get.find<UserController>();
    if (userController.userInfoModel.value.vipLevel >= vipInfoModel.level) {
      return;
    }

    PayOrderModel model = PayOrderModel();
    model.type = vipInfoModel.level;
    model.phrase = 0;
    model.goodsPrice = "${vipInfoModel.monthFee}";
    model.totalAmount = "${vipInfoModel.monthFee}";
    showConfirm(model);
  }

  void showConfirm(PayOrderModel model) {
    var userController = Get.find<UserController>();
    if (userController.user.value.getAge() < 16) {
      EasyLoading.showInfo("Subscription members must be at least 16 years old.".tr, duration: Duration(seconds: 3));
      return;
    }
    Get.dialog(VipInfoDialog(), barrierColor: Colors.black26).then((value) {
      if (value != null && value == true) {
        NavigatorHelper.gotoPayPage(model, whenComplete: () {
          userController.updateInfo();
          userController.userProfile.refresh();
          getVipDetail();
        });
        Get.dialog(SubscribeDialog(), barrierColor: Colors.black26);
      }
    });
  }
}
