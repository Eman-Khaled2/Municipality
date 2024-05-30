import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Login.dart';
import 'package:shop_app/admin/accountAd.dart';
import 'package:shop_app/admin/notificationsAd/notificationAd_screen.dart';
import 'package:shop_app/admin/profileAd/components/profileAd_menu.dart';
import 'package:shop_app/admin/profileAd/components/profileAd_pic.dart';
import 'package:shop_app/admin/settingsAd.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class ProfileAdScreen extends StatelessWidget {
  static String routeName = "/profilead";

  const ProfileAdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.profile.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 238, 227, 240),
              Color.fromARGB(255, 187, 168, 187)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 790), // Adjust this padding as needed
          child: Column(
            children: [
              const SizedBox(height: 20), // Add space between app bar and profile picture
              const ProfileAdPic(),
              const SizedBox(height: 20),
              ProfileAdMenu(
                text: LocaleKeys.My_account.tr(),
                icon: "assets/icons/User Icon.svg",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountAdScreen(
                      userData: {},
                    ),
                  ),
                ),
              ),
              ProfileAdMenu(
                text: LocaleKeys.Notifications.tr(),
                icon: "assets/icons/Bell.svg",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotAdScreen(),
                  ),
                ),
              ),
              ProfileAdMenu(
                text: LocaleKeys.Settings.tr(),
                icon: "assets/icons/Settings.svg",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                ),
              ),
              ProfileAdMenu(
                text: LocaleKeys.Log_Out.tr(),
                icon: "assets/icons/Log out.svg",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginDemo(
                      baseUrl: '',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US')], // add your supported locales here
      path: 'assets/translations', // add the path to your translation files
      child: MaterialApp(
        title: 'Your App Title',
        home: ProfileAdScreen(),
      ),
    ),
  );
}
