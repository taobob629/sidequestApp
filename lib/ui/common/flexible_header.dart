import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wy/config/app_color.dart';

class FlexibleHeader extends StatelessWidget {

  final String image;

  FlexibleHeader({required this.image});

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            )
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColor.background]
                )
              ),
            )
          )
        ],
      )
    );
  }
}