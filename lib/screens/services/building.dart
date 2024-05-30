import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/report.dart';
import 'package:shop_app/screens/services/CustomButton.dart';
import 'package:shop_app/screens/services/NewBuildingPermitScreen%20.dart';

class BuildingScreen extends StatefulWidget {
  static String routeName = "/building";

  const BuildingScreen({Key? key}) : super(key: key);

  @override
  _BuildingScreenState createState() => _BuildingScreenState();
}

class _BuildingScreenState extends State<BuildingScreen> {
  List<String> buiServices = [];

  @override
  void initState() {
    super.initState();
    fetchBuiServices();
  }

  Future<void> fetchBuiServices() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6:3000/service/getBuiServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['buiServices'] != null) {
          final List<dynamic> data = responseData['buiServices'];
          setState(() {
            buiServices = data
                .map((service) => service['serviceName'] as String)
                .toList();
          });
        } else {
          throw Exception('Response body does not contain building services');
        }
      } else {
        throw Exception(
            'Failed to load building services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Building Services',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0), // Add padding horizontally
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 0), // Add spacing from top
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                        ),
                        const SizedBox(height: 15),
                        for (int i = 0; i < buiServices.length; i++)
                          Padding(
                            padding: i == 0
                                ? const EdgeInsets.only(bottom: 6.0)
                                : const EdgeInsets.symmetric(vertical: 4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                switch (buiServices[i]) {
                                  case 'Building permit':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NewBuildingPermitScreen(
                                                  userData: {})),
                                    );
                                    break;
                                  case 'Building complaint':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const ReportScreen()),
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
                                backgroundColor: const Color.fromARGB(
                                    255, 255, 255, 255),
                                minimumSize: const Size(
                                    double.infinity, 60),
                                padding:
                                    const EdgeInsets.all(16),
                              ),
                              child: Text(
                                buiServices[i],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                //  fontWeight: FontWeight
                                //      .w900,
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
      ),
    );
  }
}
