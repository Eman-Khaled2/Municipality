import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/admin/AllChats.dart';
import 'package:shop_app/admin/chat_messages.dart';
import 'package:shop_app/chat.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class Settings extends StatefulWidget {
  static String routeName = "/settings";

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<Settings> {
  late bool _isDark;
  bool _tempDarkState = false; // Initialize _tempDarkState with default value
  late RateMyApp _rateMyApp;
  late Future<void> _initAsyncState;

  @override
  void initState() {
    super.initState();
    _initAsyncState = _initAsync();
  }

  Future<void> _initAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDarkMode') ?? false; // Get saved theme state
    _tempDarkState = _isDark; // Initialize temp state with saved state
    _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 3,
      remindDays: 2,
      remindLaunches: 7,
    );
    await _rateMyApp.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Settings.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
          Color.fromARGB(255, 238, 227, 240), Color.fromARGB(255, 187, 168, 187)
            ],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: FutureBuilder<void>(
              future: _initAsyncState,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _buildSettingsWidget();
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsWidget() {
    return ListView(
      children: [
        _SingleSection(
          title: LocaleKeys.General.tr(),
          children: [
            _CustomListTile(
              title: LocaleKeys.Dark_Mode.tr(),
              icon: Icons.dark_mode_outlined,
              trailing: Switch(
                value: _tempDarkState, // Use temporary state for switch value
                onChanged: (value) {
                  setState(() {
                    _tempDarkState = value; // Update temporary state
                  });
                  if (value) {
                    // If dark mode is enabled
                    AdaptiveTheme.of(context).setDark();
                  } else {
                    // If dark mode is disabled
                    AdaptiveTheme.of(context).setLight();
                  }
                  _saveDarkModePreference(value); // Save theme state
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
                  MaterialPageRoute(
                    builder: (context) => AllChats(),
                  ),
                );
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
          ],
        ),
      ],
    );
  }

  void _saveDarkModePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value); // Save theme state
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if it's the first page in the route stack
    if (ModalRoute.of(context)!.isFirst) {
      // Re-initialize values if it's the first page
      _initAsyncState = _initAsync();
    }
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
