import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api/game_api.dart';
import '../../../api/index_api.dart';
import '../../../common/empty_view.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../model/activity_item_model.dart';
import '../../../model/banner_model.dart';
import '../../../model/game_model.dart';
import '../../../model/headline_model.dart';
import '../../../model/match_item_model.dart';
import '../../../model/news_item_model.dart';
import '../../../model/promotion_item_model.dart';
import '../../../widget/banner_view.dart';
import '../../../widget/home_horizontal_widget.dart';
import '../../../widget/news_item.dart';

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
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              expandedHeight: height,
              flexibleSpace: FlexibleSpaceBar(
                  background: Obx(() => controller.banners.isEmpty
                      ? EmptyView()
                      : BannerView(
                          banners: controller.banners,
                        ))),
            ),
            HomeHorizontalWidget(
              'Top Monthly Sidekick Users'.tr,
              controller.topPlayers,
              // onTapMore: () => Get.toNamed(AppPages.SEARCH_USER_PAGE,
              //     arguments: Map()..['type'] = SEARCH_TYPE_TOP_MONTH),
            ),
            Obx(() => SliverList(
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      Widget w;
                      HeadlineModel data = controller.list[index];
                      if (data.type == "news") {
                        NewsItemModel news = data.model as NewsItemModel;
                        w = NewsItem(news);
                      } /*else if (data.type == "activity") {
                        ActivityItemModel activity = data.model as ActivityItemModel;
                        // w = ActivityItem(model: activity);
                      } else if (data.type == "match") {
                        MatchItemModel match = data.model as MatchItemModel;
                        // w = MatchItem(
                        //   model: match,
                        // );
                      } else if (data.type == "promotion") {
                        PromotionItemModel promotion =
                        data.model as PromotionItemModel;
                        // w = PromotionItem(model: promotion);
                      }*/ else {
                        w = Container();
                      }
                      return w;
                    }, childCount: controller.list.length)))
          ],
        ));
  }
}

class TabHeadlinesPageController extends GetxRefreshController<HeadlineModel> {
  RxList<BannerModel> banners = RxList();
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
    List<BannerModel> bannerList = await IndexApi.getBanners(5);
    if (bannerList.isNotEmpty) {
      banners.clear();
      banners.addAll(bannerList);
    }
  }

  Future<List<HeadlineModel>> loadData(
      {int pageNum = GetxRefreshController.pageNumFirst}) async {
    if (pageNum == GetxRefreshController.pageNumFirst) {
      _loadBanner();
    }
    List<HeadlineModel> list = await IndexApi.getHeadlines(pageNum, pageSize);

    return list;
  }
}
