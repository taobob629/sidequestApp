import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wy/model/match_item_model.dart';
import 'package:wy/ui/events/event/event_page.dart';

class MatchItem extends StatelessWidget {

  final MatchItemModel model;
  final bool joined;

  MatchItem({required this.model, this.joined = false});

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.width - 30) * 8 / 34;
    return GestureDetector(
      onTap: ()=>Get.to(()=>EventPage(id: model.id, type: 2, joined: joined,)),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.only(bottom: 0),
        margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Color(0xFF28253D)
        ),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 34/8,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(13),topRight: Radius.circular(13)),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: model.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: height,
                ),
                _buildMatchInfo(),
                SizedBox(width: 10,height: 15,),
                //_buildJoinInfo()
              ],
            ),
            // Positioned(
            //   right: 10,
            //   top: height-6,
            //   child: Container(
            //     width: 60,
            //     height: 70,
            //     child: CustomPaint(
            //       painter: FlagPainter(),
            //       child: Padding(
            //         padding: const EdgeInsets.only(bottom: 20,top: 1,left: 1,right: 1),
            //         child: Container(
            //           clipBehavior: Clip.antiAlias,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(topLeft: Radius.circular(2),topRight: Radius.circular(2))
            //           ),
            //           child: CachedNetworkImage(
            //             imageUrl: model.flag,
            //             fit: BoxFit.cover,
            //           ),
            //           width: 60,
            //         )
            //       ),
            //     ),
            //   ),
            // )
            Positioned(
              right: 10,
              top: height-6,
              child: Container(
                width: 60,
                height: 70,
                child: CachedNetworkImage(
                  imageUrl: model.flag,
                  fit: BoxFit.cover,
                ),
              )
            )
          ],
        )
      ),
    );
  }

  Widget _buildMatchInfo(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model.title}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.white,fontSize: 16),
                ),
                SizedBox(width: 10,height: 15,),
                Row(
                  children: [
                    SvgPicture.asset("assets/images/ic_match_time.svg",color: Color(0xFF7D8AAC)),
                    SizedBox(width: 10,height: 8,),
                    Text("Time: ${model.time}", style: TextStyle(color: Color(0xFF7C8AAD),fontSize: 12),)
                  ],
                ),
                // SizedBox(width: 10,height: 8,),
                // Row(
                //   children: [
                //     SvgPicture.asset("assets/images/ic_match_gift.svg",color: Color(0xFF7D8AAC)),
                //     SizedBox(width: 10,height: 8,),
                //     Text("Bonus pool: £2000", style: TextStyle(color: Color(0xFF7C8AAD),fontSize: 12),)
                //   ],
                // ),
                SizedBox(width: 10,height: 8,),
                Row(
                  children: [
                    SvgPicture.asset("assets/images/ic_match_location.svg",color: Color(0xFF7D8AAC)),
                    SizedBox(width: 10,height: 8,),
                    Text("Location: ${model.location}", style: TextStyle(color: Color(0xFF7C8AAD),fontSize: 12),)
                  ],
                ),
                SizedBox(width: 10,height: 8,),
                Row(
                  children: [
                    SvgPicture.asset("assets/images/ic_match_o_people.svg",width:16,color: Color(0xFF7D8AAC)),
                    SizedBox(width: 10,height: 8,),
                    Text("Quota: ${model.totalMembers}", style: TextStyle(color: Color(0xFF7C8AAD),fontSize: 12),)
                  ],
                ),
              ],
            ),
          ),
          Container(width: 60,height: 80,)
        ],
      )
    );
  }

  Widget _buildJoinInfo(){
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      color: Color(0x08ffffff),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildAvatar(),
                Positioned(
                  left: 18,
                  child: _buildAvatar()
                ),
                Positioned(
                  left: 36,
                  child: _buildAvatar()
                ),
                Positioned(
                  left: 52,
                  child: _buildAvatar()
                ),
                Positioned(
                  left: 68,
                  child: _buildMore()
                )
              ],
            ),
          ),
          Text("4/12", style: TextStyle(color: Color(0xFF7D8AAC),fontSize: 12),)
        ],
      ),
    );
  }

  Widget _buildAvatar(){
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 12,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ClipOval(
          child: Image.network(
            "https://img0.baidu.com/it/u=93781859,2669607760&fm=15&fmt=auto",
            fit: BoxFit.cover,
          ),
        ),
      )
    );
  }

  Widget _buildMore(){
    return CircleAvatar(
      backgroundColor: Color(0xFFFF6800),
      radius: 12,
      child: Center(
        child: Text("+12",style: TextStyle(color: Colors.white,fontSize: 10),),
      )
    );
  }
}


class FlagPainter extends CustomPainter{

  Paint _paint = Paint()
    ..color = Colors.white
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rectLeft = Rect.fromLTWH(0, 0, 5, 5);
    Rect rectRight = Rect.fromLTWH(55, 0, 5, 5);
    Path path = Path()
      ..moveTo(5, 0)
      ..lineTo(55, 0)
      ..arcTo(rectRight, 3*pi/2, pi/2, false)
      ..lineTo(60, 70)
      ..lineTo(30, 55)
      ..lineTo(0, 70)
      ..lineTo(0, 5)
      ..arcTo(rectLeft, pi, pi/2, false);
      canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}