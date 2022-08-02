import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/model/vip_info_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/vip/subscribe_dialog.dart';
import 'package:wy/ui/profile/vip/vip_info_dialog.dart';

import '../../../utils/navigator_helper.dart';
import 'privilege_view.dart';

class VipPage extends StatelessWidget {

  final int vipLevel;
  final int vipIndex;
  late final VipPageController controller;

  final userController = Get.find<UserController>();

  VipPage({required this.vipLevel, required this.vipIndex, required List<VipInfoModel> list}){
    controller = Get.put(VipPageController(list));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
      .of(context)
      .size
      .width;
    controller.initData(vipLevel,vipIndex, width);
    return Scaffold(
      backgroundColor: AppColor.background,
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: true,
            backgroundColor: AppColor.background,
            expandedHeight: width - 100,
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
              background: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Obx(() {
                      return Image.asset(
                        "assets/images/bg_vip${controller.vipLevel.value}.webp",
                        fit: BoxFit.cover,
                      );
                    }),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Obx(() {
                      return Swiper(
                        controller: controller.swiperController,
                        autoplay: false,
                        loop: false,
                        viewportFraction: 0.35,
                        scale: 0.01,
                        index: controller.vipIndex.value,
                        itemBuilder: (BuildContext context, int index) {
                          int level = controller.vipInfoList[index].level;
                          String asset = "assets/images/ic_level$level.webp";
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Image.asset(asset, fit: BoxFit.contain,),
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
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipPath(
                      clipper: _BottomPath(),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColor.background,
                        ),
                      ),
                    )
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    height: 108,
                    child: Container(
                      child: Column(
                        children: [
                          Obx(() {
                            return Text(
                              "${controller.vipInfoList[controller.vipIndex.value].name}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontFamily: "DIN"
                              ),
                            );
                          }),
                          SizedBox(height: 3,),
                          Obx((){
                            if(controller.vipInfoList[controller.vipIndex.value].monthFee == 0){
                              return Container(
                                width: 251,
                                height: 66,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white54
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      "Invite Only",
                                      style: TextStyle(color: Colors.black,fontSize: 24,fontFamily: "DIN"),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: ()=>controller.openMonth(),
                              child: Container(
                                width: 251,
                                height: 66,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/vip_btn${controller.vipInfoList[controller.vipIndex.value].level}.png"),
                                    fit: BoxFit.contain
                                  )
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      userController.userInfoModel.value.vipLevel >= controller.vipInfoList[controller.vipIndex.value].level?
                                      "Subscribed"  :
                                      "£ ${controller.vipInfoList[controller.vipIndex.value].monthFee} PM",
                                      style: TextStyle(color: Colors.black,fontSize: 30,fontFamily: "DIN"),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
          SliverToBoxAdapter(
            child: _buildTitle(),
          ),
          Obx(()=>SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                return PrivilegeView(
                  index: index,
                  showIndex: controller.showPrivilegeIndex.value,
                  title: controller.vipInfoList[controller.vipIndex.value].intro[index].title,
                  content: controller.vipInfoList[controller.vipIndex.value].intro[index].intro,
                  onTap: (tapIndex)=>controller.showPrivilegeIndex.value = tapIndex,
                );
              },
              childCount: controller.vipInfoList[controller.vipIndex.value].intro.length,
            ),
          )),
          // Obx(()=>SliverGrid(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       String content = controller.vipInfoList[controller.vipLevel.value - 1].intro[index];
          //       return PrivilegeView(content: content,);
          //     },
          //     childCount: controller.vipInfoList[controller.vipLevel.value - 1].intro.length,
          //   ),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //     mainAxisSpacing: 10,
          //     crossAxisSpacing: 5,
          //     childAspectRatio: 1,
          //   )
          // )),
        ],
      )
    );
  }

  Widget _buildMonthBtn() {
    Gradient gradient = LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight,
      colors: [Color(0xFFFC3C02), Color(0xFF841FC3)]);
    Shader shader = gradient.createShader(Rect.fromLTWH(10, 0, 130, 46));
    return GestureDetector(
      onTap: ()=> controller.openMonth(),
      child: Container(
        height: 46,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Obx(()=>Text(
              "£${controller.vipInfoList[controller.vipIndex.value].monthFee} PM",
              style: TextStyle(
                foreground: Paint()
                  ..shader = shader,
                fontSize: 20,
                fontFamily: "DIN"
              )
            )),
          )
        ),
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
            child: Text("VIP Benefits", style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 22),),
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
          decoration: BoxDecoration(
            color: Color(0xFFEAD66F),
            borderRadius: BorderRadius.circular(2)
          ),
        ),
        SizedBox(height: 3,),
        Container(
          height: 3,
          width: 18,
          decoration: BoxDecoration(
            color: Color(0xFFCBB336),
            borderRadius: BorderRadius.circular(2)
          ),
        ),
        SizedBox(height: 3,),
        Container(
          height: 3,
          width: 14,
          decoration: BoxDecoration(
            color: Color(0xFFD2B23A),
            borderRadius: BorderRadius.circular(2)
          ),
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
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy);
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

  late ScrollController scrollController;

  late SwiperController swiperController;

  var titleColor = Colors.white.obs;

  var headerHeight = 0.0.obs;

  var vipLevel = 1.obs;
  var vipIndex = 0.obs;
  var showPrivilegeIndex = 0.obs;

  RxList<VipInfoModel> vipInfoList = RxList();

  VipPageController(List<VipInfoModel> list){
    vipInfoList.addAll(list);
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    swiperController = SwiperController();
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

  void openMonth(){
    VipInfoModel vipInfoModel = vipInfoList[vipIndex.value];
    var userController = Get.find<UserController>();
    if(userController.userInfoModel.value.vipLevel >= vipInfoModel.level){
      return;
    }

    PayOrderModel model = PayOrderModel();
    model.type = vipInfoModel.level;
    model.phrase = 0;
    model.goodsPrice = "${vipInfoModel.monthFee}";
    model.totalAmount = "${vipInfoModel.monthFee}";
    showConfirm(model);
  }

  void openYear(){
    // VipInfoModel vipInfoModel = vipInfoList[vipLevel.value-1];
    // PayOrderModel model = PayOrderModel();
    // model.type = vipLevel.value;
    // model.phrase = 1;
    // model.goodsPrice = "${vipInfoModel.yearFee}";
    // model.totalAmount = "${vipInfoModel.yearFee}";
    // showConfirm(model);
  }

  void showConfirm(PayOrderModel model){
    var userController = Get.find<UserController>();
    if(userController.user.value.getAge() < 16){
      EasyLoading.showInfo("Subscription members must be at least 16 years old.",duration: Duration(seconds: 3));
      return;
    }
    Get.dialog(VipInfoDialog(),barrierColor: Colors.black26).then((value) {
      if(value != null && value == true){
        NavigatorHelper.gotoPayPage(model);
        //Get.dialog(SubscribeDialog(),barrierColor: Colors.black26);
      }
    });
  }

}