
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/shop_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/model/product_item_model.dart';
import 'package:wy/model/shop_tab_model.dart';
import 'package:wy/ui/common/banner_view.dart';
import 'package:wy/ui/shop/product_item.dart';
import 'package:wy/ui/shop/shop_page.dart';

class TabCatePage extends StatelessWidget {
  late final bool showBanners;
  late final TabCatePageController controller;
  late final ShopTabModel tab;
  TabCatePage({
    required ShopTabModel tab,
    required bool showBanners,
  }){
    this.showBanners = showBanners;
    this.tab = tab;
    controller = Get.put(TabCatePageController(tab: tab),tag: "${tab.id}");
  }

  final shopPageController = Get.find<ShopPageController>();

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery
      .of(context)
      .size
      .width - 30) * 19 / 34;

    double itemWidth = (MediaQuery
      .of(context)
      .size
      .width - 40) / 2;

    double imageHeight = itemWidth * 349 / 280;

    double itemHeight = imageHeight + 10 + 40 + 10 + 30;

    return SmartRefresher(
      controller: controller.refreshController,
      onRefresh: controller.refresh,
      onLoading: controller.loadMore,
      enablePullUp: true,
      child: CustomScrollView(
        slivers: [
          SliverOffstage(
            offstage: false,
            sliver: SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: height,
              flexibleSpace: FlexibleSpaceBar(
                background: Obx(()=>shopPageController.banners.isEmpty ? Container():BannerView(banners: shopPageController.banners,))
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            sliver: Obx(() {
              if(controller.list.length == 0){
                return SliverFillViewport(delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return SizedBox(height: 10,);
                },childCount: 1));
              }
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                    ProductItemModel product = controller.list[index];
                    return ProductItem(product);
                  },
                  childCount: controller.list.length
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                  childAspectRatio: itemWidth / itemHeight
                )
              );
            }),
          ),
        ],
      )
    );
  }
}

class TabCatePageController extends GetxRefreshController {

  ShopTabModel tab;

  TabCatePageController({required this.tab});

  @override
  void onInit() {
    super.onInit();
    this.pageSize = 10;
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<List<ProductItemModel>> loadData({int pageNum = 1}) async {
    List<ProductItemModel> list = await ShopApi.products(tab.id, pageNum, pageSize);
    return list;
  }
}