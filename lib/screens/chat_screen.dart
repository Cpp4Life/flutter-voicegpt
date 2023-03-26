import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/providers/theme_provider.dart';
import 'package:voicegpt/screens/text_n_voice.dart';
import 'package:voicegpt/widgets/chat_item.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themePvd = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.transparent,
        title: const Text('Rookie Bot'),
        actions: [
          Row(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, value, _) {
                  return Icon(value.isSwitched ? Icons.dark_mode : Icons.light_mode);
                },
              ),
              const SizedBox(width: 10),
              Switch.adaptive(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: themePvd.isSwitched,
                onChanged: (value) {
                  themePvd.toggleTheme(value);
                },
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatsData, _) => ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: chatsData.messages.length,
                  itemBuilder: (context, index) => ChatItemWidget(
                    message: chatsData.reversedMessage[index].message,
                    isUser: chatsData.reversedMessage[index].isUser,
                  ),
                ),
              ),
            ),
            const TextNVoiceWidget(),
          ],
        ),
      ),
    );
  }
}
