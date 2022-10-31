import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/data_model.dart';
import 'package:wy/model/play_detail_model.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/anima_switch_widget.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

///技能评价
class GameComment extends StatefulWidget {
  final SkillModel skillModel;
  final String liveId;
  const GameComment(this.skillModel, this.liveId, {Key? key}) : super(key: key);
  @override
  _GameCommentState createState() => _GameCommentState();
}

class _GameCommentState extends State<GameComment> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.comments(isRef: true);
  }

  ///技能列表
  var commentsDm = DataModel();
  Future<int> comments({int page = 1, bool isRef = false}) async {
    await http.get('/peiwan/app/home/comments/${widget.skillModel.id}?liveId=${widget.liveId}').then((res) async {
      var list = (res.data ?? []) as List;
      commentsDm.addList(list, isRef, 0);
    }).catchError((e) {
      commentsDm.toError(e.toString());
    });
    setState(() {});
    flog(commentsDm.toJson());
    return commentsDm.flag;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(title: Text('Comments'),elevation: 0),
      body: AnimatedSwitchBuilder<dynamic>(
        value: commentsDm,
        errorOnTap: () => this.comments(),
        listBuilder: (list, p, h) {
          return MyListView(
            isShuaxin: false,
            flag: false,
            padding: EdgeInsets.all(12),
            divider: Divider(color: Colors.transparent),
            item: (i) {
              return PWidget.container(
                PWidget.column([
                  PWidget.row([
                    PWidget.text(list[i]['user'], [Colors.white, 16], {'exp': true}),
                    FFStars(
                      normalStar: Image.asset("assets/images/play/score0.png"),
                      selectedStar: Image.asset("assets/images/play/score1.png"),
                      justShow: true,
                      step: 0.01,
                      defaultStars: list[i]['star'],
                      starHeight: 16,
                      starWidth: 16,
                      starMargin: 8,
                    ),
                  ]),
                  PWidget.boxh(8),
                  PWidget.text(list[i]['content'], [Colors.white], {'isOf': false}),
                  PWidget.boxh(8),
                  PWidget.row([
                    PWidget.text(list[i]['time'], [Colors.white54], {'isOf': false})
                  ], '111'),
                ]),
                [null, null, Colors.white.withOpacity(0.05)],
                {'pd': 12, 'br': 8},
              );
            },
            itemCount: list.length,
            listViewType: ListViewType.Separated,
          );
        },
      ),
    );
  }
}
