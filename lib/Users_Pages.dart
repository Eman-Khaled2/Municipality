import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Advertisements.dart';
import 'package:shop_app/Donations.dart';
import 'package:shop_app/actions.dart';
import 'package:shop_app/donationMain.dart';
import 'package:shop_app/eventsMain.dart';
import 'package:shop_app/report.dart';
import 'package:shop_app/reportsMain.dart';
import 'package:shop_app/screens/notifications/notifications_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/settings/settings_screen.dart';
import 'package:shop_app/services.dart';
import 'package:shop_app/servicesMain.dart';
import 'package:shop_app/tax.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: const SettingsPage(),
        );
      },
    );
  }
}

void changeTheme(BuildContext context, AdaptiveThemeMode mode) {
  if (mode == AdaptiveThemeMode.light) {
    // sets theme mode to dark
    AdaptiveTheme.of(context).setDark();
  }

  // sets theme mode to light
  AdaptiveTheme.of(context).setLight();

  // sets theme mode to system default
  AdaptiveTheme.of(context).setSystem();
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.My_municipality.tr(),
            style: const TextStyle(color: Colors.white)), //),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Settings()));
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotScreen()));
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/c.jpg',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 3, // عدد الأعمدة في الشبكة
              shrinkWrap: true, // لجعل GridView يتغلف بالكامل
              children: [
                buildButton(
                    context, '1', Icons.auto_stories, LocaleKeys.Services.tr()),
                buildButton(context, '2', Icons.event, LocaleKeys.News.tr()),
                buildButton(
                    context, '3', Icons.monetization_on, LocaleKeys.tax.tr()),
                buildButton(context, '4', Icons.ad_units,
                    LocaleKeys.Advertisements.tr()),
                buildButton(context, '5', Icons.add_chart,
                    LocaleKeys.File_a_report.tr()),
                buildButton(context, '6', Icons.account_circle,
                    LocaleKeys.Profile_personly.tr()),
                buildButton(context, '7', Icons.volunteer_activism,
                    LocaleKeys.Donations.tr()),
                buildButton(context, '8', Icons.event_note_outlined,
                    LocaleKeys.events.tr()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      BuildContext context, String title, IconData icon, String description) {
    return GestureDetector(
      onTap: () {
        // Navigate to corresponding page based on button pressed
        switch (title) {
          case '1':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageSlider(),
                settings: const RouteSettings(),
              ),
            );
            break;

          case '2':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventsPage()),
            );
            break;
          case '3':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaxPage()),
            );
            break;
          case '4':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdvertisementsPage()),
            );
            break;
          case '5':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportMainScreen()),
            );
            break;
          case '6':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
          case '7':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DonationMainScreen()),
            );
          case '8':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EventMainScreen()),
            );
            break;
        }
      },
      child: SizedBox(
        width: 180, // حجم العرض الثابت لكل زر
        height: 100, // حجم الارتفاع الثابت لكل زر
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!), // Add light border
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Color.fromARGB(255, 92, 138, 95),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
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
  runApp(MyApp());
}
