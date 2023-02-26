import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/model/news_item_model.dart';
import 'package:wy/ui/common/banner_view.dart';
import 'package:wy/ui/common/news_item.dart';
import 'package:wy/model/banner_model.dart' as custom;

class TabNewsPage extends StatelessWidget {
  final controller = Get.put(TabNewsPageController());

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
                      ? Container()
                      : BannerView(
                          banners: controller.banners,
                        ))),
            ),
            Obx(() {
              return SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                NewsItemModel item = controller.list[index];
                return NewsItem(item);
              }, childCount: controller.list.length));
            })
          ],
        ));
  }
}

class TabNewsPageController extends GetxRefreshController<NewsItemModel> {
  RxList<custom.BannerModel> banners = RxList();

  @override
  void onInit() {
    super.onInit();
    this.pageSize = 10;
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> _loadBanner() async {
    List<custom.BannerModel> bannerList = await IndexApi.getBanners(6);
    if (bannerList.isNotEmpty) {
      banners.clear();
      banners.addAll(bannerList);
    }
  }

  Future<List<NewsItemModel>> loadData({int pageNum = 1}) async {
    if (pageNum == 1) {
      _loadBanner();
    }
    List<NewsItemModel> list = await IndexApi.getNews(pageNum, pageSize);
    return list;
  }
}
