import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/admin/advAd.dart';
import 'package:shop_app/admin/complaints.dart';
import 'package:shop_app/admin/donations.dart';
import 'package:shop_app/admin/donationsAd.dart';
import 'package:shop_app/admin/eventsAd.dart';
import 'package:shop_app/admin/graphs.dart';
import 'package:shop_app/admin/manageUser.dart';
import 'package:shop_app/admin/newsAd.dart';
import 'package:shop_app/admin/profileAd/profileAd_screen.dart';
import 'package:shop_app/admin/reportAd.dart';
import 'package:shop_app/admin/reservations.dart';
import 'package:shop_app/admin/servicesAd.dart';
import 'package:shop_app/admin/taxAd.dart';
import 'package:shop_app/admin/taxes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AdminScreen.routeName,
      routes: {
        AdminScreen.routeName: (context) => const AdminScreen(userData: {}),
        NewsAdPage.routeName: (context) => const NewsAdPage(),
        TaxAdPage.routeName: (context) => const TaxAdPage(),
        AdvertisementsAdPage.routeName: (context) => const AdvertisementsAdPage(),
        ProfileAdScreen.routeName: (context) => const ProfileAdScreen(),
        DonationAdPage.routeName: (context) => const DonationAdPage(),
        EventAdScreen.routeName: (context) => const EventAdScreen(),
      },
    );
  }
}

class AdminScreen extends StatelessWidget {
  static String routeName = "/admin";

  final Map<String, dynamic> userData;

  const AdminScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Received User Data: $userData");
    final account = GetStorage();

    return FutureBuilder(
      future: Future.value(account.read('keyUser')),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          var userData = snapshot.data as Map<String, dynamic>?;
          print("Stored User Data: $userData");

          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      userData?['name'] ?? '',
                      style: const TextStyle(color: Color.fromARGB(255, 83, 82, 82)), // Set text color to black
                    ),
                    accountEmail: Text(
                      userData?['email'] ?? '',
                      style: const TextStyle(color: Color.fromARGB(255, 83, 82, 82)), // Set text color to black
                    ),
                    currentAccountPicture: Image.asset(
                      'assets/images/adIcon.png',
                      width: 100, // Adjust the width to fit your design
                      height: 100, // Adjust the height to fit your design
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 214, 212, 214),
                    ),
                  ),
                  Expanded(
                    child: buildTile(),
                  ),
                ],
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [ Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMenuButton('Services', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServicesAdPage()),
                        );
                      }),
                      _buildMenuButton('News', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewsAdPage()),
                        );
                      }),
                      _buildMenuButton('Taxes', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaxAdPage()),
                        );
                      }),
                      _buildMenuButton('Advertisements', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdvertisementsAdPage()),
                        );
                      }),
                      _buildMenuButton('Reports', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReportAdPage()),
                        );
                      }),
                      _buildMenuButton('Profile', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileAdScreen()),
                        );
                      }),
                      _buildMenuButton('Donations', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DonationAdPage()),
                        );
                      }),
                      _buildMenuButton('Events', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventAdScreen()),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildMenuButton(String title, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          backgroundColor: Colors.white,
          foregroundColor: Color.fromARGB(255, 148, 148, 148), // Updated the parameter
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          side: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
          textStyle: const TextStyle(
            fontSize: 18,
          //  fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(title),
      ),
    );
  }
}

Widget buildTile() {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: _text.length,
    itemBuilder: (context, index) {
      if (_text[index] == 'Reports') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ComplaintsPage()),
            );
          },
          child: ListTile(
            leading: Icon(_icons[index]),
            title: Text(_text[index]),
          ),
        );
      } else if (_text[index] ==
'Graphs') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GraphsPage()),
            );
          },
          child: ListTile(
            leading: Icon(_icons[index]),
            title: Text(_text[index]),
          ),
        );
      } 
      else if (_text[index] ==
'Manage Users') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageUsersPage()),
            );
          },
          child: ListTile(
            leading: Icon(_icons[index]),
            title: Text(_text[index]),
          ),
        );
      }
       else if (_text[index] ==
'Reservations') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReservationsPage()),
            );
          },
          child: ListTile(
            leading: Icon(_icons[index]),
            title: Text(_text[index]),
          ),
        );
      } 
       else if (_text[index] ==
'Donations') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DonationsPage()),
            );
          },
          child: ListTile(
            leading: Icon(_icons[index]),
            title: Text(_text[index]),
          ),
        );
      } 
       else if (_text[index] ==
'Taxes') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaxesPage()),
            );
          },
          child: ListTile(
            leading: Icon(_icons[index]),
            title: Text(_text[index]),
          ),
        );
      } else {
        return ListTile(
          leading: Icon(_icons[index]),
          title: Text(_text[index]),
          onTap: () {},
        );
      }
    },
  );
}

List<String> _text = [
  'Manage Users',
  'Reports',
  'Chat',
  'Orders',
  'Donations',
  'Reservations',
  'Graphs',
  'Taxes',
];

List<IconData> _icons = [
  Icons.people,
  Icons.note,
  Icons.message,
  Icons.work,
  Icons.money,
  Icons.event,
  Icons.graphic_eq_sharp,
  Icons.money_off,
];
