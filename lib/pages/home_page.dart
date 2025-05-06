import 'package:flutter/material.dart';
import 'package:geministate/services/http_service.dart';

import '../models/gemini_talk_model.dart';
import '../models/message_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();
  List<MessageModel> messages = [];

  void askToGemini() {
    String message = textController.text.toString().trim();
    if (message.isEmpty) {
      return;
    }

    MessageModel mine = MessageModel(isMine: true, message: message);
    updateMessages(mine);

    // API Request
    apiTextOnly(message);

    textController.clear();
  }

  apiTextOnly(String message)async{
    var response = await Network.POST(Network.API_GEMINI_TALK, Network.paramsTextOnly(message));
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
                children: [
                  // Picked Image

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
                        onPressed: () {},
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
              children: [
                Text(
                  message.message!,
                  style: const TextStyle(
                      color: Color.fromRGBO(173, 173, 176, 1), fontSize: 17),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
