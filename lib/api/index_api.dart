import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:sq_hub_app/api/wy_http.dart';
import 'package:sq_hub_app/model/index_tab_model.dart';

import '../model/banner_model.dart';
import '../model/bundles_detail_model.dart';
import '../model/bundles_model.dart';
import '../model/game_model.dart';
import '../model/game_service_model.dart';
import '../model/headline_model.dart';
import '../model/news_detail_model.dart';
import '../model/news_item_model.dart';
import '../model/promotion_item_model.dart';
import '../model/tab_news_model.dart';
import '../model/version_model.dart';
import '../model/what_on_event_model.dart';
import '../utils/platform_utils.dart';

class IndexApi {
  static Future<List<IndexTabModel>> getIndexTabs() async {
    var response = await http.get('/sideQuest/app/whatOn/tabs');
    List<IndexTabModel> list = response.data
        .map<IndexTabModel>((item) => IndexTabModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<WhatOnEventModel>> getEvents(
      int pageNum, int pageSize) async {
    var response = await http.get('/sideQuest/app/whatOn/events',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    List<WhatOnEventModel> list = response.data
        .map<WhatOnEventModel>((item) => WhatOnEventModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<BannerModel>> getBanners(int tab) async {
    var response =
        await http.get('/app/index/banners', queryParameters: ({'tab': tab}));
    List<BannerModel> list = response.data
        .map<BannerModel>((item) => BannerModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<HeadlineModel>> getHeadlines(
      int pageNum, int pageSize) async {
    var response = await http.get('/peiwan/app/new/home/headlines',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    List<HeadlineModel> list = response.data
        .map<HeadlineModel>((item) => HeadlineModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<TabNewsModel> getNews(int pageNum, int pageSize) async {
    var response = await http.get('/sideQuest/app/whatOn/news',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    TabNewsModel model = TabNewsModel.fromJson(response.data);
    return model;
  }

  static Future<List<BundlesModel>> getBundles(int? storeId) async {
    var response = await http.get('/sideQuest/app/whatOn/bundles',
        queryParameters: {"storeId": storeId});
    List<BundlesModel> list = response.data
        .map<BundlesModel>((item) => BundlesModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<BundlesDetailModel> bundleDetail(String id) async {
    var response =
        await http.get('/sideQuest/app/whatOn/bundleDetial', queryParameters: {
      "id": id,
    });
    BundlesDetailModel model = BundlesDetailModel.fromJson(response.data);
    return model;
  }

  static Future<List<GameModel>> getGames() async {
    var response = await http.get('/sideQuest/app/hubs/games',
        queryParameters: ({'pageNum': 0, 'pageSize': 100}));
    List<GameModel> list = response.data
        .map<GameModel>((item) => GameModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<NewsDetailModel> getNewsDetail(int id) async {
    var response =
        await http.get('/app/index/news/detail/$id', queryParameters: ({}));
    return NewsDetailModel.fromJson(response.data);
  }

  static Future<PromotionItemModel?> getAD() async {
    var response =
        await http.get('/app/index/promoteAD', queryParameters: ({}));
    List<HeadlineModel> list = response.data
        .map<HeadlineModel>((item) => HeadlineModel.fromJson(item))
        .toList();
    if (list.isNotEmpty) {
      HeadlineModel headlineModel = list[0];
      return headlineModel.model as PromotionItemModel;
    }
    return null;
  }

  static Future<void> readAD(int id, String name) async {
    await http.get('/app/index/userad',
        queryParameters: ({"promotionId": id, "promotionName": name}));
  }

  static Future<VersionModel> checkVersion() async {
    String platform = Platform.operatingSystem;
    String version = await PlatformUtils.getAppVersion();
    var response = await http.get('/app/index/checkVersion',
        queryParameters: ({"version": version, "platform": platform}));
    return VersionModel.fromJson(response.data);
  }

  //搜索
  static Future<String> searchBankByCode(var code) async {
    var response = await http.get('/peiwan/app/card/sortcode/$code');
    if (response.data == null) {
      return '';
    }
    return response.data;
  }

  static Future<List<GameServiceModel>> getMoreGames({int pwid = 0}) async {
    var response = await http.get('/peiwan/app/home/getServices');
    List<GameServiceModel> list = response.data
        .map<GameServiceModel>((item) => GameServiceModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<Response> focusGame({var gameid = 0}) async {
    Response response = await http.post('/peiwan/app/home/addFavorite',
        data: Map<String, dynamic>()..['gameid'] = gameid);
    return response;
  }
}
