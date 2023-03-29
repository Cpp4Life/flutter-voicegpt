import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/providers/chat_provider.dart';
import 'package:voicegpt/providers/theme_provider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/setting';

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late List<Map<String, String>> _list;
  late String _dropdownValue;
  late int _selectedIndex;

  @override
  void initState() {
    _list = [
      {
        'lang': 'English (US)',
        'flag': 'assets/svg/us.svg',
        'localeId': 'en-US',
      },
      {
        'lang': 'Vietnamese',
        'flag': 'assets/svg/vn.svg',
        'localeId': 'vi-VN',
      }
    ];
    _selectedIndex = 0;
    _dropdownValue = _list[_selectedIndex]['lang'] as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themePvd = Provider.of<ThemeProvider>(context, listen: false);
    final chatPvd = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.transparent,
        title: const Text('Settings'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Consumer<ThemeProvider>(
                  builder: (context, value, _) {
                    return ListTile(
                      minLeadingWidth: 10,
                      leading: Icon(
                        value.isSwitched ? Icons.dark_mode : Icons.light_mode,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      title: Text(
                        value.isSwitched ? 'Dark Theme' : 'Light Theme',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      trailing: Switch.adaptive(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: themePvd.isSwitched,
                        onChanged: (value) {
                          themePvd.toggleTheme(value);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  minLeadingWidth: 10,
                  leading: Icon(
                    Icons.play_circle_outline,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  title: Text(
                    'Auto TTS replies',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  trailing: Switch.adaptive(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  minLeadingWidth: 10,
                  leading: SvgPicture.asset(
                    _list[_selectedIndex]['flag'] as String,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    'Speech Language',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  trailing: DropdownButton<String>(
                    value: _dropdownValue,
                    underline: const SizedBox(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedIndex =
                            _list.indexWhere((element) => element['lang'] == value);
                        _dropdownValue = value!;
                      });
                    },
                    items: _list.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['lang'],
                        child: Text(value['lang']!),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: ElevatedButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    content: const Text('Are you sure you want to delete all messages?'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          chatPvd.deleteAllMessages();
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Delete all messages',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
