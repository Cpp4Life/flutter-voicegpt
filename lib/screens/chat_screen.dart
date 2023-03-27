import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/screens/setting_screen.dart';
import 'package:voicegpt/widgets/chat_item.dart';
import 'package:voicegpt/widgets/text_n_voice.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.transparent,
        title: const Text('Rookie Bot'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SettingScreen.routeName);
            },
            color: Theme.of(context).colorScheme.secondary,
            splashColor: Colors.transparent,
            icon: const Icon(Icons.settings),
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
