import 'package:sq_hub_app/api/wy_http.dart';

import '../model/bubble_tea_store_model.dart';
import '../model/store_tea_model.dart';
import '../model/vip_info_model.dart';

class HubsApi {
  static Future<List<BubbleTeaStoreModel>> getStores() async {
    var response = await http.get('/app/hubs/stores');
    List<BubbleTeaStoreModel> list = response.data
        .map<BubbleTeaStoreModel>((item) => BubbleTeaStoreModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<dynamic> getTeaBanners(int? storeId) async {
    var response = await http
        .get('/app/hubs/teaBanners', queryParameters: {"storeId": storeId});
    return response.data;
  }

  static Future<List<StoreTeaModel>> getTeaList(
      int? storeId, String categoryId) async {
    var response = await http.get('/app/hubs/teas', queryParameters: {
      "storeId": storeId,
      "categoryId": categoryId,
    });
    List<StoreTeaModel> list = response.data
        .map<StoreTeaModel>((item) => StoreTeaModel.fromJson(item))
        .toList();
    return list;
  }
}
