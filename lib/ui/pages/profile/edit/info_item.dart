import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {

  final String title;
  final String detail;

  InfoItem({
    required this.title,
    required this.detail
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white,fontSize: 14),),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(detail, style: TextStyle(color: Colors.white38,fontSize: 12),),
          ),
        ],
      ),
    );
  }
}