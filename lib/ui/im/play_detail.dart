import 'dart:ffi';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/im/play_order.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/ui/playwith/game_comment.dart';
import 'package:wy/ui/playwith/photo_wall_widget.dart';
import 'package:wy/ui/playwith/play_profile_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/custom_scroll_physics.dart';
import 'package:wy/widget/my_bouncing_scroll_physics.dart';
import 'package:wy/widget/my_custom_scroll.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/photo_widget.dart';

import '../../api/im_api.dart';
import '../../config/app_color.dart';
import '../../model/play_detail_model.dart';
import '../common/dialog_confirm.dart';
import 'chat.dart';

class PlayDetail extends StatelessWidget {

  final String userId;
  final bool fromChat;
  final bool isMemberCode;
  late final PlayDetailController controller;

  PlayDetail({required this.userId, this.fromChat = false, this.isMemberCode = false}){
    controller = Get.put(PlayDetailController(userId:userId, isMemberCode: isMemberCode),tag: userId);
  }

  ///自己视角
  bool isMe=false;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
      .of(context)
      .size
      .width * 0.75;
    controller.initData(width);
    isMe = controller.userId==Get.find<UserController>().userInfoModel.value.pwuserId.toString();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.background,
          body: CustomScrollView(
            controller: controller.scrollController,
            physics: MyBouncingScrollPhysics(),
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
                actions: [
                  if(isMe)
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if(isMe){
                          await Get.to(()=>PlayProfilePage());
                          controller.onReady();
                          return;
                        }
                        Get.dialog(ConfirmDialog(
                          title: "Add Block List",
                          info: "Do you want to add this person to black list?",
                          confirmBtn: "CONFIRM",
                          onConfirm: () async {
                            EasyLoading.show();
                            var friendshipManager = TencentImSDKPlugin.v2TIMManager.getFriendshipManager();
                            List<String> userIDList = [];
                            userIDList.add(userId);
                            await friendshipManager.addToBlackList(userIDList: userIDList);
                            EasyLoading.dismiss();
                            Get.back();
                          },
                        ),barrierColor: Colors.black26);
                      },
                      child: Container(
                        height: 32,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(56),
                        ),
                        child: Text(isMe?"Edit": "Block",style: TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    ),
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Obx(()=>controller.detailModel.value.avatarThumb=='' ? Container(): Swiper(
                          autoplayDelay: 5000,
                          duration: 500,
                          itemBuilder: (BuildContext context, int index) {
                            String url = controller.detailModel.value.avatarThumb;
                            return GestureDetector(
                              onTap: ()=> Get.to(()=>PhotoView(images: [url],index: 0)),
                              child: CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          // pagination: SwiperPagination(
                          //   alignment: Alignment.bottomCenter,
                          //   margin: const EdgeInsets.only(bottom: 50)
                          // ),
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
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Obx(()=>controller.detailModel.value.avatar == "" ? Container():
                                        CachedNetworkImage(
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
                                        ))
                                      ),
                                      ///controller.detailModel.value
                                      Obx(() {
                                        var isOnline = controller.detailModel.value.online==1;
                                        return PWidget.container(PWidget.text(isOnline? 'Online':'OffLine', [Colors.white, 10]), {
                                          'gd':isOnline? PFun.tl2brGd(Color(0xff5ADBAE), Color(0x005ADBAE)):PFun.tl2brGd(Color(0xFF434343), Color(0x00434343)),
                                          'pd': PFun.lg(1, 1, 12, 12),
                                        });
                                        }
                                      ),
                                    ],
                                  )
                                ),
                              ),
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
                      return buildInfo(isMe);
                    }else if(index == 1){
                      return Obx(()=> controller.detailModel.value.skills.length > 0 ? _buildGames(context):Container());
                    }else if(index == 2){
                      return  _buildIntro();
                    }
                    return Container(height: 64);
                  },
                  childCount: 4
                )
              )
            ],
          )
        ),
        if(!isMe)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() {
                    return ColorfulButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(controller.detailModel.value.follow==1?Icons.remove_circle: Icons.add_circle,color: Colors.white,size: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,top: 4),
                            child: Text(
                             controller.detailModel.value.follow==1?"UnFollow": "Follow",
                              style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "din"),
                            ),
                          ),
                        ],
                      ),
                      height: 50,
                      width: 160,
                      onTap: () async {
                        if(controller.detailModel.value.follow==1){
                          controller.detailModel.value.follow=0;
                          controller.detailModel.value.fans--;
                        }else{
                          controller.detailModel.value.follow=1;
                          controller.detailModel.value.fans++;
                        }
                        controller.detailModel.refresh();
                        EasyLoading.show();
                        await http.get('/peiwan/app/user/attention/${controller.detailModel.value.userId}').then((v) {}).catchError((e) {
                          EasyLoading.showToast('Network exception');
                            if(controller.detailModel.value.follow==1){
                            controller.detailModel.value.follow=0;
                            controller.detailModel.value.fans--;
                          }else{
                            controller.detailModel.value.follow=1;
                            controller.detailModel.value.fans++;
                          }
                          controller.detailModel.refresh();
                        });
                        EasyLoading.dismiss();
                        flog(controller.detailModel.value.follow);
                      },
                    );
                  }
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
                  onTap: () async{
                    if(fromChat){
                      Get.back();
                      return;
                    }
                    var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
                    V2TimValueCallback<V2TimConversation> conv = await conversationManager.getConversation(conversationID: "c2c_${controller.detailModel.value.memberId}");
                    if(conv.data != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                            Chat(
                              selectedConversation: conv.data!,
                              orderSn: controller.detailModel.value.orderSn,
                            ),
                        ));
                    }
                  },
                )
              ],
            )
          ),
        )
      ],
    );
  }

  Widget buildInfo(bool isMe) {
    return Obx(() {
      var signature = controller.detailModel.value.signature;
      return Container(
          // height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: signature != '' ? 0 : 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Text("${controller.detailModel.value.name}",
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    SexAndAgeWidget(
                      age: '${controller.detailModel.value.age}',
                      sex: '${controller.detailModel.value.sex}',
                    ),
                    InkWell(
                      onTap: ()=>isMe?Get.toNamed(AppPages.Grade):null,
                        child: PlayLevelWidget(
                      level: '${controller.detailModel.value.userLevel}',
                      isauth: controller.detailModel.value.isauth,
                    ),),
                    Builder(
                      builder: (context) {
                        var language = controller.detailModel.value.language;
                        if(language=='')return SizedBox();
                        return PWidget.container(
                          PWidget.text('$language',[Colors.white,12]),
                          [null, null, Colors.white10],
                          {'pd': PFun.lg(2,2,8,8),'br': 56},
                        );
                      }
                    ),
                    PWidget.container(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white60,
                            size: 14,
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 100),
                            child: Text(
                              '${controller.detailModel.value.location.location()}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      [null, null, Colors.white10],
                      {'pd': PFun.lg(2, 2, 8, 8), 'br': 56},
                    )
                  ]),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => isMe
                        ? Get.toNamed(AppPages.AttentionTab,
                            arguments: Map()..['index'] = 0)
                        : null,
                    child: Text(
                      "Follows: ",
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ),
                  Text(
                    "${controller.detailModel.value.follows}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () => isMe
                        ? Get.toNamed(AppPages.AttentionTab,
                            arguments: Map()..['index'] = 1)
                        : null,
                    child: Text(
                      "Fans: ",
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ),
                 InkWell(
                   onTap: () => isMe
                       ? Get.toNamed(AppPages.AttentionTab,
                       arguments: Map()..['index'] = 1)
                       : null,
                   child:  Text(
                   "${controller.detailModel.value.fans}",
                   style: TextStyle(fontSize: 16, color: Colors.white),
                 ),)
                ],
              ),
              if(signature!='')
              Divider(color: Colors.white10,height: 24),
              if(signature!='') PWidget.text('${controller.detailModel.value.signature}',[Colors.white54,12],{'isOf': false}),
              if(signature!='') Divider(color: Colors.white10,height: 24),
            ],
          ),
        );
    });
  }

  Widget _buildGames(BuildContext context){
    return Obx((){
      List<Widget> items = [];
      for (var i = 0; i < controller.detailModel.value.skills.length; i++) {
      items.add(_buildGame(controller.detailModel.value.skills[i],i,context));
        
      }
    if(controller.detailModel.value.skills.length>2){
      if(!controller.isExpand.value){
        items = items.sublist(0,2);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("My Skills",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
          Container(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white12
            ),
            child: Column(
              children: items
            ),
          ),
          SizedBox(height: 8),
          if(controller.detailModel.value.skills.length>2)
          PWidget.container(
            PWidget.row([
              if(!controller.isExpand.value)
              ...List.generate(controller.detailModel.value.skills.length.clamp(0, 7), (i) {
                if(i<=1)return SizedBox();
                 var skill = controller.detailModel.value.skills[i];
                 return CachedNetworkImage(imageUrl: "${skill.thumb}?imageMogr2/thumbnail/!100p",width: 16,height: 16,fit: BoxFit.cover);
                }),
                PWidget.container(
                    PWidget.icon(controller.isExpand.value?Icons.keyboard_arrow_up_rounded: Icons.keyboard_arrow_down_rounded,[Colors.white54,20]),
                    [null, null, Colors.white12],
                    {'br': 56}
                ),
              ],'220'
            ),
            // PWidget.text(controller.isExpand.value?'stow': 'show all',[Colors.white54])
          [null, null, Colors.white10],
          {'fun': () {
            controller.isExpand.value=!controller.isExpand.value;
          },'wali':PFun.lg(0,0),'pd':8,'br': 56,
          },
          ),
          if(controller.detailModel.value.signature=='')
          SizedBox(height: 20,),
        ],
      ),
    );
    });
  }

  Widget _buildGame(SkillModel skillModel,int i,BuildContext context){
    var isOpen = skillModel.wswitch==1;
    return GestureDetector(
      onTap: () async {
        if(isMe){
          await Get.to(()=>AddGamePage({"id":skillModel.authId}));
          controller.onReady();
          return;
        }else if(isOpen){
        var res = await Get.to(()=>PlayOrder(liveUid: "${controller.detailModel.value.userId}", skillModel: skillModel,));
        flog('$res','Get.to(()=>PlayOrder');
        if(res != null){
          var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
          V2TimValueCallback<V2TimConversation> conv = await conversationManager.getConversation(conversationID: "c2c_${controller.detailModel.value.memberId}");
          if(conv.data != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  Chat(
                    selectedConversation: conv.data!,
                    orderSn: res,
                  ),
              ));
          }
        }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 124,
            decoration: BoxDecoration(
              color:skillModel.wswitch==0?Colors.white12: Color(0xFF7D00FF)
            ),
            child: Stack(
              children: [
                // Positioned.fill(left: -2,right: -2,top: -2,bottom: -2, child: CachedNetworkImage(imageUrl: "${skillModel.thumb}",width: double.infinity,fit: BoxFit.cover,alignment: Alignment.bottomCenter)),
                if(isOpen&&skillModel.background!='') Positioned.fill(child: CachedNetworkImage(imageUrl: "${skillModel.background}",fit: BoxFit.cover)),
                // BackdropFilter(filter: ImageFilter.blur(sigmaX: 8,sigmaY: 8),child: Container(
                // color: Color(0x007400FF),
                // ),),
                // Positioned.fill(child: PWidget.container(PWidget.boxh(0), {'gd': [
                //   PFun.cl2crGd(Color(0xff7400FF), Color(0xff7400FF).withOpacity(0)),
                //   PFun.cl2crGd(Color(0xFFFF4400), Color(0xFFFF4400).withOpacity(0)),
                // ][i%2]})),
                Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          CachedNetworkImage(imageUrl: "${skillModel.thumb}",width: 66,height: 66,fit: BoxFit.cover),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("${skillModel.name}",style: TextStyle(color: Colors.white,fontSize: 14),),
                                Text("${skillModel.level}",style: TextStyle(color: Colors.white54,fontSize: 12),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.asset("assets/images/ic_balance_money.webp",width: 18,height: 18,),
                                    SizedBox(width: 5,),
                                    Text("${skillModel.coin}",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                    Text(" / ${skillModel.unit}",style: TextStyle(color: Colors.white,fontSize: 12),),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          if(isOpen||isMe)
                           ColorfulButton(
                             child: Padding(
                               padding: const EdgeInsets.only(left: 20,right: 20,top: 2),
                               child: Text(
                               isMe?"Edit": "Order",
                                 style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "din"),
                               ),
                             ),
                             height: 30,
                           ),
                           SizedBox(height: 8),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                    PWidget.container(
                    PWidget.row([
                        OrdersAndStarWidget({
                           ///controller.detailModel.value
                           'orders':skillModel.orders,
                           'star':skillModel.star,
                        },bgColor: Colors.transparent,isTran: true),
                      PWidget.text('More',[Colors.white70]),
                      ],'231'),
                    {'pd':PFun.lg(0,8,8,8),'fun': () {
                      Get.to(()=>GameComment(skillModel,'${controller.detailModel.value.userId}'));
                    },},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(){
    return Obx((){
      return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("My Information",style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: "DIN"),),
          ////性别显示英文：Male，Female,other
          // _introItem("Gender","${{
          //   '0':'Male',
          //   '1':'Female',
          // }[controller.detailModel.value.sex.toString()]}"),
          // _introItem("Age",controller.detailModel.value.age.toString()),
          // if(controller.detailModel.value.imageList.isNotEmpty)
          // SizedBox(height: 16),
          // if(controller.detailModel.value.imageList.isNotEmpty||isMe)
            PWidget.row([
              PWidget.text('Personal photo wall',[Colors.white,18],{'ff':'DIN','exp': true}),
              if(controller.detailModel.value.imageList.isNotEmpty)
              PWidget.text('More',[Colors.white,16],{'ff':'DIN','pd': 8,'fun':() async {
                Get.to(()=>PhotoWallWidget(controller.detailModel.value.imageList,isPage: true));
              }}),
            ]),
          if(controller.detailModel.value.imageList.isNotEmpty)
            PhotoWallWidget(controller.detailModel.value.imageList,key: UniqueKey()),
          if(controller.detailModel.value.imageList.isEmpty)
            PWidget.container(
              PWidget.text(
                isMe? '${controller.detailModel.value.emptyAlbumDesc1}':'${controller.detailModel.value.emptyAlbumDesc2}',
                [Colors.white54],
                {'ct': true,'isOf': false},
              ),
              [null, null, Colors.white.withOpacity(0.05)],
              {
                'mg': PFun.lg(8),
                'br': 8,
                'pd': 24,
              }
            ),
        ],
      ),
    );
    });
  }

  Widget _introItem(String title, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        children: [
          Text("$title", style: TextStyle(fontSize: 12, color: Colors.white54),),
          Spacer(),
          Text("$value", style: TextStyle(fontSize: 14, color: Colors.white),),
        ],
      ),
    );
  }
}

