
import 'dart:io';

import 'package:wy/model/banner_model.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/model/headline_model.dart';
import 'package:wy/model/news_detail_model.dart';
import 'package:wy/model/news_item_model.dart';
import 'package:wy/model/promotion_item_model.dart';
import 'package:wy/model/version_model.dart';
import 'package:wy/utils/platform_utils.dart';

import 'wy_http.dart';

class IndexApi {

  static Future<List<BannerModel>> getBanners(int tab) async {
    var response = await http.get('/app/index/banners',
      queryParameters: ({'tab': tab})
    );
    List<BannerModel> list = response.data
      .map<BannerModel>((item) => BannerModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<HeadlineModel>> getHeadlines(int pageNum, int pageSize) async {
    var response = await http.get('/app/index/headlines',
      queryParameters: ({'pageNum': pageNum,'pageSize':pageSize})
    );
    List<HeadlineModel> list = response.data
      .map<HeadlineModel>((item) => HeadlineModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<NewsItemModel>> getNews(int pageNum,int pageSize) async {
    var response = await http.get('/app/index/news',
      queryParameters: ({'pageNum': pageNum,'pageSize':pageSize})
    );
    List<NewsItemModel> list = response.data
      .map<NewsItemModel>((item) => NewsItemModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<GameModel>> getGames() async {
    var response = await http.get('/app/index/games',
      queryParameters: ({'pageNum': 0,'pageSize':100})
    );
    List<GameModel> list = response.data
      .map<GameModel>((item) => GameModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<NewsDetailModel> getNewsDetail(int id) async {
    var response = await http.get('/app/index/news/detail/$id',
      queryParameters: ({})
    );
    return NewsDetailModel.fromJson(response.data);
  }

  static Future<PromotionItemModel?> getAD() async {
    var response = await http.get('/app/index/promoteAD',
      queryParameters: ({})
    );
    List<HeadlineModel> list = response.data
      .map<HeadlineModel>((item) => HeadlineModel.fromJson(item))
      .toList();
    if(list.isNotEmpty){
      HeadlineModel headlineModel = list[0];
      return headlineModel.model as PromotionItemModel;
    }
    return null;
  }

  static Future<void> readAD(int id,String name) async {
    await http.get('/app/index/userad',
      queryParameters: ({"promotionId":id,"promotionName":name})
    );
  }

  static Future<VersionModel> checkVersion() async {
    String platform = Platform.operatingSystem;
    String version = await PlatformUtils.getAppVersion();
    var response = await http.get('/app/index/checkVersion',
      queryParameters: ({"version":version,"platform":platform})
    );
    return VersionModel.fromJson(response.data);
  }


}