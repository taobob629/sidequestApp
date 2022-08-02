import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/base_scaffold.dart';

class AboutPage extends StatelessWidget {

  final controller = Get.put(AboutPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "About us",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Text(
                "SideQuest is dedicated to being the social hub for gamers. SideQuest is more than just entertainment and games— it's about fresh experiences and community.",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "In the modern era of rapid technological and virtual development, we need to find a place for all gamers and the new generation to connect to the real world from the virtual. SideQuest Gamers Hub, on the other hand, starts with the gamer's experience and prioritises everything with the gamer's needs in mind, offering the best services, popular games and diverse social experiences.",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "We use the central control technology by operating the computer from the server room and connecting the perfect ecology of all systems through the mobile phone APP. In this way, players can enjoy everything that is so simple and convenient. Our offline store is divided into 5 areas: public area, duo room, private room, battle room and viewing area. Whether you're alone, as a couple, in a team, or just want to watch the game live with friends, at SideQuest you'll always feel part of something bigger.",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "SideQuest is a metamorphosis of the original Wanyoo UK team. The game shouldn't be about, colour, language, nationality. The world of gamers is diverse, rich and colourful. We open our doors to all gamers with a sense of reverence for the world of gaming.",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

class AboutPageController extends GetxController {
  Future<void> initData() async{

  }
}