import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/constants/themes.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/providers/speech_lang_provider.dart';
import 'package:voicegpt/providers/theme_provider.dart';
import 'package:voicegpt/providers/tts_provider.dart';
import 'package:voicegpt/screens/chat_screen.dart';
import 'package:voicegpt/screens/setting_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SpeechLangProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AutoTTSProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: value.isSwitched ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const ChatScreen(),
            routes: {
              SettingScreen.routeName: (context) => const SettingScreen(),
            },
          );
        },
      ),
    );
  }
}
