import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/Fees1Screen%20.dart';


import 'package:shop_app/screens/services/feess2.dart';

class FeesScreen extends StatefulWidget {
  static String routeName = "/fees";

  const FeesScreen({Key? key}) : super(key: key);

  @override
  _FeesScreenState createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  List<String> feesServices = [];

  @override
  void initState() {
    super.initState();
    fetchFeesServices();
  }

  Future<void> fetchFeesServices() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6:3000/service/getFeesServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['feesServices'] != null) {
          final List<dynamic> data = responseData['feesServices'];
          setState(() {
            feesServices = data
                .map((service) => service['serviceName'] as String)
                .toList();
          });
        } else {
          throw Exception('Response body does not contain water services');
        }
      } else {
        throw Exception(
            'Failed to load fees services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Services', style: TextStyle(color: Colors.white)),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < feesServices.length; i++)
                        Padding(
                          padding: i == 0
                              ? const EdgeInsets.only(bottom: 6.0)
                              : const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to appropriate screen based on the selected service
                              switch (feesServices[i]) {
                                case 'Fees request objection to closure':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Fees1Screen(
                                        userData: {},
                                      ),
                                    ),
                                  );
                                  break;
                                case 'Fees request to amend data':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const feess2(
                                        userData: {},
                                      ),
                                    ),
                                  );
                                  break;
                                default:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const feess2(
                                        userData: {},
                                      ),
                                    ),
                                  );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromARGB(221, 108, 107, 107),
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Purple text color
                              minimumSize: const Size(double.infinity, 60), // Larger button size
                              padding: const EdgeInsets.all(16), // Increased padding
                            ),
                            child: Text(
                              feesServices[i],
                              style: const TextStyle(
                                fontSize: 16, // Increased font size
                                fontFamily: 'Roboto', // Modern font family
                            //    fontWeight: FontWeight.w900, // Updated font weight to 500 for a modern look
                              ),
                            ),
                          ),
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
