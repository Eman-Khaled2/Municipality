import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';

class SocialStatusCertificatePage extends StatefulWidget {
  const SocialStatusCertificatePage({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  _SocialStatusCertificatePageState createState() => _SocialStatusCertificatePageState();
}

class _SocialStatusCertificatePageState extends State<SocialStatusCertificatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  String? _maritalStatus; // استخدام نوع البيانات الاختيارية

  var acount = GetStorage();
  var userData;
  late Future<int> _subscriptionFeeFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionFeeFuture = fetchSubscriptionFee();
    userData = acount.read('keyUser');
    print(userData);

    // Check if userData is not null before initializing controllers
    if (widget.userData != null) {
      _nameController =
          TextEditingController(text: widget.userData['name'] ?? '');
      _idController =
          TextEditingController(text: widget.userData['id'] ?? '');
    } else {
      // Set default values if userData is null
      _nameController = TextEditingController();
      _idController = TextEditingController();
    }
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Request to certificate of marital status', // Provide the service name
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
          LocaleKeys.Certificate_of_marital_status.tr(),
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
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 187, 168, 187)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.black, // Set text color to black
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabled: false, // Disable editing
                    labelText: '${userData["name"]}',
                    labelStyle: TextStyle(color: Colors.black), // Set label text color
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Id',
                  style: TextStyle(
                    color: Colors.black, // Set text color to black
                  ),
                ),
                TextField(
                  controller: _idController,
                  enabled: false, // Disable editing
                  decoration: InputDecoration(
                    labelText: '${userData["id"]}',
                    labelStyle: TextStyle(color: Colors.black), // Set label text color
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _maritalStatus,
                  onChanged: (newValue) {
                    setState(() {
                      _maritalStatus = newValue;
                    });
                  },
                  items: <String?>['Married', 'Single']
                      .map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value ??
                          '', // استخدام قيمة افتراضية في حال كانت القيمة الحالية 'null'
                      child: Text(value ?? ''),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: LocaleKeys.Marital_Status.tr(),
                    labelStyle: TextStyle(color: Colors.black), // Set label text color
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
                SizedBox(height: 370),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(221, 72, 21, 72),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // يمكنك هنا إرسال البيانات المدخلة إلى الخادم أو معالجتها بأي طريقة أخرى
                    String name = _nameController.text;
                    String id = _idController.text;
                    String? maritalStatus =
                        _maritalStatus; // تعديل النوع إلى اختياري
                    // قم بمعالجة البيانات هنا...
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

  Widget _buildSubscriptionFee(int subscriptionFee) {
    return Text(
      'Subscription Fee: ${subscriptionFee.toString()}',
      style: TextStyle(fontSize: 16.0),
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
            builder: (_) => SocialStatusCertificatePage(userData: userDataMap),
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
