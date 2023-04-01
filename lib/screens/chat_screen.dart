import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/screens/setting_screen.dart';
import 'package:voicegpt/storage/chat_storage.dart';
import 'package:voicegpt/widgets/chat_item.dart';
import 'package:voicegpt/widgets/text_n_voice.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late ChatProvider _chatPvd;
  final MessageStorage _storage = MessageStorage();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _chatPvd = Provider.of<ChatProvider>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _storage.writeMessages(_chatPvd.messages);
    }
    super.didChangeAppLifecycleState(state);
  }

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
      body: FutureBuilder(
        future: Provider.of<ChatProvider>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('An error occurred'),
            );
          } else {
            return Consumer<ChatProvider>(
              builder: (context, chatsData, _) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: chatsData.messages.length,
                          itemBuilder: (context, index) => ChatItemWidget(
                            message: chatsData.reversedMessage[index].message,
                            isUser: chatsData.reversedMessage[index].isUser,
                          ),
                        ),
                      ),
                      const TextNVoiceWidget(),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
