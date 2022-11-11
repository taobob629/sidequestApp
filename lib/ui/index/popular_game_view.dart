import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/game_model.dart';

class PopularGameView extends StatelessWidget {

  final GameModel game;
  final bool last;
  final int index;

  PopularGameView({required this.game, required this.index, this.last = false});

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 40)/2;
    double height = width * 260 / 190;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height,
                width: width,
                margin: EdgeInsets.only(right: last ? 0.0:10.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: game.image,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(game.name, style: TextStyle(fontSize: 16, fontFamily: "din", color: Colors.white),),
              ),
              Row(
                children: _buildStars(),
              )
            ],
          ),
          Positioned(
            right: last? 0:10,
            top: 0,
            child: ClipPath(
              clipper: _TrapezoidPath(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10))
                ),
                padding: const EdgeInsets.only(top: 10,left: 6),
                child: Transform.rotate(
                  angle: pi / 4,
                  child: Text(
                    "${'Top'.tr}$index",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildStars(){
    List<Widget> stars = [];
    if(game.stars == 0){
      game.stars = 5;
    }
    for(int i = 0; i < game.stars; i++){
      stars.add(Icon(Icons.star, color: Colors.yellow, size: 18,));
    }
    return stars;
  }
}

class _TrapezoidPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);//x,y坐标
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}