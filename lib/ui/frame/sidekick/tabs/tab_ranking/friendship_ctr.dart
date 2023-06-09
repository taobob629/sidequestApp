
import '../../../../../api/user_api.dart';
import '../../../../../common/getx_refresh_controller.dart';
import '../../../../../model/vistor_model.dart';

class FriendShipCtr extends GetxRefreshController<VisitorModel> {

  @override
  Future<List<VisitorModel>> loadData({int pageNum = 1}) async {
    return await UserApi.visitorList(pageNum, 20);
  }
}