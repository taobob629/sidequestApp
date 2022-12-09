import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/im/play_game_widget.dart';
import 'package:wy/ui/im/play_order.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/ui/playwith/game_comment.dart';
import 'package:wy/ui/playwith/photo_wall_widget.dart';
import 'package:wy/ui/playwith/play_profile_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/custom_scroll_physics.dart';
import 'package:wy/widget/expansion_tile.dart';
import 'package:wy/widget/my_bouncing_scroll_physics.dart';
import 'package:wy/widget/my_custom_scroll.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/photo_widget.dart';

import '../../api/im_api.dart';
import '../../config/app_color.dart';
import '../../model/play_detail_model.dart';
import '../common/dialog_confirm.dart';
import 'chat.dart';

class PlayDetailValue extends ValueNotifier{
  PlayDetailValue() : super(null);
  List<AnimationController> animationController = [];
}

PlayDetailValue playDetailValue = PlayDetailValue();

class PlayDetail extends StatefulWidget {

  final String userId;
  final String gId;
  final bool fromChat;
  final bool isMemberCode;
  late final PlayDetailController controller;

  PlayDetail({required this.userId, this.fromChat = false, this.isMemberCode = false,this.gId=''}){
    controller = Get.put(PlayDetailController(userId:userId,gId: gId, isMemberCode: isMemberCode),tag: userId);
  }

