import 'package:wy/api/game_api.dart';
import 'package:wy/model/banner_model.dart' as custom;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/model/activity_item_model.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/model/headline_model.dart';
import 'package:wy/model/match_item_model.dart';
import 'package:wy/model/news_item_model.dart';
import 'package:wy/model/promotion_item_model.dart';
import 'package:wy/ui/common/activity_item.dart';
import 'package:wy/ui/common/banner_view.dart';
import 'package:wy/ui/common/match_item.dart';
import 'package:wy/ui/common/news_item.dart';
import 'package:wy/ui/common/promotion_item.dart';
import 'package:wy/ui/frame/home/widget/home_horizontal_widget.dart';
import 'package:wy/utils/index.dart';

class TabHeadlinesPage extends StatelessWidget {
  final controller = Get.put(TabHeadlinesPageController());

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.width - 30) * 19 / 34;
    return SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        onLoading: controller.loadMore,
        enablePullUp: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: height,
              flexibleSpace: FlexibleSpaceBar(
                  background: Obx(() => controller.banners.isEmpty
                      ? Container(color: Colors.yellow,)
                      : BannerView(
                          banners: controller.banners,
                        ))),
            ),
            // Obx(() => Visibility(
            //   visible: controller.topPlayers.isNotEmpty,
            //     child:
            //         HomeHorizontalWidget('Top Monthly Sidekick users'.tr, controller.topPlayers))),
            HomeHorizontalWidget('Top Monthly Sidekick Users'.tr, controller.topPlayers),
            Obx(() {
              return SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                Widget w;
                HeadlineModel data = controller.list[index];
                if (data.type == "news") {
                  NewsItemModel news = data.model as NewsItemModel;
                  w = NewsItem(news);
                } else if (data.type == "activity") {
                  ActivityItemModel activity = data.model as ActivityItemModel;
                  w = ActivityItem(model: activity);
                } else if (data.type == "match") {
                  MatchItemModel match = data.model as MatchItemModel;
                  w = MatchItem(
                    model: match,
                  );
                } else if (data.type == "promotion") {
                  PromotionItemModel promotion = data.model as PromotionItemModel;
                  w = PromotionItem(model: promotion);
                } else {
                  w = Container();
                }
                return w;
              }, childCount: controller.list.length));
            })
          ],
        ));
  }
}

class TabHeadlinesPageController extends GetxRefreshController<HeadlineModel> {
  RxList<custom.BannerModel> banners = RxList();
  RxList<SimpleGameModel> topPlayers = RxList();

  @override
  void onInit() {
    this.initialRefresh = true;
    super.onInit();
    this.pageSize = 10;
  }

  @override
  void onReady() async {
    super.onReady();
    _loadTopPlayers();
  }

  Future<void> _loadTopPlayers() async {
    List<SimpleGameModel> playerList = await GamesApi.getTopPlayers();
    if (playerList.isNotEmpty) {
      topPlayers.clear();
      topPlayers.addAll(playerList);
    }
  }

  Future<void> _loadBanner() async {
    List<custom.BannerModel> bannerList = await IndexApi.getBanners(5);
    flog('baners${banners.length}');
    if (bannerList.isNotEmpty) {
      banners.clear();
      banners.addAll(bannerList);
    }
  }

  Future<List<HeadlineModel>> loadData({int pageNum =  GetxRefreshController.pageNumFirst}) async {
    if (pageNum ==  GetxRefreshController.pageNumFirst) {
      _loadBanner();
    }
    List<HeadlineModel> list = await IndexApi.getHeadlines(pageNum, pageSize);

    return list;
  }
}
