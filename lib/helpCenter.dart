import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/chat.dart';
import 'package:shop_app/report.dart';
import 'package:shop_app/screens/about/about_screen.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class HelpScreen extends StatelessWidget {
  static String routeName = "/help";

  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          LocaleKeys.Municipality_Help_Center.tr(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 238, 227, 240),
                  Color.fromARGB(255, 187, 168, 187),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.Welcome_to_our_municipality_system.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.How_can_we_assist_you_today.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                buildHelpOption(
                  LocaleKeys.General_Information.tr(),
                  LocaleKeys.Get_information_about_the_municipality.tr(),
                  Colors.white,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutScreen()),
                    );
                  },
                ),
                buildHelpOption(
                  LocaleKeys.Report_an_Issue.tr(),
                  LocaleKeys.Report_a_problem_or_issue_in_the_municipality.tr(),
                  Colors.white,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(option: 'Some Option'), // Adjust 'Some Option' accordingly
                      ),
                    );
                  },
                ),
                buildHelpOption(
                  LocaleKeys.Contact_Us.tr(),
                  LocaleKeys.Reach_out_to_us_for_further_assistance.tr(),
                  Colors.white,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                ),
                // Add more help options as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHelpOption(String title, String description, Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: color,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black, // Set text color to black for better visibility on white background
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: Colors.black, // Set text color to black for better visibility on white background
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
