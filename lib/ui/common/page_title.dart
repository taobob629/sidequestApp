import 'package:flutter/material.dart';
import 'package:wy/config/icon_font.dart';

class PageTitle extends StatelessWidget {

  final String title;
  final Color color;

  PageTitle({
    required this.title,
    this.color = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        fontFamily: FONT_MEDIUM,
        color: color
      ),
    );
  }
}