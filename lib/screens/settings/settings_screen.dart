import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shop_app/admin/body_all_user.dart';
import 'package:shop_app/chat.dart';
import 'package:shop_app/helpCenter.dart';
import 'package:shop_app/screens/about/about_screen.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  static String routeName = "/settings";

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<Settings> {
  late RateMyApp _rateMyApp;

  @override
  void initState() {
    super.initState();
    _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0, // Change this value as required by your app
      minLaunches: 3, // Change this value as required by your app
      remindDays: 2, // Change this value as required by your app
      remindLaunches: 7, // Change this value as required by your app
    );
    _rateMyApp.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Settings.tr(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 238, 227, 240),
                Color.fromARGB(255, 187, 168, 187),
              ],
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            children: [
              _SingleSection(
                title: LocaleKeys.General.tr(),
                children: [
                  _CustomListTile(
                    title: LocaleKeys.Dark_Mode.tr(),
                    icon: Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: AdaptiveTheme.of(context).mode.isDark,
                      onChanged: (value) {
                        if (value) {
                          AdaptiveTheme.of(context).setDark();
                        } else {
                          AdaptiveTheme.of(context).setLight();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                title: LocaleKeys.Organization.tr(),
                children: [
                  _CustomListTile(
                    title: LocaleKeys.Messaging.tr(),
                    icon: Icons.message_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: LocaleKeys.Calling.tr(),
                    icon: Icons.phone_outlined,
                    onTap: () async {
                      const phoneNumber = '0595781756';
                      const url = 'tel:$phoneNumber';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(LocaleKeys.Error.tr()),
                              content: const Text('Could not launch $url'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(LocaleKeys.OK.tr()),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  _CustomListTile(
                    title: "sms",
                    icon: Icons.sms_outlined,
                    onTap: () async {
                      const phoneNumber = '0595781756';
                      const url = 'sms:$phoneNumber';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(LocaleKeys.Error.tr()),
                              content: const Text('Could not launch $url'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(LocaleKeys.OK.tr()),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  _CustomListTile(
                    title: LocaleKeys.Calendar.tr(),
                    icon: Icons.calendar_today_rounded,
                    onTap: () async {
                      DateTime selectedDate = DateTime.now();
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                children: [
                  _CustomListTile(
                    title: LocaleKeys.Help_Feedback.tr(),
                    icon: Icons.help_outline_rounded,
                    onTap: () {
                      _rateMyApp.showStarRateDialog(
                        context,
                        title: 'Enjoying the app?',
                        message: 'Please leave a rating!',
                        dialogStyle: DialogStyle(
                          dialogShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        actionsBuilder: (context, stars) {
                          return [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (stars != null) {
                                  _rateMyApp.callEvent(
                                      RateMyAppEventType.rateButtonPressed);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(LocaleKeys.OK.tr()),
                            ),
                          ];
                        },
                        starRatingOptions: const StarRatingOptions(),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: LocaleKeys.About.tr(),
                    icon: Icons.info_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: 'Help Center', // New choice for Help Center
                    icon: Icons.help_center_outlined, // Icon for Help Center
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(), // Navigate to HelpScreen
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final void Function()? onTap;

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