class PlayDetailController extends GetxController {
  String userId;

  bool isMemberCode;

  late ScrollController scrollController;

  var titleColor = Colors.transparent.obs;

  var headerHeight = 0.0.obs;
  var isExpand=false.obs;

  Rx<PlayDetailModel> detailModel = PlayDetailModel().obs;

  PlayDetailController({required this.userId, required this.isMemberCode});

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
  void onReady() async {
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

    EasyLoading.show();
    detailModel.value = await ImApi.getPlayDetail(userId, isMemberCode);
    // if(detailModel.value.imageList.length != 0) {
      // detailModel.value.imageList.clear();
      // detailModel.value.imageList.add(
      //   "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F6020354b4960f27eab51c5005f4dfecb5007557e12e014-2vf4WP_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665099671&t=819cd5ffe0a6286cac0515d00681e361");
      // detailModel.value.imageList.add(
      //   "https://pics5.baidu.com/feed/a71ea8d3fd1f41343c411bba13c53dcdd3c85ee5.jpeg?token=ca8e4fac1efb35a98c56b83ca73bebd5");
      // detailModel.value.imageList.add(
      //   "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2F0%2Fde%2F6300ed8f12.jpg&refer=http%3A%2F%2Fpic1.win4000.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665099671&t=680fd115dad0fecb14f0eccebb3a52d3");
    // }
    // this.productDetailModel.value = await ShopApi.getProductDetail(id);
    // if(detailModel.value.avatar == "") {
    //   // detailModel.value.avatar =
    //   // "https://pics0.baidu.com/feed/9d82d158ccbf6c81ff60dec6d3b2443332fa40d8.jpeg?token=c04443f136e02e3712476a018e2694be";
    // }
    if(this.detailModel.value.imageList.isNotEmpty){
      this.detailModel.value.imageList.forEach((element) {
        DefaultCacheManager().downloadFile(element);
      });
    }
    EasyLoading.dismiss();
  }

  void initData(double headerHeight) async {
    this.headerHeight.value = headerHeight;

  }

  void changeTitleColor(Color titleColor) {
    this.titleColor.value = titleColor;
  }
}