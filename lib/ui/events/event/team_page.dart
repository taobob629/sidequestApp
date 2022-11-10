import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/events_api.dart';
import 'package:wy/model/match_team_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';

class TeamPage extends StatelessWidget {

  final int eventId;

  late final TeamPageController controller;

  TeamPage({required this.eventId}){
    controller = Get.put(TeamPageController(eventId: eventId));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Team".tr,
        body: Obx(() => Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTeamHeader(),
                          SizedBox(
                            height: 30,
                          ),
                          _buildMembers(),
                          SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                                Text(
                                  "TEAM PASSCODE".tr,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "DIN"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Obx(() => Text(controller.matchTeamModel.value.passCode, style: TextStyle(color: Colors.white, fontSize: 26))),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () => controller.copy(),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white38), color: Colors.white10),
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                                    child: Text(
                                      "Copy".tr,
                                      style: TextStyle(color: Colors.white38, fontSize: 12),
                                    ),
                                  ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ))
    );
  }

  Widget _buildTeamHeader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Offstage(
              offstage: controller.matchTeamModel.value.avatar.isEmpty,
              child: ClipOval(
                child: Image.network(
                  controller.matchTeamModel.value.avatar,
                  fit: BoxFit.cover,
                )
              ),
            )
          )
        ),
        SizedBox(height: 5,),
        Text("${controller.matchTeamModel.value.name}", style: TextStyle(color: Colors.white,fontSize: 14),),
        SizedBox(height: 30,),
        Text(
          "${'Ranking'.tr} : ${controller.matchTeamModel.value.ranking == 0 ? '-' : controller.matchTeamModel.value.ranking}",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMembers(){
    List<Widget> members = [];
    for(TeamMemberModel teamMemberModel in controller.matchTeamModel.value.members){
      members.add(
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 10,left: 15,right: 15),
          decoration: BoxDecoration(
            color: Color(0x08ffffff),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipOval(
                    child: Image.network(
                      teamMemberModel.memberPhoto,
                      fit: BoxFit.cover,
                    )
                  )
                )
              ),
              SizedBox(width: 10,),
              Text("${teamMemberModel.nickName}",style: TextStyle(fontSize: 16,color: Colors.white),),
              SizedBox(width: 10,),
              Text("${teamMemberModel.memberRole}",style: TextStyle(fontSize: 16,color: Colors.white54),),
              Spacer(),
              teamMemberModel.nickName == controller.matchTeamModel.value.leader ?
                Icon(Icons.assistant_photo,size: 20,color: Colors.white,) : Container()
            ],
          ),
        )
      );
    }
    return Column(
      children: members,
    );
  }
}

class TeamPageController extends GetxController {
  late ScrollController scrollController;

  final int eventId;

  Rx<MatchTeamModel> matchTeamModel = Rx(MatchTeamModel());

  TeamPageController({required this.eventId});

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
    matchTeamModel.value = await EventsApi.myTeam(eventId);
  }

  void copy(){
    Clipboard.setData(ClipboardData(text: matchTeamModel.value.passCode));
    EasyLoading.showToast("The team passcode has been copied to your clipboard".tr);
  }

}