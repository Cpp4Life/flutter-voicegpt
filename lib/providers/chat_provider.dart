import 'package:flutter/material.dart';
import 'package:voicegpt/models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatModel> _messages = [];

  List<ChatModel> get messages {
    return [..._messages];
  }

  List<ChatModel> get reversedMessage {
    return [..._messages.reversed.toList()];
  }

  void addMessage(ChatModel cm) {
    _messages.add(cm);
    notifyListeners();
  }

  void removeMessage() {
    _messages.removeWhere((element) => element.id == 'assistant-response');
    notifyListeners();
  }
}
