import 'package:flutter/material.dart';

class NewsTitle extends StatelessWidget {
  final String content;

  NewsTitle(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,right: 15,top: 5),
      child: Text(content, style: TextStyle(fontSize: 24,color: Colors.white),),
    );
  }
}