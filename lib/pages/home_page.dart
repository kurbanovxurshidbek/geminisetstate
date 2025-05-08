import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geministate/services/http_service.dart';

import '../models/gemini_talk_model.dart';
import '../models/message_model.dart';
import '../services/log_service.dart';
import '../services/utils_service.dart';

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

  Widget itemOfGeminiMessage(MessageModel message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 30,
                  child: Image.asset('assets/images/gemini_icon.png'),
                ),
                Icon(
                  Icons.volume_up,
                  color: Colors.white70,
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                message.message!,
                style: TextStyle(
                    color: Color.fromRGBO(173, 173, 176, 1), fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemOfUserMessage(MessageModel message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
              color: Color.fromRGBO(38, 39, 42, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              )),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message!,
                  style: const TextStyle(
                      color: Color.fromRGBO(173, 173, 176, 1), fontSize: 17),
                ),
                message.base64 != null && message.base64!.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 16, bottom: 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(base64Decode(message.base64!)),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
