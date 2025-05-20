import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/message_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
import '../services/utils_service.dart';

class HomeController extends GetxController {
  TextEditingController textController = TextEditingController();
  List<MessageModel> messages = [];
  String? pickedImage64;

  void pickImageFromGallery() async {
    var result = await Utils.pickAndConvertImage();
    LogService.i(result);

    pickedImage64 = result;
    update();
  }

  void removePickedImage() async {
    pickedImage64 = null;
    update();
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
    messages.add(messageModel);
    update();
  }
}
