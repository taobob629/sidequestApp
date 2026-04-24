import 'package:sq_hub_app/api/wy_http.dart';
import 'package:sq_hub_app/model/goods_detail_model.dart';

import '../model/bubble_confirm_order_model.dart';
import '../model/bubble_tea_ad_model.dart';
import '../model/bubble_tea_store_model.dart';
import '../model/store_tea_model.dart';
import '../model/tea_category_model.dart';
import '../model/top_food_model.dart';
import '../model/top_game_model.dart';
import '../model/top_tea_model.dart';
import '../model/vip_info_model.dart';

class HubsApi {
  static Future<List<BubbleTeaStoreModel>> getStores() async {
    var response = await http.get('/sideQuest/app/hubs/stores');
    List<BubbleTeaStoreModel> list = response.data
        .map<BubbleTeaStoreModel>((item) => BubbleTeaStoreModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<BubbleTeaAdModel>> getTeaBanners(int? storeId) async {
    var response = await http.get('/sideQuest/app/hubs/teaBanners',
        queryParameters: {"storeId": storeId});
    if (response.data == null) {
      return [];
    }
    List<BubbleTeaAdModel> list = response.data
        .map<BubbleTeaAdModel>((item) => BubbleTeaAdModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<GoodsDetailModel> goodDetail(int? id) async {
    var response = await http
        .get('/sideQuest/app/hubs/goodDetail', queryParameters: {"id": id});
    return GoodsDetailModel.fromJson(response.data);
  }

  static Future<dynamic> getVouchers(int? id) async {
    var response = await http
        .get('/sideQuest/app/hubs/getVouchers', queryParameters: {"id": id});
    return response.data;
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

  static Future<List<StoreTeaModel>> getBannerTeaList(
    int? storeId,
    int? categoryId,
    String? subCategoryId,
  ) async {
    var response =
        await http.get('/sideQuest/app/hubs/bannerTeas', queryParameters: {
      "storeId": storeId,
      "categoryId": categoryId,
      "subCategoryId": subCategoryId,
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

  static Future<BubbleConfirmOrderModel> confirmOrder({
    required int storeId,
    required List<Map<String, dynamic>> goodsList,
    required String eatin,
    required String arrivalTime,
    int? couponId,
  }) async {
    var response = await http.post('/sideQuest/app/hubs/confirmOrder', data: {
      "storeId": storeId,
      "goodsList": goodsList,
      "eatin": eatin,
      "arrivalTime": arrivalTime,
      "couponId": couponId,
    });
    return BubbleConfirmOrderModel.fromJson(response.data);
  }

  static Future<BubbleConfirmOrderModel> confirmBundleOrder({
    required int storeId,
    required List<Map<String, dynamic>> goodsList,
    int? couponId,
  }) async {
    var response =
        await http.post('/sideQuest/app/hubs/confirmBundleOrder', data: {
      "storeId": storeId,
      "goodsList": goodsList,
      "couponId": couponId,
    });
    return BubbleConfirmOrderModel.fromJson(response.data);
  }

  static Future<List<TopTeaModel>> getTopTeas() async {
    var response = await http.get('/sideQuest/app/hubs/topTeas');
    if (response.data == null) {
      return [];
    }
    List<TopTeaModel> list = response.data
        .map<TopTeaModel>((item) => TopTeaModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<TopGameModel>> getTopGames() async {
    var response = await http.get('/sideQuest/app/hubs/topGames');
    if (response.data == null) {
      return [];
    }
    List<TopGameModel> list = response.data
        .map<TopGameModel>((item) => TopGameModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<TopFoodModel>> getTopFoods() async {
    var response = await http.get('/sideQuest/app/hubs/topFoods');
    if (response.data == null) {
      return [];
    }
    List<TopFoodModel> list = response.data
        .map<TopFoodModel>((item) => TopFoodModel.fromJson(item))
        .toList();
    return list;
  }
}
