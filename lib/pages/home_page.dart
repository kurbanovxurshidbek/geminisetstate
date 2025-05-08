import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geministate/services/http_service.dart';

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
  TextEditingController textController = TextEditingController();
  List<MessageModel> messages = [];
  String? pickedImage64;

  void pickImageFromGallery() async {
    var result = await Utils.pickAndConvertImage();
    LogService.i(result);
    setState(() {
      pickedImage64 = result;
    });
  }

  void removePickedImage() async {
    setState(() {
      pickedImage64 = null;
    });
  }

  void askToGemini() {
    String message = textController.text.toString().trim();
    if (message.isEmpty) {
      return;
    }

    if (pickedImage64 != null) {
      MessageModel mine =
          MessageModel(isMine: true, message: message, base64: pickedImage64);
      updateMessages(mine);
      apiTextAndImage(message, pickedImage64!);
    } else {
      MessageModel mine = MessageModel(isMine: true, message: message);
      updateMessages(mine);
      apiTextOnly(message);
    }

    textController.clear();
    removePickedImage();
  }

  apiTextOnly(String message) async {
    var response = await Network.POST(
        Network.API_GEMINI_TALK, Network.paramsTextOnly(message));
    var geminiTalk = Network.parseGeminiTalk(response!);
    var result = geminiTalk.candidates[0].content.parts[0].text;

    MessageModel gemini = MessageModel(isMine: false, message: result);
    updateMessages(gemini);
  }

  apiTextAndImage(String message, String pickedImage64) async {
    var response = await Network.POST(Network.API_GEMINI_TALK,
        Network.paramsTextAndImage(message, pickedImage64));
    var geminiTalk = Network.parseGeminiTalk(response!);
    var result = geminiTalk.candidates[0].content.parts[0].text;

    MessageModel gemini = MessageModel(isMine: false, message: result);
    updateMessages(gemini);
  }

  updateMessages(MessageModel messageModel) {
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
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

                  pickedImage64 != null
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
                                  base64Decode(pickedImage64!),
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
                                      removePickedImage();
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
                          controller: textController,
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
                          pickImageFromGallery();
                        },
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          askToGemini();
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
      ),
    );
  }

}
