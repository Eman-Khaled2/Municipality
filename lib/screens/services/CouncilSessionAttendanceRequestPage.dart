import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';

class CouncilSessionAttendanceRequestPage extends StatefulWidget {
  const CouncilSessionAttendanceRequestPage({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  _CouncilSessionAttendanceRequestPageState createState() => _CouncilSessionAttendanceRequestPageState();
}

class _CouncilSessionAttendanceRequestPageState extends State<CouncilSessionAttendanceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  var account = GetStorage();
  var userData;
  late Future<int> _subscriptionFeeFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionFeeFuture = fetchSubscriptionFee();
    userData = account.read('keyUser');
    print(userData);

    // Check if userData is not null before initializing controllers
    if (widget.userData != null) {
      _nameController = TextEditingController(text: widget.userData['name'] ?? '');
    } else {
      // Set default values if userData is null
      _nameController = TextEditingController();
    }
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Request to council session', // Provide the service name
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final subscriptionFee = data['subscriptionFee'] as int;
        return subscriptionFee;
      } else {
        print('Failed to load subscription fee: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching subscription fee: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.A_citizen_requested_to_attend_a_municipal_council_session.tr(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  enabled: false, // Disable editing
                  hintText:  '${userData["name"]}',
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 70, 70, 70)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _reasonController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: LocaleKeys.Reason_for_Attendance.tr(),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<int>(
                future: _subscriptionFeeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final subscriptionFee = snapshot.data ?? 0;
                    return Text(
                        'Subscription Fee: ${subscriptionFee.toString()}');
                  }
                },
              ),
              SizedBox(height: 390), // Added spacing for better visual separation
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(221, 72, 21, 72),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  String name = _nameController.text;
                  String reason = _reasonController.text;
                  // Perform actions with the entered data, like sending it to the server
                },
                child: Text(
                  LocaleKeys.Submit_Request.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionFee(int subscriptionFee) {
    return Text(
      'Subscription Fee: ${subscriptionFee.toString()}',
      style: TextStyle(fontSize: 16.0),
    );
  }
}
