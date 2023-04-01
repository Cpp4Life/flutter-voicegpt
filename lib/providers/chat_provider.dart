import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:voicegpt/models/chat_model.dart';
import 'package:voicegpt/storage/chat_storage.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> _messages = [];
  final MessageStorage _storage = MessageStorage();

  List<ChatModel> get messages {
    return [..._messages];
  }

  List<ChatModel> get reversedMessage {
    return [..._messages.reversed.toList()];
  }

  Future fetchAndSetOrders() async {
    try {
      final decodedJSON = await _storage.readMessages();
      if (decodedJSON == null) {
        return;
      }
      final messages = decodedJSON
          .map((e) => ChatModel(
                id: e['id'],
                message: e['message'],
                isUser: e['isUser'],
              ))
          .toList();
      _messages = messages;
      notifyListeners();
    } catch (e) {
      log("🚀 ~ ChatProvider ~ FuturefetchAndSetOrders ~ ${e.toString()}");
      rethrow;
    }
  }

  void addMessage(ChatModel cm) {
    _messages.add(cm);
    notifyListeners();
  }

  void removeMessage() {
    _messages.removeWhere((element) => element.id == 'assistant-response');
    notifyListeners();
  }

  void deleteAllMessages() {
    _messages = [];
    _storage.writeMessages([]);
    notifyListeners();
  }
}
