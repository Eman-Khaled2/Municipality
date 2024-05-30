import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvertisementsPage(),
    );
  }
}

class AdvertisementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advertisements',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchAdvertisements(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> advertisements = snapshot.data ?? [];
            return ListView.builder(
              itemCount: advertisements.length,
              itemBuilder: (BuildContext context, int index) {
                return AdvertisementWidget(advertisement: advertisements[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class AdvertisementWidget extends StatelessWidget {
  final dynamic advertisement;

  AdvertisementWidget({required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToAdvertisementDetails(context, advertisement);
      },
      child: Card(
     
       color: Color.fromARGB(255, 245, 232, 245),
        elevation: 4.0,
        margin: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              advertisement['image'],
              fit: BoxFit.cover,
              height: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    advertisement['title'],
                    style: const TextStyle(
                      fontSize: 20,

                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    advertisement['details'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (advertisement['price'] != '0')
                    Text(
                      'Price: \$${advertisement['price']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _openFacebookPage(advertisement['link']);
                    },
                    child: Text('Visit Facebook Page'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAdvertisementDetails(BuildContext context, dynamic advertisement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertisementDetailsPage(advertisement: advertisement),
      ),
    );
  }

  void _openFacebookPage(String facebookLink) async {
    try {
      if (await canLaunch(facebookLink)) {
        await launch(facebookLink);
      } else {
        throw 'Could not launch $facebookLink';
      }
    } catch (e) {
      print('Error opening Facebook page: $e');
      // If opening the link in the app fails, try opening it in a web browser
      await launch(facebookLink, forceSafariVC: false);
    }
  }
}

class AdvertisementDetailsPage extends StatelessWidget {
  final dynamic advertisement;

  AdvertisementDetailsPage({required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(advertisement['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              advertisement['image'],
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              advertisement['details'] ,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<dynamic>> fetchAdvertisements() async {
  final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getAdv'));

  if (response.statusCode == 200) {
    return json.decode(response.body)['advertisements'];
  } else {
    throw Exception('Failed to load advertisements');
  }
}