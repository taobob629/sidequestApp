import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

// 游戏评分页面
class GameScorePage extends StatefulWidget {
  @override
  _GameScorePageState createState() => _GameScorePageState();
}

class _GameScorePageState extends State<GameScorePage> {
  var score = 0.0;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      btnBar: FloatingButton(
        label: "￡10.99/30min",
        onTap: () {},
      ),
      body: Stack(
        children: [
          gradientBgView(),
          PWidget.column([
            AppBar(
              title: Text('game', style: TextStyle(fontSize: 18)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: MyListView(
                isShuaxin: false,
                flag: false,
                item: (i) => item[i],
                itemCount: item.length,
                padding: EdgeInsets.only(top: 8),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  List<Widget> get item {
    return [
      PWidget.container(
        ClipOval(
          child: CachedNetworkImage(imageUrl: 'https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1662501907981.jpg', width: 84, height: 84),
        ),
        {'wali': PFun.lg(0, 0), 'br': 84, 'crr': 84, 'bd': PFun.bdAllLg(Colors.white, 2)},
      ),
      PWidget.text('Nick Name', [Colors.white, 20, true], {'ct': true, 'pd': PFun.lg(8, 8)}),
      PWidget.row([
        PWidget.container(PWidget.text(score, [Colors.white, 30, true], {'ff': 'DIN', 'pd': PFun.lg(4)}), [56], {'ali': PFun.lg(0, 0)}),
        FFStars(
          normalStar: Image.asset("assets/images/play/score0.png"),
          selectedStar: Image.asset("assets/images/play/score1.png"),
          starsChanged: (realStars, selectedStars) {
            setState(() => score = realStars);
            print("real: $selectedStars, final: $realStars");
          },
          step: 0.01,
          // defaultStars: 4.3,
          starHeight: 20,
          starWidth: 20,
          starMargin: 16,
          followChange: true,
        ),
      ], '221'),
      PWidget.text('“Very Good”', [Colors.white, 20, true], {'ct': true, 'pd': PFun.lg(8, 8)}),
      PWidget.text('Leaving a message：', [Colors.white, 20, true], {'ff': 'DIN', 'pd': 16}),
      TextEnterWidget(),
    ];
  }

  Widget gradientBgView() {
    return Positioned.fill(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff490A93), Color(0xFF0E051C), Color(0xff171525)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}

///文本输入小部件
class TextEnterWidget extends StatefulWidget {
  final Function(String)? fun;

  const TextEnterWidget({Key? key, this.fun}) : super(key: key);
  @override
  _TextEnterWidgetState createState() => _TextEnterWidgetState();
}

class _TextEnterWidgetState extends State<TextEnterWidget> {
  TextEditingController textCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.column([
        buildTFView(
          context,
          hintText: 'If you have any comments on this order, or want to say any questions and comments, you can mention them here',
          maxLines: 10,
          maxLength: 150,
          height: 146,
          hintColor: Color(0xff7E91B7),
          textColor: Colors.white,
          con: textCon,
          onChanged: (v) {
            widget.fun!(v);
            setState(() {});
          },
        ),
        PWidget.boxh(8),
        PWidget.row([
          PWidget.text('${textCon.text.length}/150', [Colors.white, 14])
        ], '111'),
      ]),
      [null, null, Color(0xffF5F5F5).withOpacity(0.1)],
      {'br': 12, 'pd': 16, 'mg': PFun.lg(0, 0, 16, 16)},
    );
  }
}
