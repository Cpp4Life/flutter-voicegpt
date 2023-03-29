import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/providers/speech_lang_provider.dart';

class ChatItemWidget extends StatefulWidget {
  final String message;
  final bool isUser;

  const ChatItemWidget({
    required this.message,
    required this.isUser,
    super.key,
  });

  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget> {
  final _tts = FlutterTts();
  bool _isPlaying = false;
  late SpeechLangProvider _speechLangPvd;

  @override
  void initState() {
    _setAwaitOptions();
    _setDeviceAudio();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _speechLangPvd = Provider.of<SpeechLangProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future _speak(String msg) async {
    await _tts.setLanguage(_speechLangPvd.lm.localeID);
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    if (msg.isNotEmpty) {
      setState(() => _isPlaying = true);
      await _tts.speak(msg);
    }

    setState(() => _isPlaying = false);
  }

  Future _setAwaitOptions() async {
    await _tts.awaitSpeakCompletion(true);
  }

  Future _setDeviceAudio() async {
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
    );
  }

  Future _pause() async {
    setState(() => _isPlaying = false);
    await _tts.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !widget.isUser
              ? Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 5, left: 5),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: SvgPicture.asset(
                      'assets/svg/chatgpt.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                decoration: BoxDecoration(
                  color: widget.isUser
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: Radius.circular(widget.isUser ? 15 : 0),
                    bottomRight: Radius.circular(widget.isUser ? 0 : 15),
                  ),
                ),
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              !widget.isUser && widget.message != "Replying..."
                  ? Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 5, left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          _isPlaying ? _pause() : _speak(widget.message);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                        ),
                        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
