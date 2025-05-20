import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geministate/controllers/home_controller.dart';
import 'package:geministate/services/http_service.dart';
import 'package:get/get.dart';

import '../models/gemini_talk_model.dart';
import '../models/message_model.dart';
import '../services/log_service.dart';
import '../services/utils_service.dart';
import '../widgets/item_of_gemini_message.dart';
import '../widgets/item_of_user_message.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<HomeController>(
        builder: (_){
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 45,
                  child: Image(
                    image: AssetImage('assets/images/gemini_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      var message = controller.messages[index];
                      if (message.isMine!) {
                        return itemOfUserMessage(message);
                      } else {
                        return itemOfGeminiMessage(message);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey, width: 1.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Picked Image

                      controller.pickedImage64 != null
                          ? Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                base64Decode(controller.pickedImage64!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white)),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    controller.removePickedImage();
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                ),
                              )),
                        ],
                      )
                          : SizedBox.shrink(),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.textController,
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Message",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.pickImageFromGallery();
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.askToGemini();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

}
