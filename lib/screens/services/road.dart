import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/CustomButton.dart';
import 'package:shop_app/screens/services/CustomButton2.dart';

class RoadScreen extends StatefulWidget {
  static String routeName = "/road";

  const RoadScreen({Key? key}) : super(key: key);

  @override
  _RoadScreenState createState() => _RoadScreenState();
}

class _RoadScreenState extends State<RoadScreen> {
  List<String> streetServices = [];

  @override
  void initState() {
    super.initState();
    fetchStreetServices();
  }

  Future<void> fetchStreetServices() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/service/getStreetServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['streetServices'] != null) {
          final List<dynamic> data = responseData['streetServices'];
          setState(() {
            streetServices = data.map((service) => service['serviceName'] as String).toList();
          });
        } else {
          throw Exception('Response body does not contain street services');
        }
      } else {
        throw Exception('Failed to load street services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Street Services', style: TextStyle(color: Colors.white)),
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
                // Adjusted height of the image with curved edges and padding
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0), // Adjusted padding for space between image and app bar
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0), // Set border radius for curved edges
                  
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Display street services dynamically
                      for (int i = 0; i < streetServices.length; i++)
                        Padding(
                          padding: i == 0
                              ? const EdgeInsets.only(bottom: 6.0)
                              : const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to appropriate screen based on the selected service
                              switch (streetServices[i]) {
                                case 'Street paving':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UserInputPage(
                                        userData: {},
                                        pageTitle: '',
                                      ),
                                    ),
                                  );
                                  break;
                                case 'Street build':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UserInputPage2(
                                        userData: {},
                                        pageTitle: '',
                                      ),
                                    ),
                                  );
                                  break;
                                default:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UserInputPage2(
                                        userData: {},
                                        pageTitle: '',
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
                              streetServices[i],
                              style: const TextStyle(
                                fontSize: 16, // Increased font size
                                fontFamily: 'Roboto', // Modern font family
                              //  fontWeight: FontWeight.w900, // Updated font weight to 500 for a modern look
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
