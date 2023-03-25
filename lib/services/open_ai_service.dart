import 'dart:developer';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class OpenAIService {
  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
    isLog: true,
  );

  Future<String> getResponse(String message) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Map.of({"role": "user", "content": message})
        ],
        model: kChatGptTurbo0301Model,
        maxToken: 1024,
      );
      final ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        return response.choices[0].message.content;
      }
      return 'Oops! Something went wrong';
    } catch (e) {
      debugger(message: '[ERROR] - $e');
      return e.toString();
    }
  }

  void dispose() {
    _openAI.close();
  }
}
