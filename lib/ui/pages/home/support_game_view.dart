import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../../../model/game_model.dart';

class SupportGameView extends StatelessWidget {
  final GameModel game;

  SupportGameView({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: ExtendedImage.network(
                game.image,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(color: Color(0xCF1F1D30)),
                  child: Center(
                      child: Text(game.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "din",
                              color: Colors.white))),
                )
              ],
            ),
          ],
        ));
  }
}
