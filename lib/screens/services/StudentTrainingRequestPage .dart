import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';

class StudentTrainingRequestPage extends StatefulWidget {
  const StudentTrainingRequestPage({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  _StudentTrainingRequestPageState createState() => _StudentTrainingRequestPageState();
}

class _StudentTrainingRequestPageState extends State<StudentTrainingRequestPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageController = TextEditingController();
  var account = GetStorage();
  var userData;
  late Future<int> _subscriptionFeeFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionFeeFuture = fetchSubscriptionFee();
    userData = account.read('keyUser');
    print(userData);
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Request to train a student', // Provide the service name
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
          LocaleKeys.Request_to_train_a_student.tr(),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel(LocaleKeys.Name.tr(), '${userData["name"]}'),
                Divider(color: Colors.grey[300]), // Add a divider
                _buildLabel(LocaleKeys.Email.tr(), '${userData["email"]}'),
                Divider(color: Colors.grey[300]), // Add a divider
                _buildLabel(LocaleKeys.Phone_Number.tr(), '${userData["phone_number"]}'),
                Divider(color: Colors.grey[300]), // Add a divider
                SizedBox(height: 20),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.Enter_your_information.tr(),
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<int>(
                  future: _subscriptionFeeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final subscriptionFee = snapshot.data ?? 0;
                      return Text('Subscription Fee: ${subscriptionFee.toString()}');
                    }
                  },
                ),
                SizedBox(height: 190),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(221, 72, 21, 72),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text(
                    LocaleKeys.Submit_Request.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0, color: Colors.black), // Set text color to black
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16.0, color: Colors.black), // Set text color to black
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

Future<void> fetchUserDataService(
  String email, String password, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.6:3000/user/get'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print(userData);
      if (userData['name'] != null &&
          userData['address'] != null &&
          userData['phone_number'] != null) {
        final Map<String, dynamic> userDataMap = {
          'name': userData['name'],
          'address': userData['address'],
          'phone_number': userData['phone_number'],
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentTrainingRequestPage(userData: userDataMap),
          ),
        );
      } else {
        print('Invalid user data received');
      }
    } else {
      print('Failed to load user data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to fetch user data. Please try again later.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
