import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/events_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/activity_item_model.dart';
import 'package:wy/model/match_item_model.dart';
import 'package:wy/ui/common/activity_item.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/match_item.dart';

import '../../../utils/toast_utils.dart';

class TabEventPage extends StatelessWidget {

  final int type;

  late final TabEventPageController controller;

  TabEventPage({required this.type}){
    controller = Get.put(TabEventPageController(type: type), tag: "$type");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=> controller.initializing.value ? Container() : controller.list.length == 0 ? EmptyView() :
      ListView.separated(
        itemBuilder: (context, index){
          if(type == 2) {
            MatchItemModel model = controller.list[index];
            return MatchItem(model: model,joined: true,);
          }else{
            ActivityItemModel model = controller.list[index];
            return ActivityItem(model:model);
          }
        },
        separatorBuilder: (context, index){
          return Container(height: 5,);
        },
        itemCount: controller.list.length
      )
    );
  }
}

class TabEventPageController extends GetxListController {

  late int type;

  TabEventPageController({required this.type});

  @override
  Future<List> loadData() async{
    showLoading();
    if(type == 1){
      List list = await EventsApi.userActivities();
      dismissLoading();
      return list;
    }else{
      List list = await EventsApi.userMatches();
      dismissLoading();
      return list;
    }
  }

}