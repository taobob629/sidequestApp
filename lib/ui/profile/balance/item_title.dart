import 'package:flutter/material.dart';

class ItemTitle extends StatelessWidget {

  final String title;
  final String subTitle;

  ItemTitle({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white,fontFamily: "DIN",fontSize: 20),),
          Text(subTitle, style: TextStyle(color: Colors.white54,fontFamily: "DIN",fontSize: 18),)
        ],
      )
    );
  }
}