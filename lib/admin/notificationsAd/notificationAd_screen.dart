import 'package:flutter/material.dart';
import 'package:shop_app/admin/notificationsAd/components/replyAd.dart';
import 'package:shop_app/admin/notificationsAd/components/sentAd.dart';

class NotAdScreen extends StatefulWidget {
  static String routeName = "/notad";

  const NotAdScreen({super.key});

  @override
  State<NotAdScreen> createState() => _NotScreenState();
}

class _NotScreenState extends State<NotAdScreen> {
  List newItem = ["sent", "replied"];
  List todayItem = ["replied", "sent", "sent"];

  List oldesItem = ["replied", "replied", "sent", "sent"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "New",
                  style: TextStyle(
                    fontSize: 20.0, // Adjust the fontSize as needed
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newItem.length,
                  itemBuilder: (context, index) {
                    return newItem[index] == "replied"
                        ? const ReplyAdNotifcation()
                        : const SentAdNotifcation();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 20.0, // Adjust the fontSize as needed
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: todayItem.length,
                  itemBuilder: (context, index) {
                    return todayItem[index] == "replied"
                        ? const ReplyAdNotifcation()
                        : const SentAdNotifcation();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Oldest",
                    style: TextStyle(
                      fontSize: 20.0, // Adjust the fontSize as needed
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: oldesItem.length,
                  itemBuilder: (context, index) {
                    return oldesItem[index] == "replied"
                        ? const ReplyAdNotifcation()
                        : const SentAdNotifcation();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
