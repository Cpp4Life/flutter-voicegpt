import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:voicegpt/models/chat_model.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/services/open_ai_service.dart';

enum InputMode {
  text,
  voice,
}

class TextNVoiceWidget extends StatefulWidget {
  const TextNVoiceWidget({super.key});

  @override
  State<TextNVoiceWidget> createState() => _TextNVoiceWidgetState();
}

class _TextNVoiceWidgetState extends State<TextNVoiceWidget> {
  InputMode _inputMode = InputMode.voice;
  late ChatProvider _chatPvd;
  final _msgController = TextEditingController();
  OpenAIService _openAISvc = OpenAIService();

  @override
  void didChangeDependencies() {
    _chatPvd = Provider.of<ChatProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _openAISvc.dispose();
    super.dispose();
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendTextMessage() async {
    final msg = _msgController.text;
    _msgController.clear();
    addToChatList(msg, true);
    final response = await _openAISvc.getResponse(msg);
    addToChatList(response, false);
  }

  void sendVoiceMessage() {}

  void addToChatList(String msg, bool isUser) {
    _chatPvd.addMessage(
      ChatModel(
        id: const Uuid().v4(),
        message: msg,
        isUser: isUser,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              onChanged: (value) {
                value.isEmpty
                    ? setInputMode(InputMode.voice)
                    : setInputMode(InputMode.text);
              },
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _inputMode == InputMode.text ? sendTextMessage : sendVoiceMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
            ),
            child: Icon(
              _inputMode == InputMode.text ? Icons.send : Icons.mic,
            ),
          ),
        ],
      ),
    );
  }
}
