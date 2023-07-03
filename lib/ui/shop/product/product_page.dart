import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:wy/api/shop_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/product_detail_model.dart';
import 'package:wy/model/product_item_model.dart';
import 'package:wy/ui/common/quantity_selector.dart';
import 'package:wy/ui/controller/cart_controller.dart';
import 'package:wy/ui/shop/product/comb_item.dart';
import 'package:wy/ui/shop/product/recommend_item.dart';
import 'package:wy/utils/toast_utils.dart';

import 'add_button.dart';
import 'spec_item.dart';

class ProductPage extends StatelessWidget {

  //late final ProductItemModel product;

  final int productId;
  late final ProductPageController controller;

  ProductPage({required this.productId}){
    controller = Get.put(ProductPageController(id:productId),tag: "$productId");
  }

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
      .of(context)
      .size
      .width;
    controller.initData(width);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.background,
          body: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverAppBar(
                elevation: 0,
                pinned: true,
                backgroundColor: AppColor.background,
                expandedHeight: width,
                title: Obx(() {
                  return Text(
                    controller.productDetailModel.value.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: controller.titleColor.value, fontSize: 16),
                  );
                }),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 1,
                        top: 0,
                        child: Obx(()=>controller.productDetailModel.value.imageList.length == 0 ? Container(): Swiper(
                          autoplay: false,
                          itemBuilder: (BuildContext context, int index) {
                            String url = controller.productDetailModel.value.imageList[index];
                            return CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                            );
                          },
                          itemCount: controller.productDetailModel.value.imageList.length,
                          pagination: SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(bottom: 50)
                          ),
                          onTap: (index) {},
                        )),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: AppColor.background,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(22), topLeft: Radius.circular(22))
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "PRODUCT DETAILS".tr,
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                                  ),
                          ),
                        )
                      )
                    ],
                  )
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                    if (index == 0) {
                      return Container();//_buildSpec();
                    } else if (index == 1) {
                      return Obx(()=>_buildAdditional());
                    } else if (index == 2) {
                      return Container();//_buildQuantity();
                    } else if (index == 3) {
                      return Container(
                        height: 0,
                        color: Color(0xFF0F0D1A),
                        margin: const EdgeInsets.symmetric(vertical: 0),
                      );
                    } else if (index == 4) {
                      return Obx(()=>_buildComb());
                    } else if (index == 5) {
                      return Container(
                        height: 10,
                        color: Color(0xFF0F0D1A),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                      );
                    } else if (index == 6) {
                      return Obx(()=>_buildRecommend());
                    }
                    return Container(
                      height: 100,
                    );
                  },
                  childCount: 8
                )
              )
            ],
          )
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: AddButton(
              productId: productId,
              onTap: () {
                cartController.addProduct(controller.getItem());
                controller.updateProductCount();
              },
            )
          ),
        )
      ],
    );
  }

  Widget _buildSpec() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10, left: 15),
          child: Text(
            "${'Specification'.tr}:",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Obx(() {
              return Row(
                children: [
                  SpecItem(
                    index: 0,
                    content: "No numeric keypad".tr,
                    selected: controller.selectedSpec.value,
                    onTap: (index) {
                      controller.changeSpecIndex(index);
                    },
                  ),
                  SpecItem(
                    index: 1,
                    content: "Numeric keypad".tr,
                    selected: controller.selectedSpec.value,
                    onTap: (index) {
                      controller.changeSpecIndex(index);
                    },
                  ),
                  SpecItem(
                    index: 2,
                    content: "Wireless keypad".tr,
                    selected: controller.selectedSpec.value,
                    onTap: (index) {
                      controller.changeSpecIndex(index);
                    },
                  )
                ],
              );
            }),
          ),
        )
      ],
    );
  }

  Widget _buildComb() {
    if(controller.productDetailModel.value.combos.length == 0){
      return Container();
    }
    List<Widget> list = [];
    list.add(Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 15),
      child: Text(
        "${'Combination'.tr}:",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    ));
    for(ProductItemModel productItemModel in controller.productDetailModel.value.combos){
      list.add(CombItem(productItemModel: productItemModel,));
      list.add(SizedBox(height: 10,));
    }
    if(list.length > 1){
      list.removeLast();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

  Widget _buildQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10, left: 15),
        child: Text(
          "${'Quantity'.tr}:",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
        Container(
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: QuantitySelector(
            initValue: 1,
            tag: "$productId",
            onQuantityChanged: (quantity) => {},
          )
        )
      ]
    );
  }

  Widget _buildAdditional() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "ADDITIONAL INFORMATION",
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 18,
          //     fontFamily: "DIN"
          //   ),
          // ),
          // SizedBox(height: 10,),
          Html(
            data: "${controller.productDetailModel.value.info}",
            style: {
              "body": Style(fontSize:FontSize(14) ,color: Colors.white38,lineHeight: LineHeight(2))
            },
          )
        ],
      ),
    );
  }

  Widget _buildRecommend() {
    List<Widget> items = [];
    for (int i = 0; i < controller.recommends.length; i++) {
      items.add(RecommendItem(productItemModel: controller.recommends[i],));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RECOMMEND".tr,
            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
          ),
          SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items,
            ),
          )
        ],
      ),
    );
  }
}

class ProductPageController extends GetxController {

  late var selectedSpec = 0.obs;

  late ScrollController scrollController;

  var titleColor = Colors.transparent.obs;

  var headerHeight = 0.0.obs;

  var productCount = 0.obs;

  Rx<ProductDetailModel> productDetailModel = ProductDetailModel().obs;

  RxList<ProductItemModel> recommends = RxList();

  CartController cartController = Get.find<CartController>();

  int id;

  ProductPageController({required this.id});

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    dismissLoading();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    updateProductCount();
    scrollController.addListener(() {
      if (scrollController.offset >= headerHeight.value - kToolbarHeight) {
        if (titleColor.value == Colors.transparent) {
          changeTitleColor(Colors.white);
        }
      } else {
        if (titleColor.value == Colors.white) {
          changeTitleColor(Colors.transparent);
        }
      }
    });
  }

  void initData(double headerHeight) async {
    this.headerHeight.value = headerHeight;
    showLoading();
    this.productDetailModel.value = await ShopApi.getProductDetail(id);
    if(this.productDetailModel.value.imageList.isNotEmpty){
      this.productDetailModel.value.imageList.forEach((element) {
        DefaultCacheManager().downloadFile(element);
      });
    }
    this.recommends.addAll(await ShopApi.recommend(id));
    dismissLoading();
  }

  void changeSpecIndex(int index) {
    this.selectedSpec.value = index;
  }

  void changeTitleColor(Color titleColor) {
    this.titleColor.value = titleColor;
  }

  void updateProductCount(){
    productCount.value = cartController.getProductCount(id);
  }

  ProductItemModel getItem(){
    ProductItemModel itemModel = ProductItemModel();
    itemModel.id = this.id;
    itemModel.name = this.productDetailModel.value.name;
    itemModel.count = 1;
    itemModel.image = this.productDetailModel.value.coverImage;
    itemModel.tax = this.productDetailModel.value.tax;
    itemModel.price = this.productDetailModel.value.price;
    itemModel.combos = this.productDetailModel.value.combos;
    return itemModel;
  }

}