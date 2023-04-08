import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:voicegpt/models/chat_model.dart';

class MessageStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/message.txt');
  }

  Future<List<dynamic>?> readMessages() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final bytes = utf8.encode(contents);
      return jsonDecode(utf8.decode(bytes)) as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future writeMessages(List<ChatModel> messages) async {
    final file = await _localFile;
    await deleteFile();

    final storedMessages = messages.isEmpty
        ? []
        : messages
            .map((e) => {
                  'id': e.id,
                  'message': e.message,
                  'isUser': e.isUser,
                })
            .toList();

    await file.writeAsString(json.encode(storedMessages));
  }

  Future deleteFile() async {
    final file = await _localFile;
    final isExisted = await file.exists();
    if (isExisted) {
      await file.delete();
    }
  }
}
