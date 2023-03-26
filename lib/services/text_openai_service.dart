import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class TextOpenAIService {
  final _openAI = OpenAI.instance.build(
    token: '',
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
    } catch (error) {
      print(error.toString());
      return 'Oops! Something went wrong';
    }
  }

  void dispose() {
    _openAI.close();
  }
}
