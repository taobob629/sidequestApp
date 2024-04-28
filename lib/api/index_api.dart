import 'package:dio/dio.dart';
import 'package:sq_hub_app/api/wy_http.dart';

import '../model/banner_model.dart';
import '../model/game_model.dart';
import '../model/headline_model.dart';
import '../model/news_detail_model.dart';
import '../model/news_item_model.dart';
import '../model/promotion_item_model.dart';

class IndexApi {
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

  static Future<List<NewsItemModel>> getNews(int pageNum, int pageSize) async {
    var response = await http.get('/app/index/news',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    List<NewsItemModel> list = response.data
        .map<NewsItemModel>((item) => NewsItemModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<GameModel>> getGames() async {
    var response = await http.get('/app/index/games',
        queryParameters: ({'pageNum': 0, 'pageSize': 100}));
    List<GameModel> list = response.data
        .map<GameModel>((item) => GameModel.fromJson(item))
        .toList();
    return list;
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

  //搜索
  static Future<String> searchBankByCode(var code) async {
    var response = await http.get('/peiwan/app/card/sortcode/$code');
    if (response.data == null) {
      return '';
    }
    return response.data;
  }

  static Future<Response> focusGame({var gameid = 0}) async {
    Response response = await http.post('/peiwan/app/home/addFavorite',
        data: Map<String, dynamic>()..['gameid'] = gameid);
    return response;
  }

  static Future<NewsDetailModel> getNewsDetail(int id) async {
    var response =
    await http.get('/app/index/news/detail/$id', queryParameters: ({}));
    return NewsDetailModel.fromJson(response.data);
  }
}
