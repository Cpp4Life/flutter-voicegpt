import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/constants/themes.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/providers/theme_provider.dart';
import 'package:voicegpt/screens/chat_screen.dart';

void main() {
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
          );
        },
      ),
    );
  }
}
