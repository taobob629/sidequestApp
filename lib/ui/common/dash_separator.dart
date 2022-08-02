import 'package:flutter/material.dart';

class DashSeparator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Row(
          children: _buildItem(),
        ),
      ),
    );
  }

  List<Widget> _buildItem(){
    List<Color> colors = [Color(0xFF3B91FF),Color(0xFFFF3B62)];
    List<Widget> list = [];
    for(int i = 0; i < 20; i++){
      list.add(
        ClipPath(
          clipper: _TrapezoidPath(),
          child: Container(
            width: 25,
            color: colors[i%2]
          ),
        )
      );
      list.add(SizedBox(width: 6,));
    }
    return list;
  }
}

class _TrapezoidPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);//x,y坐标
    path.lineTo(10, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width-10, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}