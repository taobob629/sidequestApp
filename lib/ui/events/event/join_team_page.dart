import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/events_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/event_detail_model.dart';
import 'package:wy/model/selector_item.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/common/select_view.dart';
import 'package:wy/ui/events/event/dialog_passcode.dart';
import 'package:wy/ui/events/event/event_page.dart';
import 'package:wy/ui/events/event/team_page.dart';
import 'package:wy/utils/utils.dart';

import '../../common/dialog_confirm.dart';

class JoinTeamPage extends StatelessWidget {

  late final String banner;

  late final bool create;

  late final JoinTeamPageController controller;

  JoinTeamPage({required this.create, required this.banner, required int id, required List<LocationModel> location}){
    controller = Get.put(JoinTeamPageController(id:id, create: create, location: location));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: create ? "Make a team":"Join a team",
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildShadow(),
            _buildContent(context),
            _buildDashLine(),
            _buildHoleShadow(),
            _buildHole()
          ],
        ),
      ),
      floatingActionButton: FloatingButton(
        label: "CONFIRM",
        onTap: ()=> controller.join()
      )
    );
  }

  Widget _buildShadow(){
    return Container(
      margin: const EdgeInsets.only(left: 15,right: 15,top: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.4,0.8],
          colors: [Color(0xff323232),Colors.transparent]
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
      ),
    );
  }

  Widget _buildContent(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(left: 16,right: 16,top: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.4,0.8],
          colors: [Color(0xff28263c),AppColor.background]
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  stops: [0.2,1],
                  colors: [Colors.transparent,Colors.black],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstOut,
              child: Image.network(
                banner,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Offstage(
            offstage: create == false,
            child: InputView(
              label: "TEAM NAME",
              tips: "input your team name",
              maxLength: 20,
              controller: controller.nameController,
            ),
          ),
          Offstage(
            offstage: create == true,
            child: InputView(
              label: "TEAM PASSCODE",
              tips: "input your team passcode",
              maxLength: 20,
              controller: controller.codeController,
            ),
          ),
          InputView(
            label: "PLAYING ROLE",
            tips: "input your playing role",
            maxLength: 20,
            controller: controller.roleController,
          ),
          InputView(
            label: "DISCORD TAG",
            tips: "input your discord tag",
            maxLength: 20,
            controller: controller.tagController,
          ),
          Obx(
              ()=>Offstage(
                offstage: controller.location.length == 0,
                child: SelectView(
                  label: "LOCATION",
                  tips: controller.selectLocation.value.name,
                  value: controller.selectLocation.value.name,
                  onTap: () async {
                    SelectorItem? item = await SelectorDialog.show(context, controller.location,title: "Select Location");
                    if (item != null) {
                      LocationModel store = item as LocationModel;
                      controller.selectLocation.value = store;
                    }
                  },
                ),
              )
          ),
          SizedBox(height: 10,),
          Offstage(
            offstage: true,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("TEAM PASSCODE",style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "DIN"),),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(()=>Text(
                        controller.genPasscode.value,
                        style: TextStyle(color: Colors.white,fontSize: 26)
                      )),
                      GestureDetector(
                        onTap: ()=> controller.copy(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white38),
                            color: Colors.white10
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                          child: Text("Copy",style: TextStyle(color: Colors.white38,fontSize: 12),),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          //PrivacyCheck(controller:controller.controller),
        ],
      ),
    );
  }

  Widget _buildDashLine(){
    return Positioned(
      left: 35,
      right: 35,
      top: 120,
      child: _DashedLine(width: 10, count: 20, color: Color(0xFF0D0C1D),),
    );
  }

  Widget _buildHoleShadow(){
    return Positioned(
      left: 0,
      right: 0,
      top: 105,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipPath(
            clipper: _LeftHalfPath(),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xff323232),
            ),
          ),
          ClipPath(
            clipper: _RightHalfPath(),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xff323232),
            ),
          )
        ],
      )
    );
  }

  Widget _buildHole(){
    return Positioned(
      left: 0,
      right: 0,
      top: 105.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipPath(
            clipper: _LeftHalfPath(),
            child: CircleAvatar(
              radius: 14.5,
              backgroundColor: AppColor.background,
            ),
          ),
          ClipPath(
            clipper: _RightHalfPath(),
            child: CircleAvatar(
              radius: 14.5,
              backgroundColor: AppColor.background,
            ),
          )
        ],
      )
    );
  }
}

class _LeftHalfPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width/2, 0);//x,y坐标
    path.lineTo(size.width/2, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _RightHalfPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width/2, 0);//x,y坐标
    path.lineTo(size.width/2, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _DashedLine extends StatelessWidget {
  final Axis axis;// 方向
  final double width;//宽度
  final double height;//高度
  final int count;// 个数，密度
  final Color color;
  _DashedLine({
    this.axis = Axis.horizontal,
    this.width = 1,
    this.height = 1,
    this.count = 10,
    this.color = Colors.black
  });
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
      children: List.generate(count, (_){
        return SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(width)),
          ),
        );
      }),
    );
  }
}

class JoinTeamPageController extends GetxController {
  late PrivacyCheckController controller;

  late TextEditingController nameController;
  late TextEditingController codeController;
  late TextEditingController roleController;
  late TextEditingController tagController;

  bool create;
  int id;
  RxList<LocationModel> location = RxList([]);

  var selectLocation = LocationModel().obs;

  var genPasscode = "".obs;

  JoinTeamPageController({required this.id, required this.create, required List<LocationModel> location}){
    this.location.addAll(location);
    if(create) {
      selectLocation.value = location[0];
    }
  }

  final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void onInit(){
    super.onInit();
    controller = PrivacyCheckController();
    nameController = TextEditingController();
    codeController = TextEditingController();
    roleController = TextEditingController();
    tagController = TextEditingController();
  }

  @override
  void onClose(){
    controller.dispose();
    nameController.dispose();
    codeController.dispose();
    roleController.dispose();
    tagController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    if (create) {
      genPasscode.value = getRandomString(4);
    }
  }
    
  void copy(){
      Clipboard.setData(ClipboardData(text: genPasscode.value));
      EasyLoading.showToast("The team passcode copied, you can send it to your team members.");
  }

  void join() async{
    String name = nameController.text;
    String code = codeController.text;

    if(create) {
      if (name.isEmpty) {
        EasyLoading.showToast("Please input your team name");
        return;
      }
    }else{
      if (code.length != 4) {
        EasyLoading.showToast("Please input correct team passcode");
        return;
      }
    }

    String role = roleController.text;
    if(role.isEmpty){
      EasyLoading.showToast("Please input your playing role");
      return;
    }

    String tag = tagController.text;
    if(tag.isEmpty){
      EasyLoading.showToast("Please input your discord tag");
      return;
    }
    EasyLoading.show();
    if(create) {
      int code = await EventsApi.createTeam(id, name, genPasscode.value, role, tag, selectLocation.value.id);
      EasyLoading.dismiss();
      Get.dialog(PasscodeDialog(passcode: code),barrierColor: Colors.black26).whenComplete(() => Get.off(()=>TeamPage(eventId: id)));
    }else{
      await EventsApi.joinTeam(id, code, role, tag);
      EasyLoading.dismiss();
      Get.dialog(
          ConfirmDialog(
              title: "Tips", info: "You have successfully signed up!",onConfirm: (){
                Get.back();
                Get.back();
                Get.find<EventPageController>().refresh();
          },),
          barrierColor: Colors.black26);
      //Get.back();
    }

  }
  
}