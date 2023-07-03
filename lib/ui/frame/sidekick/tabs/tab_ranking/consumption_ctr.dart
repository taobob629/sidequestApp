import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../common/getx_refresh_controller.dart';
import '../../../../../model/playmate_model.dart';
import '../../../../../utils/toast_utils.dart';
import 'tab_ranking_ctr.dart';

class ConsumptionCtr extends GetxRefreshController<TopModel> {
  static ConsumptionCtr get find => Get.find();

  @override
  Future<List<TopModel>> loadData({int pageNum = 1}) async {
    int type = TabRankingCtr.find.selectTypeIndex;

    List<TopModel> list = [];
    showLoading();
    var response = await http.get('/peiwan/app/new/home/top/consume/user',
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