  @override
  State<PlayDetail> createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetail> with TickerProviderStateMixin {

  StreamSubscription<PlayDetailModel>? listen;
  
  ///自己视角
  bool isMe=false;

  @override
  void initState() {
  this.initData();
  super.initState();
  }
  
  ///初始化函数
  Future initData() async {
    this.initListenAndPump();
  }

  initListenAndPump(){
    playDetailValue.animationController.clear();
    listen= widget.controller.detailModel.listenAndPump((event) {
      if(event.skills.isNotEmpty && playDetailValue.animationController.isEmpty){
        flog(event.skills.length,'event.skills.length');
        var list = List.generate(event.skills.length, (i) {
          return AnimationController(duration: Duration(milliseconds: 300), vsync: this);
        });
        playDetailValue.animationController=list;
      }
    });
  }

  @override
  void dispose() {
    listen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
      .of(context)
      .size
      .width * 0.75;
    widget.controller.initData(width);
    isMe = widget.controller.userId==Get.find<UserController>().userInfoModel.value.pwuserId.toString();
    return Stack(
      children: [
        Scaffold(
            backgroundColor: AppColor.background,
            body: CustomScrollView(
              controller: widget.controller.scrollController,
              physics: MyBouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  backgroundColor: AppColor.background,
                  expandedHeight: width,
                  title: Obx(() {
                    return Text(
                      widget.controller.detailModel.value.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: widget.controller.titleColor.value, fontSize: 16),
                    );
                  }),
                  actions: [
                    if(isMe)
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if(isMe){
                              await Get.to(()=>PlayProfilePage());
                              widget.controller.onReady();
                              return;
                            }
                            Get.dialog(ConfirmDialog(
                              title: "Add Block List".tr,
                              info: "Do you want to add this person to black list?".tr,
                              confirmBtn: "CONFIRM".tr,
                              onConfirm: () async {
                                EasyLoading.show();
                                var friendshipManager = TencentImSDKPlugin.v2TIMManager.getFriendshipManager();
                                List<String> userIDList = [];
                                userIDList.add(widget.userId);
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
                            child: Text(
                              isMe ? "Edit".tr : "Block".tr,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
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
                            child: Obx(()=>widget.controller.detailModel.value.avatarThumb=='' ? Container(): Swiper(
                              autoplayDelay: 5000,
                              duration: 500,
                              itemBuilder: (BuildContext context, int index) {
                                String url = widget.controller.detailModel.value.avatarThumb;
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
                                                    child: Obx(()=>widget.controller.detailModel.value.avatar == "" ? Container():
                                                    CachedNetworkImage(
                                                      imageUrl: widget.controller.detailModel.value.avatar,
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
                                                  var isOnline = widget.controller.detailModel.value.online==1;
                                                  return PWidget.container(PWidget.text(isOnline ? 'Online'.tr : 'OffLine'.tr, [Colors.white, 10]), {
                                                    'gd': isOnline ? PFun.tl2brGd(Color(0xff5ADBAE), Color(0x005ADBAE)) : PFun.tl2brGd(Color(0xFF434343), Color(0x00434343)),
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
                            return Obx(()=> widget.controller.detailModel.value.skills.length > 0 ? _buildGames(context):Container());
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
            bottom: 10,
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
                            Icon(widget.controller.detailModel.value.follow==1?Icons.remove_circle: Icons.add_circle,color: Colors.white,size: 20,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 4),
                              child: Text(
                                widget.controller.detailModel.value.follow == 1 ? "UnFollow".tr : "Follow".tr,
                                style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "din"),
                              ),
                            ),
                          ],
                        ),
                        height: 50,
                        width: 160,
                        onTap: () async {
                          if(widget.controller.detailModel.value.follow==1){
                            widget.controller.detailModel.value.follow=0;
                            widget.controller.detailModel.value.fans--;
                          }else{
                            widget.controller.detailModel.value.follow=1;
                            widget.controller.detailModel.value.fans++;
                          }
                          widget.controller.detailModel.refresh();
                          EasyLoading.show();
                          await http.get('/peiwan/app/user/attention/${widget.controller.detailModel.value.userId}').then((v) {}).catchError((e) {
                            EasyLoading.showToast('Network exception');
                            if(widget.controller.detailModel.value.follow==1){
                              widget.controller.detailModel.value.follow=0;
                              widget.controller.detailModel.value.fans--;
                            }else{
                              widget.controller.detailModel.value.follow=1;
                              widget.controller.detailModel.value.fans++;
                            }
                            widget.controller.detailModel.refresh();
                          });
                          EasyLoading.dismiss();
                          flog(widget.controller.detailModel.value.follow);
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
                              "Message".tr,
                              style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "din"),
                            ),
                          ),
                        ],
                      ),
                      height: 50,
                      width: 160,
                      onTap: () async{
                        if(widget.fromChat){
                          Get.back();
                          return;
                        }
                        var conversationManager = TencentImSDKPlugin.v2TIMManager.getConversationManager();
                        V2TimValueCallback<V2TimConversation> conv = await conversationManager.getConversation(conversationID: "c2c_${widget.controller.detailModel.value.memberId}");
                        if(conv.data != null) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Chat(
                                      selectedConversation: conv.data!,
                                      orderSn: widget.controller.detailModel.value.orderSn,
                                    ),
                              ),
                          );
                          // this.initListenAndPump();
                          widget.controller.detailModel.value=PlayDetailModel();
                          widget.controller.detailModel.refresh();
                          widget.controller.onReady();
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
      var signature = widget.controller.detailModel.value.signature;
      return GestureDetector(
        onTap: () async {
           if(isMe){
              await Get.to(()=>PlayProfilePage());
              widget.controller.onReady();
              return;
            }
        },
        child: Container(
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
                      Text("${widget.controller.detailModel.value.name}",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      SexAndAgeWidget(
                        age: '${widget.controller.detailModel.value.age}',
                        sex: '${widget.controller.detailModel.value.sex}',
                      ),
                      PlayLevelWidget(
                        userId: widget.controller.userId,
                        level: '${widget.controller.detailModel.value.userLevel}',
                        isauth: widget.controller.detailModel.value.isauth,
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
                                '${widget.controller.detailModel.value.location.location()}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            ),
                          ],
                        ),
                        [null, null, Colors.white10],
                        {'pd': PFun.lg(2, 2, 8, 8), 'br': 56},
                      ),
                      Builder(
                        builder: (context) {
                          var language = widget.controller.detailModel.value.language;
                          if(language=='')return SizedBox();
                          return PWidget.container(
                            PWidget.text('$language',[Colors.white,12]),
                            [null, null, Colors.white10],
                            {'pd': PFun.lg(2,2,8,8),'br': 56},
                          );
                        }
                      )
                    ]),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => isMe
                        ? Get.toNamed(AppPages.AttentionTab, arguments: Map()..['index'] = 0)
                        : null,
                    child: Text(
                      "${'Follows'.tr}: ",
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ),
                    Text(
                      "${widget.controller.detailModel.value.follows}",
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
                        "${'Fans'.tr}: ",
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                    ),
                   InkWell(
                     onTap: () => isMe
                         ? Get.toNamed(AppPages.AttentionTab,
                         arguments: Map()..['index'] = 1)
                         : null,
                     child:  Text(
                     "${widget.controller.detailModel.value.fans}",
                     style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                   ),
                  SizedBox(
                    width: 30,
                  ),
                  if(widget.controller.detailModel.value.orders>0)
                    InkWell(
                    child: Text(
                      "${'Services'.tr}: ",
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ),
                  if(widget.controller.detailModel.value.orders>0)
                  Text(
                    "${widget.controller.detailModel.value.orders}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  if(widget.controller.detailModel.value.orders>0)
                    SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    child: Text(
                      "${'Rating'.tr}: ",
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ),
                  Text(
                    "${widget.controller.detailModel.value.mark}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
                  ],
                ),
                if(signature!='')
                Divider(color: Colors.white10,height: 24),
                if(signature!='') PWidget.text('${widget.controller.detailModel.value.signature}',[Colors.white54,12],{'isOf': false}),
                if(signature!='') Divider(color: Colors.white10,height: 24),
              ],
            ),
          ),
      );
    });
  }

  Widget _buildGames(BuildContext context){
    return Obx((){
      List<Widget> items = [];
      for (var i = 0; i < widget.controller.detailModel.value.skills.length; i++) {
        items.add(_buildGame(widget.controller.detailModel.value.skills[i],i,context));
      }
    if(widget.controller.detailModel.value.skills.length>2){
      if(!widget.controller.isExpand.value){
        items = items.sublist(0,2);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              "Services".tr,
              style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "DIN"),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white12),
              child: Column(children: items),
            ),
          SizedBox(height: 8),
          if(widget.controller.detailModel.value.skills.length>2)
          PWidget.container(
            PWidget.row([
              if(!widget.controller.isExpand.value)
              ...List.generate(widget.controller.detailModel.value.skills.length.clamp(0, 7), (i) {
                if(i<=1)return SizedBox();
                 var skill = widget.controller.detailModel.value.skills[i];
                 return CachedNetworkImage(imageUrl: "${skill.thumb}?imageMogr2/thumbnail/!100p",width: 16,height: 16,fit: BoxFit.cover);
                }),
                PWidget.container(
                    PWidget.icon(widget.controller.isExpand.value?Icons.keyboard_arrow_up_rounded: Icons.keyboard_arrow_down_rounded,[Colors.white54,20]),
                    [null, null, Colors.white12],
                    {'br': 56}
                ),
              ],'220'
            ),
            // PWidget.text(controller.isExpand.value?'stow': 'show all',[Colors.white54])
          [null, null, Colors.white10],
          {'fun': () {
            widget.controller.isExpand.value=!widget.controller.isExpand.value;
          },'wali':PFun.lg(0,0),'pd':8,'br': 56,
          },
          ),
          if(widget.controller.detailModel.value.signature=='')
          SizedBox(height: 20,),
        ],
      ),
    );
    });
  }

  Widget _buildGame(SkillModel skillModel,int i,BuildContext context){
    return PlayGameWidget(skillModel,widget.controller,i);
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
              PWidget.text('${'Album'.tr} ', [Colors.white, 18], {'ff': 'DIN', 'exp': true}),
              if (widget.controller.detailModel.value.imageList.isNotEmpty)
                PWidget.text('More'.tr, [
                  Colors.white,
                  16
                ], {
                  'ff': 'DIN',
                  'pd': 8,
                  'fun': () async {
                    Get.to(() => PhotoWallWidget(widget.controller.detailModel.value.imageList, isPage: true));
                  }
                }),
            ]),
          if(widget.controller.detailModel.value.imageList.isNotEmpty)
            PhotoWallWidget(widget.controller.detailModel.value.imageList,key: UniqueKey()),
          if(widget.controller.detailModel.value.imageList.isEmpty)
            PWidget.container(
              PWidget.text(
                isMe? '${widget.controller.detailModel.value.emptyAlbumDesc1}':'${widget.controller.detailModel.value.emptyAlbumDesc2}',
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
          PWidget.boxh(12),
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
  String gId;

  bool isMemberCode;

  late ScrollController scrollController;

  var titleColor = Colors.transparent.obs;

  var headerHeight = 0.0.obs;
  var isExpand=false.obs;

  Rx<PlayDetailModel> detailModel = PlayDetailModel().obs;

  PlayDetailController({required this.userId, required this.isMemberCode,this.gId=''});

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
    detailModel.value = await ImApi.getPlayDetail(userId, gId, isMemberCode);
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