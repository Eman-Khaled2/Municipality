import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';

class ResidenceCertificatePage extends StatefulWidget {
  const ResidenceCertificatePage({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  _ResidenceCertificatePageState createState() => _ResidenceCertificatePageState();
}

class _ResidenceCertificatePageState extends State<ResidenceCertificatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idController = TextEditingController();

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
      _idController = TextEditingController(text: widget.userData['id'] ?? '');
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
          'serviceName': 'Request to residence certificate', // Provide the service name
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
          LocaleKeys.Residence_certificate.tr(),
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
                enabled: false, // Disable editing
                decoration: InputDecoration(
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
              SizedBox(height: 390),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromARGB(221, 72, 21, 72),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // الإجراء الذي سيتم تنفيذه عند الضغط على زر إرسال
                  String name = _nameController.text;
                  String id = _idController.text;
                  // يمكنك استخدام البيانات المدخلة هنا، مثلاً إرسالها إلى قاعدة البيانات أو معالجتها بطريقة أخرى
                },
                child: Text(LocaleKeys.Submit_Request.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
