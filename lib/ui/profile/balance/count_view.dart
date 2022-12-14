import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountView extends StatelessWidget {

  final String icon;
  final String title;
  final String count;
  final String customIcon;

  CountView({
    required this.icon,
    required this.title,
    required this.count,
    this.customIcon = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white,fontFamily: "DIN",fontSize: 18),),
          SizedBox(height: 5,),
          Row(
            children: [
              Image.asset(
                customIcon.isNotEmpty ? customIcon : "assets/images/ic_balance_$icon.webp",
                width: 30,
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 5),
                child: Text(
                  count,
                  style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 34),
                ),
              ),
              icon == "time"
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 5),
                      child: Text(
                        "mins".tr,
                        style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 22),
                      ),
                    )
                :Container()
            ],
          )
        ],
      ),
    );
  }
}