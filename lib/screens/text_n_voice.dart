import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:voicegpt/models/chat_model.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/services/text_openai_service.dart';
import 'package:voicegpt/services/voice_openai_service.dart';

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
  final _msgController = TextEditingController();
  final TextOpenAIService _textOpenAISvc = TextOpenAIService();
  final VoiceOpenAIService _voiceOpenAISvc = VoiceOpenAIService();
  late ChatProvider _chatPvd;
  InputMode _inputMode = InputMode.voice;
  bool _isReplying = false;
  bool _isListening = false;

  @override
  void initState() {
    _voiceOpenAISvc.initSpeech();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _chatPvd = Provider.of<ChatProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _textOpenAISvc.dispose();
    super.dispose();
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendTextMessage(String msg) async {
    setReplyingState(true);
    addToChatList(msg, true, null);
    addToChatList('Replying...', false, 'assistant-response');
    setInputMode(InputMode.voice);
    final response = await _textOpenAISvc.getResponse(msg);
    removeFromChatList();
    addToChatList(response, false, null);
    setReplyingState(false);
  }

  void sendVoiceMessage() async {
    if (!_voiceOpenAISvc.isEnabled) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Access Permission'),
          content: const Text('Microphone is not enabled for this application!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop('OK');
              },
            ),
          ],
        ),
      );
      return;
    }
    if (_voiceOpenAISvc.speechToText.isListening) {
      await _voiceOpenAISvc.stopListening();
    } else {
      setListeningState(true);
      final result = await _voiceOpenAISvc.startListening();
      setListeningState(false);
      sendTextMessage(result);
    }
  }

  void setReplyingState(bool isRelying) {
    setState(() {
      _isReplying = isRelying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void addToChatList(String msg, bool isUser, String? id) {
    _chatPvd.addMessage(
      ChatModel(
        id: id ?? const Uuid().v4(),
        message: msg,
        isUser: isUser,
      ),
    );
  }

  void removeFromChatList() {
    _chatPvd.removeMessage();
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
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
            onPressed: _isReplying
                ? null
                : () {
                    final msg = _msgController.text;
                    _msgController.clear();
                    _inputMode == InputMode.text
                        ? sendTextMessage(msg)
                        : sendVoiceMessage();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
            ),
            child: Icon(
              _inputMode == InputMode.text
                  ? Icons.send
                  : _isListening
                      ? Icons.mic_off
                      : Icons.mic,
            ),
          ),
        ],
      ),
    );
  }
}
