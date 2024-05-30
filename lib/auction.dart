import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class AuctionScreen extends StatelessWidget {
  static String routeName = "/auction";

  const AuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug mark
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton( // Add a leading icon button for the white arrow
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            LocaleKeys.Auction.tr(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        body: Container(
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
          padding: const EdgeInsets.all(160.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column( // Column to stack image and text vertically
                children: [
                  Image.asset(
                    'assets/images/bid.png', // Path to your bid image
                    height: 100, // Adjust height as needed
                  ),
                  SizedBox(height: 10), // Add space between image and text
                  Text(
                    LocaleKeys.Auction.tr(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 134, 131, 131),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                LocaleKeys.Item_Name_Fancy.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 93, 93, 93),
                ),
              ),
              SizedBox(height: 10),
              Text(
                LocaleKeys.Bid_500.tr(),
                style: TextStyle(
                  fontSize: 21,
                  color: const Color.fromARGB(255, 101, 100, 100),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Show a message when the button is pressed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(LocaleKeys.Bid_Placed.tr()),
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
                },
                child: Text(
                  LocaleKeys.Place_Bid.tr(),
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 114, 112, 112),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
