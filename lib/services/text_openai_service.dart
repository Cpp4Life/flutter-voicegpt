import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextOpenAIService {
  final List<Map<String, String>> _history = [];

  final _openAI = OpenAI.instance.build(
    token: dotenv.env['TOKEN'],
    baseOption: HttpSetup(
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
    isLog: false,
  );

  Future<String> getResponse(String message) async {
    final userInput = Map<String, String>.of(
      {
        "role": "user",
        "content": message,
      },
    );
    _history.add(userInput);

    try {
      final request = ChatCompleteText(
        messages: _history,
        model: kChatGptTurbo0301Model,
        maxToken: 1024,
      );
      final ChatCTResponse? response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        final responseMsg = response.choices[0].message;
        final assistantInput = Map<String, String>.of(
          {
            "role": "assistant",
            "content": responseMsg.content,
          },
        );
        _history.add(assistantInput);
        return responseMsg.content;
      }
      return 'Oops! Something went wrong';
    } catch (error) {
      print(error.toString());
      return 'Oops! Something went wrong';
    }
  }

  void dispose() {
    _openAI.close();
  }
}
