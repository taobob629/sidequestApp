import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/dialog_pop_ad.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/index/tab_games_page.dart';
import 'package:wy/ui/index/tab_headlines_page.dart';
import 'package:wy/ui/index/tab_news_page.dart';
import 'package:wy/ui/login/qr_login_page.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/ui/profile/booking/booking_page.dart';
import 'package:wy/ui/scan/scan_page.dart';
import 'package:wy/utils/permission_helper.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../store/store_page.dart';

class IndexPage extends StatelessWidget {

  final controller = Get.put(IndexPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      TabBar(
                        controller: controller.tabController,
                        isScrollable: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white38,
                        indicatorColor: Colors.white38,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: HomeIndicator(),
                        indicatorWeight: 4,
                        indicatorPadding: EdgeInsets.only(bottom: 5),
                        labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                        labelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
                        unselectedLabelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
                        tabs: createTabs(),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: ()=>userController.checkLogin(()=>Get.to(()=>BookingPage())),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10,right: 4),
                          child: Image.asset("assets/images/ic_store.png",width: 27,height: 27,fit: BoxFit.contain,),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          userController.checkLogin(() async{
                            bool access = await PermissionHelper.requestCameraPermission(context);
                            if(access){
                              controller.scan();
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10,right: 5),
                          child: Icon(IconFonts.scan,size: 22,color: Colors.white,),
                        ),
                      ),
                      /*
                      GestureDetector(
                        onTap: ()=>NavigatorHelper.gotoSearchPage(),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10,right: 4),
                          child: Icon(IconFonts.search,size: 26,color: Colors.white,),
                        ),
                      )*/
                    ],
                  ),
                )
              ],
            )
          ),
        )
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: createPages()
      ),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Recommend".tr,
    ));
    tabs.add(Text(
      "News".tr,
    ));
    tabs.add(Text(
      "Games".tr,
    ));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: TabHeadlinesPage()));
    pages.add(KeepAliveWrapper(child: TabNewsPage()));
    pages.add(KeepAliveWrapper(child: TabGamesPage()));
    return pages;
  }

  String decryptData(String data){
    final key = encrypt.Key.fromUtf8('my 32 length key.......sidequest');
    final iv = encrypt.IV.fromLength(16);
    final encryptMaker = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    encrypt.Encrypted encrypted = encrypt.Encrypted.fromBase64(data);
    return encryptMaker.decrypt(encrypted,iv: iv);
  }

  void encryptData(String data){
    final key = encrypt.Key.fromUtf8('my 32 length key.......sidequest');
    final iv = encrypt.IV.fromLength(16);
    final encryptMaker = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    final encrypted = encryptMaker.encrypt(data, iv: iv);
  }
}

class IndexPageController extends GetxController with SingleGetTickerProviderMixin{
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void scan(){
    Get.to(()=>ScanPage())?.then((value) {
      log("scan->$value");
      if(value == null){
        return;
      }
      String data = value.toString();
      //String deData = decryptData(data);

      if(data.indexOf("qlogin") >= 0){
        Get.to(()=>QrLoginPage(code: data,));

        return;
      }
      if(data == "Eb13IPoTrQ2uJNr/sAA70A=="){// Eb13IPoTrQ2uJNr/sAA70A==  page:balance
        Get.to(()=>BalancePage());
        return;
      }
    });
  }

}