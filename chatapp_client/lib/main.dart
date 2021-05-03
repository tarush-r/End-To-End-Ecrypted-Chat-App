import 'package:chatapp_client/models/chat_contact_model.dart';
import 'package:chatapp_client/providers/chats_provider.dart';
import 'package:chatapp_client/providers/user_provider.dart';
import 'package:chatapp_client/screens/call_screen.dart';
import 'package:chatapp_client/screens/calls_screen.dart';
import 'package:chatapp_client/screens/chat_screen.dart';
import 'package:chatapp_client/screens/home_screen.dart';
import 'package:chatapp_client/screens/schedule_screen.dart';
import 'package:chatapp_client/screens/settings_screen.dart';
import 'package:chatapp_client/screens/support_screen.dart';
import 'package:chatapp_client/screens/view_profile_screen.dart';
import 'package:chatapp_client/utils/color_themes.dart';
import 'package:chatapp_client/utils/message_store.dart';
import 'package:flutter/material.dart';
import './screens/register_screen.dart';
import './screens/generate_otp_screen.dart';
import './screens/login_screen.dart';
import './screens/authenticate.dart';
import 'screens/chatslist_screen.dart';
import './helpers/sharedpreferences_helper.dart';
import './screens/contacts_screen.dart';
import 'package:provider/provider.dart';
import './screens/profile_screen.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>ChatsProvider(),
          // child: ,
        ),
        ChangeNotifierProvider(
          create: (context) =>UserProvider(),
          // child: ,
        ),
        // Provider<ChatsProvider>(
        //   create: (_) => ChatsProvider(),
        // ),
        // Provider<MessageStore>(
        //   create: (_) => MessageStore(),
        //   dispose: (_, store) => store.dispose(),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: ColorThemes.primary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Authenticate(),
        routes: {
          GenerateOtpScreen.routeName: (ctx) => GenerateOtpScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          ChatsListScreen.routeName: (ctx) => ChatsListScreen(),
          ContactsScreen.routeName: (ctx) => ContactsScreen(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
          CallsScreen.routeName: (ctx) => CallsScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          ScheduleScreen.routeName: (ctx) => ScheduleScreen(),
          CallPage.routeName: (ctx) => CallPage(),
          ViewProfileScreen.routeName: (ctx) => ViewProfileScreen(),
          SupportScreen.routeName: (ctx) => SupportScreen(),
          //RegisterScreen.routeName: (ctx) => RegisterScreen(),
        },
      ),
    );
  }
}
