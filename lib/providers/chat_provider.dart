import 'package:flutter/material.dart';
import 'package:voicegpt/models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> _messages = [];

  List<ChatModel> get messages {
    return [..._messages];
  }

  void addMessage(ChatModel cm) {
    _messages.add(cm);
    notifyListeners();
  }
}
