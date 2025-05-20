import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../pages/home_page.dart';

class StarterController extends GetxController {
  late VideoPlayerController videoPlayerController;

  callHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const HomePage();
    }));
  }

  initVideoPlayer() {
    videoPlayerController =
    VideoPlayerController.asset("assets/videos/gemini_video.mp4")
      ..initialize().then((_) {
        update();
      });
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  exitVideoPlayer() {
    videoPlayerController.dispose();
  }
}