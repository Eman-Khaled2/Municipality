import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:http/http.dart' as http;

class PermitRequestPage extends StatefulWidget {
  @override
  static String routeName = "/request_permit";

  const PermitRequestPage({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  State<PermitRequestPage> createState() => _PermitRequestPage();
}

class _PermitRequestPage extends State<PermitRequestPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _requestController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

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
      _addressController =
          TextEditingController(text: widget.userData['address'] ?? '');
      _phoneController =
          TextEditingController(text: widget.userData['phone_number'] ?? '');
    } else {
      // Set default values if userData is null
      _nameController = TextEditingController();
      _addressController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  Future<int> fetchSubscriptionFee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/service/get'),
        body: jsonEncode({
          'serviceName': 'Electricity permit', // Provide the service name
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
        title: Text(LocaleKeys.Requesting_a_permit_to_work_on_3_phase_electricity.tr(),
            style: TextStyle(color: Colors.white)), // Set text color to white
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              LocaleKeys.Name.tr(),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Text(
              '${userData["name"]}',
              style: TextStyle(fontSize: 16.0),
            ),
            Divider(color: Colors.grey[300]), // Add divider
            SizedBox(height: 20),
            Text(
              LocaleKeys.Address.tr(),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Text(
              '${userData["address"]}',
              style: TextStyle(fontSize: 16.0),
            ),
            Divider(color: Colors.grey[300]), // Add divider
            SizedBox(height: 20),
            Text(
              LocaleKeys.Phone_Number.tr(),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Text(
              '${userData["phone_number"]}',
              style: TextStyle(fontSize: 16.0),
            ),
            Divider(color: Colors.grey[300]), // Add divider
            SizedBox(height: 20),
            Text(
              LocaleKeys.Please_fill_out_the_form_below_to_request_a_permit_to_work_on_phase_electricity.tr(),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextFormField(
                controller: _requestController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: LocaleKeys.Enter_your_request_here.tr(),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _subscriptionFeeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final subscriptionFee = snapshot.data ?? 0;
                  return _buildSubscriptionFee(subscriptionFee);
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add your submit action here
              },
              style: ElevatedButton.styleFrom(
               
                  foregroundColor: Color.fromARGB(221, 72, 21, 72),
                          backgroundColor: Color.fromARGB(255, 255, 255, 255), // Purple text color
                
              ),
              child: Text(LocaleKeys.Submit_Request.tr()),
            ),
            SizedBox(height: 20),
            
          ],
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
            builder: (_) => PermitRequestPage(userData: userDataMap),
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
