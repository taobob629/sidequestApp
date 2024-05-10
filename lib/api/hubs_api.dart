import 'package:sq_hub_app/api/wy_http.dart';
import 'package:sq_hub_app/model/goods_detail_model.dart';

import '../model/bubble_tea_store_model.dart';
import '../model/store_tea_model.dart';
import '../model/tea_category_model.dart';
import '../model/vip_info_model.dart';

class HubsApi {
  static Future<List<BubbleTeaStoreModel>> getStores() async {
    var response = await http.get('/sideQuest/app/hubs/stores');
    List<BubbleTeaStoreModel> list = response.data
        .map<BubbleTeaStoreModel>((item) => BubbleTeaStoreModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<dynamic> getTeaBanners(int? storeId) async {
    var response = await http.get('/sideQuest/app/hubs/teaBanners',
        queryParameters: {"storeId": storeId});
    return response.data;
  }

  static Future<GoodsDetailModel> goodDetail(int? id) async {
    var response = await http
        .get('/sideQuest/app/hubs/goodDetail', queryParameters: {"id": id});
    return GoodsDetailModel.fromJson(response.data);
  }

  static Future<List<StoreTeaModel>> getTeaList(
      int? storeId, int? categoryId) async {
    var response = await http.get('/sideQuest/app/hubs/teas', queryParameters: {
      "storeId": storeId,
      "categoryId": categoryId,
    });
    List<StoreTeaModel> list = response.data
        .map<StoreTeaModel>((item) => StoreTeaModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<TeaCategoryModel>> getTeaCategory(int? storeId) async {
    var response =
        await http.get('/sideQuest/app/hubs/teaCategory', queryParameters: {
      "storeId": storeId,
    });
    List<TeaCategoryModel> list = response.data
        .map<TeaCategoryModel>((item) => TeaCategoryModel.fromJson(item))
        .toList();
    return list;
  }
}
