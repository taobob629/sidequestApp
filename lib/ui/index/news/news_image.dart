import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget {
  final String content;

  NewsImage(this.content);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15,top: 20,right: 15),
      child: Image.network(content,fit: BoxFit.fitHeight,),
    );
  }
}