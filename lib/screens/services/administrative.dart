import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/services/CouncilSessionAttendanceRequestPage.dart';
import 'package:shop_app/screens/services/CustomButton.dart';
import 'package:shop_app/screens/services/ResidenceCertificatePage%20.dart';
import 'package:shop_app/screens/services/SocialStatusCertificatePage.dart';
import 'package:shop_app/screens/services/StudentTrainingRequestPage%20.dart';

class Administrative extends StatefulWidget {
  static String routeName = "/administrative";

  const Administrative({Key? key}) : super(key: key);

  @override
  _AdministrativeScreenState createState() => _AdministrativeScreenState();
}

class _AdministrativeScreenState extends State<Administrative> {
  List<String> adServices = [];

  @override
  void initState() {
    super.initState();
    fetchWaterServices();
  }

  Future<void> fetchWaterServices() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6:3000/service/getAdServices'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Response Data: $responseData');
        if (responseData != null && responseData['adServices'] != null) {
          final List<dynamic> data = responseData['adServices'];
          setState(() {
            adServices = data
                .map((service) => service['serviceName'] as String)
                .toList();
          });
        } else {
          throw Exception(
              'Response body does not contain administrative services');
        }
      } else {
        throw Exception(
            'Failed to load administrative services. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrative Services',
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 1, // Change this value as per your requirement
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      const SizedBox(height: 15),
                      for (int i = 0; i < adServices.length; i++)
                        Padding(
                          padding: i == 0
                              ? const EdgeInsets.only(bottom: 6.0)
                              : const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              switch (adServices[i]) {
                                case 'Request to council session':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CouncilSessionAttendanceRequestPage(
                                              userData: {},
                                            )),
                                  );
                                  break;
                                case 'Request to residence certificate':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResidenceCertificatePage(
                                              userData: {},
                                            )),
                                  );
                                  break;

                                case 'Request to train a student':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const StudentTrainingRequestPage(
                                              userData: {},
                                            )),
                                  );
                                  break;
                                case 'Request to certificate of marital status':
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SocialStatusCertificatePage(
                                              userData: {},
                                            )),
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
                                  255, 255, 255, 255), // Purple text color
                              minimumSize: const Size(
                                  double.infinity, 60), // Larger button size
                              padding:
                                  const EdgeInsets.all(16), // Increased padding
                            ),
                            child: Text(
                              adServices[i],
                              style: const TextStyle(
                                fontSize: 16, // Increased font size
                                fontFamily: 'Roboto', // Modern font family
                              //  fontWeight: FontWeight
                             //       .w900,
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
