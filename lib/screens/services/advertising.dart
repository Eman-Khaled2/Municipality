import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/CustomButton.dart';
import 'package:shop_app/screens/services/SponsoredAdScreen%20.dart';
import 'package:shop_app/screens/services/UnfadedAdScreen.dart';

class Advertising extends StatefulWidget {
  static String routeName = "/advertising";

  const Advertising({Key? key}) : super(key: key);

  @override
  _AdvertisingScreenState createState() => _AdvertisingScreenState();
}

class _AdvertisingScreenState extends State<Advertising> {
  List<String> advServices = [];

  @override
  void initState() {
    super.initState();
    fetchAdvServices();
  }

  Future<void> fetchAdvServices() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6:3000/service/getAdvServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['advServices'] != null) {
          final List<dynamic> data = responseData['advServices'];
          setState(() {
            advServices = data
                .map((service) => service['serviceName'] as String)
                .toList();
          });
        } else {
          throw Exception(
              'Response body does not contain advertising services');
        }
      } else {
        throw Exception(
            'Failed to load advertising services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertising Services',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1000 / 9,
                  // Placeholder for your AspectRatio widget
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        // Placeholder for your container
                      ),
                      const SizedBox(height: 1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < advServices.length; i++)
                            Padding(
                              padding: i == 0
                                  ? const EdgeInsets.only(bottom: 6.0)
                                  : const EdgeInsets.symmetric(vertical: 4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  switch (advServices[i]) {
                                    case 'Advertisement request of sponsered type':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SponsoredAdScreen(userData: {})),
                                      );
                                      break;
                                    case 'Advertisement request of unfaded type':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UnfadedAdScreen(userData: {})),
                                      );
                                      break;
                                    default:
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const UserInputPage(
                                              userData: {},
                                              pageTitle: '',
                                            )),
                                      );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(221, 108, 107, 107),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  minimumSize: const Size(double.infinity, 60),
                                  padding: const EdgeInsets.all(16),
                                ),
                                child: Text(
                                  advServices[i],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                //    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
