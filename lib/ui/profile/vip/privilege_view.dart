import 'package:flutter/material.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/expansion_tile.dart';
import 'package:wy/widget/paixs_widget.dart';

class PrivilegeView extends StatelessWidget {
  final String content;
  final String title;
  final int index;
  final int showIndex;
  final Function(int) onTap;
  final Key? key;

  PrivilegeView({
    required this.title,
    required this.content,
    required this.index,
    required this.showIndex,
    required this.onTap,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: ExpansionTileWidget(
        title: Row(children: [
          Image.asset(
            "assets/images/ic_privilege1.webp",
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              "$title",
              maxLines: 2,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontFamily: "DIN", color: Color(0xFFEFC887)),
            ),
          ),
        ]),
        expandViewBuilder: (anima) {
          flog(anima.status);
          return PWidget.row([
            PWidget.text(anima.isCompleted ? 'Up' : 'More', [Colors.white, 12]),
            PWidget.boxw(8),
            PWidget.container(
              RotationTransition(
                turns: anima,
                child: bottomJtView(12, Colors.black),
              ),
              [16, 16, Colors.white],
              {'br': 16},
            ),
          ]);
        },
        onExpansionChanged: (v) => this.onTap.call(this.index),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 55, right: 10),
            child: Text(
              "$content",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
      // child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     GestureDetector(
      //       onTap: () => this.onTap.call(this.index),
      //       child: Row(
      //         children: [
      //           Image.asset(
      //             "assets/images/ic_privilege1.webp",
      //             width: 40,
      //             height: 40,
      //             fit: BoxFit.contain,
      //           ),
      //           SizedBox(
      //             width: 15,
      //           ),
      //           Expanded(
      //             child: Text(
      //               "$title",
      //               maxLines: 2,
      //               textAlign: TextAlign.left,
      //               style: TextStyle(fontSize: 18, fontFamily: "DIN", color: Color(0xFFEFC887)),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.only(left: 55, right: 10),
      //       child: Text(
      //         "$content",
      //         textAlign: TextAlign.left,
      //         style: TextStyle(fontSize: 14, color: Colors.white),
      //       ),
      //     ),
      //     Container(
      //       margin: const EdgeInsets.only(top: 15),
      //       height: 1,
      //       color: Colors.white12,
      //     )
      //   ],
      // ),
    );
  }
}
