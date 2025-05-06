import 'package:flutter/material.dart';
import 'package:geministate/pages/home_page.dart';
import 'package:video_player/video_player.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  late VideoPlayerController videoPlayerController;

  _callHomePage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const HomePage();
    }));
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset("assets/videos/gemini_video.mp4")
          ..initialize().then((_) {
            setState(() {});
          });
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              width: 150,
              child: Image(
                image: AssetImage("assets/images/gemini_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: videoPlayerController.value.isInitialized
                  ? VideoPlayer(videoPlayerController)
                  : SizedBox.shrink(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _callHomePage();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Chat with Gemini ',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 18),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
