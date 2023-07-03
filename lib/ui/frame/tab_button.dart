import 'package:flutter/material.dart';

class TabButton extends StatefulWidget {
  final int index;
  final int currentIndex;
  final String iconName;
  final Function onTap;
  final List<Color> colors;
  final String title;

  TabButton({
    required this.index,
    required this.currentIndex,
    required this.title,
    required this.iconName,
    required this.colors,
    required this.onTap
  });

  @override
  State createState() => _TabButtonState();
}

class _TabButtonState extends State<TabButton> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: ()=>widget.onTap.call(),
      child: Container(
        width: 50,
        height: widget.index == widget.currentIndex ? 80 : 50,
        child: Stack(
          children: createIcon(),
        ),
      ),
    );
  }

  List<Widget> createIcon(){
    List<Widget> icons = [];

    // Widget icon = SvgPicture.asset("assets/images/ic_tab_${widget.iconName}.svg");
    // Widget iconLight = SvgPicture.asset("assets/images/ic_tab_${widget.iconName}_light.svg",color: Colors.white,);
    Widget icon = Image.asset("assets/images/${widget.iconName}.png",width: 28, fit: BoxFit.contain,);

    if(widget.index == widget.currentIndex){
      Container bgColorContainer = Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.8, -0.8), //中心点偏移量,x和y均为0.0表示在正中心位置
            radius: 2,
            stops: [0.1,1.0],
            colors: widget.colors
          ),
          borderRadius: BorderRadius.all(Radius.elliptical(25, 25))
        ),
      );
      icons.add(bgColorContainer);

      Column column = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Icon(
          //   widget.icon,
          //   size: 26,
          //   color: widget.index == widget.currentIndex ? Colors.white : Colors.grey,
          // ),
          icon,
          Text(widget.title, style: TextStyle(color: Colors.white,fontSize: 10),)
        ],
      );
      icons.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: column),
        )
      );
    }else{
      icons.add(
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          color: Colors.transparent,
          // child: Icon(
          //   widget.icon,
          //   size: 26,
          //   color: widget.index == widget.currentIndex ? Colors.white : Colors.grey,
          // ),
          child: icon
        )
      );
    }
    return icons;
  }
}