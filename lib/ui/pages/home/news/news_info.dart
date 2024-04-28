import 'package:flutter/material.dart';

class NewsInfo extends StatelessWidget {


  late final List<String> infoList;

  NewsInfo(String content){
    infoList = content.split(",");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,top: 20,right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildInfoList()
      ),
    );
  }

  List<Widget> _buildInfoList(){
    List<Widget> list = [];
    for(String content in infoList){
      list.add(Text(content, style: TextStyle(fontSize: 12, color: Colors.white54),));
    }
    return list;
  }
}