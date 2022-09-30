/*
  controller
  sidequest_hub_app
  desc: 关注和粉丝列表
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:wy/api/user_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/model/user_model.dart';
import 'package:wy/ui/profile/attention/list/view.dart';
import 'package:wy/utils/utils.dart';

class AttentionListPageController extends GetxRefreshController {
  int type;

  AttentionListPageController(this.type);

  @override
  void onInit() {
    initialRefresh = true;
    super.onInit();
  }

  @override
  Future<List<AttentionModel>> loadData({int pageNum = 0}) async {
    var list;
    //return [UserInfoModel()];
    switch(type){
      case  TYPE_FANS:
        list = await UserApi.fansList(pageNum, pageSize);
        break;
      case TYPE_FOLLOW:
        list = await UserApi.attentionList(pageNum, pageSize);
        break;
    }
    flog('user $list');
    return list;
  }
}
