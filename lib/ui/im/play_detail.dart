import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/im/play_order.dart';

import '../../config/app_color.dart';
import '../../model/play_detail_model.dart';

class PlayDetail extends StatelessWidget {

  final int userId;
  late final PlayDetailController controller;

  PlayDetail({required this.userId}){
    controller = Get.put(PlayDetailController(userId:userId));
  }

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
                    controller.detailModel.value.name,
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
                        child: Obx(()=>controller.detailModel.value.imageList.length == 0 ? Container(): Swiper(
                          autoplay: false,
                          itemBuilder: (BuildContext context, int index) {
                            String url = controller.detailModel.value.imageList[index];
                            return CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                            );
                          },
                          itemCount: controller.detailModel.value.imageList.length,
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
                          height: 70,
                          child: Stack(
                            children: [
                              Positioned(
                                left:0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height:35,
                                  decoration: BoxDecoration(
                                    color: AppColor.background,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(22), topLeft: Radius.circular(22))
                                  ),
                                )
                              ),
                              Positioned(
                                left: 15,
                                top: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CachedNetworkImage(
                                      imageUrl: controller.detailModel.value.avatar,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context,provider){
                                        return Container(
                                          width: 66,
                                          height: 66,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(35),
                                            image:DecorationImage(
                                              image: provider,
                                              fit: BoxFit.cover,
                                            )
                                          ),
                                        );
                                      },
                                    )
                                  )
                                ),
                              )
                            ],
                          )
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
                      return buildInfo();
                    }else if(index == 1){
                      return buildGames();
                    }
                    return Container(
                      height: 600,
                    );
                  },
                  childCount: 3
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorfulButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle,color: Colors.white,size: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 4),
                        child: Text(
                          "Follow",
                          style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "din"),
                        ),
                      ),
                    ],
                  ),
                  height: 50,
                  width: 160,
                ),
                ColorfulButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.message,color: Colors.white,size: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 4),
                        child: Text(
                          "Message",
                          style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "din"),
                        ),
                      ),
                    ],
                  ),
                  height: 50,
                  width: 160,
                )
              ],
            )
          ),
        )
      ],
    );
  }

  Widget buildInfo(){
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Text("${controller.detailModel.value.name}",style: TextStyle(fontSize: 24,color: Colors.white),)
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Follow: ",style: TextStyle(fontSize: 12,color: Colors.white54),),
              Text("332",style: TextStyle(fontSize: 16,color: Colors.white),),
              SizedBox(width: 30,),
              Text("Fans: ",style: TextStyle(fontSize: 12,color: Colors.white54),),
              Text("32",style: TextStyle(fontSize: 16,color: Colors.white),)
            ],
          )
        ],
      ),
    );
  }

  Widget buildGames(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("I am good at: ",style: TextStyle(fontSize: 18,color: Colors.white),),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white12
            ),
            child: Column(
              children: [
                _buildGame()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGame(){
    return GestureDetector(
      onTap: ()=>Get.to(()=>PlayOrder()),
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF7D00FF)
        ),
        child: Row(
          children: [
            Image.network("http://p2.itc.cn/images01/20201106/bd3499c7f6694ef68dcf84f7085bf071.jpeg",width: 66,height: 66,fit: BoxFit.cover,),
            SizedBox(width: 5,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("LEAGUE OF LEGENDS",style: TextStyle(color: Colors.white,fontSize: 14),),
                Text("King 120star",style: TextStyle(color: Colors.white54,fontSize: 12),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("£ 20.0",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                    Text(" / hour",style: TextStyle(color: Colors.white54,fontSize: 12),),
                  ],
                )
              ],
            ),
            Spacer(),
            ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 2),
                child: Text(
                  "Order",
                  style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "din"),
                ),
              ),
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class PlayDetailController extends GetxController {
  int userId;

  late ScrollController scrollController;

  var titleColor = Colors.transparent.obs;

  var headerHeight = 0.0.obs;

  Rx<PlayDetailModel> detailModel = PlayDetailModel().obs;

  PlayDetailController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    EasyLoading.dismiss(animation: false);
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
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
    EasyLoading.show();
    if(detailModel.value.imageList.length == 0) {
      detailModel.value.imageList.add(
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F6020354b4960f27eab51c5005f4dfecb5007557e12e014-2vf4WP_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665099671&t=819cd5ffe0a6286cac0515d00681e361");
      detailModel.value.imageList.add(
        "https://pics5.baidu.com/feed/a71ea8d3fd1f41343c411bba13c53dcdd3c85ee5.jpeg?token=ca8e4fac1efb35a98c56b83ca73bebd5");
      detailModel.value.imageList.add(
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2F0%2Fde%2F6300ed8f12.jpg&refer=http%3A%2F%2Fpic1.win4000.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665099671&t=680fd115dad0fecb14f0eccebb3a52d3");
    }
    // this.productDetailModel.value = await ShopApi.getProductDetail(id);
    detailModel.value.name = "Wakabe";
    detailModel.value.avatar = "https://pics0.baidu.com/feed/9d82d158ccbf6c81ff60dec6d3b2443332fa40d8.jpeg?token=c04443f136e02e3712476a018e2694be";
    if(this.detailModel.value.imageList.isNotEmpty){
      this.detailModel.value.imageList.forEach((element) {
        DefaultCacheManager().downloadFile(element);
      });
    }
    EasyLoading.dismiss();
  }

  void changeTitleColor(Color titleColor) {
    this.titleColor.value = titleColor;
  }
}