import 'package:chatapp_client/providers/chats_provider.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:chatapp_client/screens/chatslist_screen.dart';
import 'package:chatapp_client/utils/color_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';
import 'calls_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [
    CallsScreen(),
    ChatsListScreen(),
    SettingsScreen()
  ];
  int _navigationIndex = 1;

  var user;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      user = Provider.of<UserProvider>(context, listen: false).user;
      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
            print(user['_id']);
      Provider.of<ChatsProvider>(context, listen: false).initSocket(user['_id']);
    });
    super.initState();
  }

  _navigate(index) {
    setState(() {
      _navigationIndex = index;
    });
  }

  _customBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            // color: Colors.red,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RawMaterialButton(
              shape: CircleBorder(),
              onPressed: () {
                _navigate(0);
              },
              child: Container(
                height: 60,
                width: 60,
                // color: Colors.red,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _navigationIndex == 0
                        ? ColorThemes.primary
                        : Colors.grey[200]),
                child: Center(
                    child: Icon(
                  Icons.phone,
                  color: _navigationIndex == 0
                      ? ColorThemes.secondary2
                      : ColorThemes.secondary,
                )),
              ),
            ),
            RawMaterialButton(
              shape: CircleBorder(),
              onPressed: () {
                _navigate(1);
              },
              child: Container(
                height: 80,
                width: 80,
                // color: Colors.red,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _navigationIndex == 1
                        ? ColorThemes.primary
                        : Colors.grey[200]),
                child: Center(
                    child: Icon(
                  Icons.chat_bubble,
                  color: _navigationIndex == 1
                      ? ColorThemes.secondary2
                      : ColorThemes.secondary,
                )),
              ),
            ),
            RawMaterialButton(
              shape: CircleBorder(),
              onPressed: () {
                _navigate(2);
              },
              child: Container(
                height: 60,
                width: 60,
                // color: Colors.red,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _navigationIndex == 2
                        ? ColorThemes.primary
                        : Colors.grey[200]),
                child: Center(
                    child: Icon(
                  Icons.settings,
                  color: _navigationIndex == 2
                      ? ColorThemes.secondary2
                      : ColorThemes.secondary,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[_navigationIndex],
        bottomNavigationBar: _customBottomNavigation()
        // BottomNavigationBar(
        //   currentIndex: _navigationIndex,
        //   onTap: (index) {
        //     setState(() {
        //       _navigationIndex = index;
        //     });
        //     print(index);
        //   },
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.phone),
        //       label: 'Calls',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat),
        //       label: 'Chats',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       label: 'Settings',
        //     ),
        //   ],
        // ),
        );
  }
}
