import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:http/http.dart' as http;

class SponsoredAdScreen extends StatefulWidget {
  static String routeName = "/sponsored";

  const SponsoredAdScreen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<SponsoredAdScreen> createState() => _SponsoredAdScreenState();
}

class _SponsoredAdScreenState extends State<SponsoredAdScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  var account = GetStorage();
  late Map<String, dynamic> userData;
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
          'serviceName': 'Advertisement request of sponsered type', // Provide the service name
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
    String subscriptionFee = LocaleKeys.Pric.tr();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          LocaleKeys.Request_a_sponsored_advertisement.tr(),
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
            color: Colors.white), // Change the arrow color to white
        systemOverlayStyle:
            SystemUiOverlayStyle.light, // Change the AppBar's text color to white
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
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocaleKeys.Requestor_Information.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildLabel(LocaleKeys.Name.tr(), '${userData["name"]}'),
                  Divider(),
                  _buildLabel(LocaleKeys.Phone_Number.tr(),
                      '${userData["phone_number"]}'),
                  Divider(),
                  TextFormField(
                    controller: _companyController,
                    decoration:
                        InputDecoration(labelText: LocaleKeys.Company_Name.tr()),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        labelText: LocaleKeys.Details_about_advertisement.tr()),
                    maxLines: 5,
                  ),
                  SizedBox(height: 20.0),
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
                  SizedBox(height: 217),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      child: Text(LocaleKeys.Submit_Request.tr()),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(221, 72, 21, 72),
                        backgroundColor:
                            Color.fromARGB(255, 255, 255, 255), // Purple text color
                      ),
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

  Widget _buildSubscriptionFee(int subscriptionFee) {
    return Text(
      'Subscription Fee: ${subscriptionFee.toString()}',
      style: TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 5.0),
        Text(
          value,
          style: TextStyle(
              fontSize: 16.0, color: Colors.black), // Set text color to black
        ),
        SizedBox(height: 10.0),
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
            builder: (_) => SponsoredAdScreen(userData: userDataMap),
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
