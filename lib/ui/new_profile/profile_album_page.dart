import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileAlbumPage extends StatelessWidget {
  const ProfileAlbumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// dashboard
            Container(
              height: 62,
              margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              decoration: BoxDecoration(
                color: Color(0xff313033),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _dashboardLabelItem("assets/images/ic_wallet.webp", "Wallet", () {
                    //
                  }),
                  _dashboardLabelItem("assets/images/ic_wallet.webp", "Bookings", () {
                    //
                  }),
                  _dashboardLabelItem("assets/images/ic_wallet.webp", "Activities", () {
                    //
                  }),
                  _dashboardLabelItem("assets/images/ic_dialog.webp", "Sidekick", () {
                    //
                  }),
                ],
              ),
            ),

            ///
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 38),
                    child: Text(
                      "Subscriptions",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: 48,
                    margin: EdgeInsets.only(top: 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [subscriptionItem(), subscriptionItem(), subscriptionItem(), subscriptionItem()],
                    ),
                  )
                ],
              ),
            ),

            ///

            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 38),
                    child: Text(
                      "Trophies",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xff313033),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 6,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      padding: EdgeInsets.zero,
                      children: [
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                        Image.asset(
                          "assets/images/default_logo.webp",
                          width: 36,
                          height: 36,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  dashboardLabels() {}

  Widget _dashboardLabelItem(String imageName, String title, Function()? onTap) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              // "assets/images/ic_wallet.webp",
              imageName,
              color: Color(0XffFDD51B),
              width: 26,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            )
          ],
        ),
      ),
    );
  }

  Widget subscriptionItem() {
    return Container(
      width: 128.w,
      height: 48,
      margin: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(border: Border.all(color: Color(0xff707070), width: 1.5), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.asset(
              "assets/images/ic_dialog.webp",
              color: Color(0XffFDD51B),
              width: 26,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Silver",
            style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Container(
            width: 50,
            height: 20,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF632BDA), Color(0xFF6029D4), Color(0xFF652CDF), Color(0xFF7231DE), Color(0xFF8A39DE), Color(0xFFBE38D0), Color(0xFFDE5D85), Color(0xFFE68887)]),
            ),
            alignment: Alignment.center,
            child: Text(
              "£19.99",
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
