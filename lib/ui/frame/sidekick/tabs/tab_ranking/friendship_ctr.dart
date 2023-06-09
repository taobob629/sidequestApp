
import 'package:get/get.dart';
import 'package:wy/ui/frame/sidekick/tabs/tab_ranking/tab_ranking_ctr.dart';

import '../../../../../api/user_api.dart';
import '../../../../../api/wy_http.dart';
import '../../../../../common/getx_refresh_controller.dart';
import '../../../../../model/playmate_model.dart';
import '../../../../../model/vistor_model.dart';
import '../../../../../utils/toast_utils.dart';

class FriendShipCtr extends GetxRefreshController<TopModel> {
  static FriendShipCtr get find => Get.find();

  @override
  Future<List<TopModel>> loadData({int pageNum = 1}) async {
    int type = TabRankingCtr.find.selectTypeIndex;

    List<TopModel> list = [];
    showLoading();
    var response = await http.get('/peiwan/app/new/home/top/intimacy/user',
        queryParameters: ({
          'topNum': 20,
          'type': type,
          'pageNum': pageNum,
          'pageSize': pageSize
        }));
    dismissLoading();
    if (response.data == null) {
      return list;
    }
    PlaymateModel model = PlaymateModel.fromJson(response.data);
    list = model.top;
    return list;
  }
}