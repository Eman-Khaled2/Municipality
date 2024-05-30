import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/RequestFormScreen.dart';
import 'package:shop_app/screens/services/RequestFormScreen2.dart';

class SanitationScreen extends StatefulWidget {
  static String routeName = "/sanitation";

  const SanitationScreen({Key? key}) : super(key: key);

  @override
  _SanitationScreenState createState() => _SanitationScreenState();
}

class _SanitationScreenState extends State<SanitationScreen> {
  List<String> sanServices = [];

  @override
  void initState() {
    super.initState();
    fetchWaterServices();
  }

  Future<void> fetchWaterServices() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getSanServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['sanServices'] != null) {
          final List<dynamic> data = responseData['sanServices'];
          setState(() {
            sanServices = data.map((service) => service['serviceName'] as String).toList();
          });
        } else {
          throw Exception('Response body does not contain sanitation services');
        }
      } else {
        throw Exception('Failed to load sanitation services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanitation Services', style: TextStyle(color: Colors.white)),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Adjusted height of the image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    height: 50, // Change this value as per your requirement
                
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Display water services dynamically
                      for (int i = 0; i < sanServices.length; i++)
                        Padding(
                          padding: i == 0
                              ? const EdgeInsets.only(bottom: 6.0)
                              : const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to appropriate screen based on the selected service
                              switch (sanServices[i]) {
                                case 'Sewage network connection with a facility':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RequestFormScreen(userData: {}),
                                    ),
                                  );
                                  break;
                                case 'Sewage maintenance':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RequestFormScreen2(userData: {}),
                                    ),
                                  );
                                  break;
                                default:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RequestFormScreen2(userData: {}),
                                    ),
                                  );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromARGB(221, 108, 107, 107),
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Purple text color
                              minimumSize: const Size(double.infinity, 60), // Larger button size
                              padding: const EdgeInsets.all(12), // Increased padding
                            ),
                            child: Text(
                              sanServices[i],
                              style: const TextStyle(
                                fontSize: 16, // Increased font size
                                fontFamily: 'Roboto', // Modern font family
                             //   fontWeight: FontWeight.w900, // Updated font weight to 500 for a modern look
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
