import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';

class Donation {
  final String type;
  final String description; // Added description field

  Donation(this.type, this.description); // Updated constructor
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DonationPage(),
    );
  }
}

class DonationPage extends StatefulWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  List<Donation> donations = [];
  String? selectedDescription;

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:3000/user/getDonations'));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      if (data is List) {
        setState(() {
          donations = data
              .map((item) => Donation(item['type'], item['description']))
              .toList(); // Updated to include description
        });
      } else if (data is Map && data.containsKey('donations')) {
        final dynamic donationsData = data['donations'];
        if (donationsData is List) {
          setState(() {
            donations = donationsData
                .map((item) => Donation(item['type'], item['description']))
                .toList(); // Updated to include description
          });
        } else {
          print(
              'Failed to fetch donations: "donations" key does not contain a list');
        }
      } else {
        print(
            'Failed to fetch donations: Response does not contain a list of donations');
      }
    } else {
      print('Failed to fetch donations: ${response.statusCode}');
    }
  }

  Donation? _selectedDonation;
  String? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Donations_page.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD3D3D3), // Light Gray
              Color.fromARGB(255, 187, 168, 187),
            ], // Adjust colors as needed
          ),
        ),
        child: Center( // Center the contents of the page
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [   
                Container(
                  margin: EdgeInsets.only(bottom: 190.0), // Adjust margin as needed

                
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: donations.map((donation) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              type = donation.type;
                              _selectedDonation = donation;
                              selectedDescription = donation
                                  .description; // Set description when button is pressed
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            fixedSize: Size.fromHeight(50), // Adjust height as needed
                          ),
                          child: Text(
                            donation.type,
                            style: TextStyle(fontSize: 17), // Adjust font size as needed
                          ),
                        ),
                        SizedBox(height: 20), // Add space between buttons
                      ],
                    );
                  }).toList(),
                ),
                if (_selectedDonation != null &&
                    selectedDescription !=
                        null) // Display description before the "Fill in the information for payment" button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: Text(
                      selectedDescription!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (_selectedDonation != null) ...[
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (type != null && type != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonationDetailsPage(
                              typeD: type ?? '',
                            ),
                          ),
                        );
                        print(type);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      child: Text(
                        'Fill in the information for payment',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DonationDetailsPage extends StatefulWidget {
  final String? typeD;

  const DonationDetailsPage({Key? key, this.typeD}) : super(key: key);

  @override
  _DonationDetailsPageState createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  var account = GetStorage();
  late DateTime selectedDate;
  var userData;

  @override
  void initState() {
    super.initState();
    userData = account.read('keyUser');
    selectedDate = DateTime.now();
    dateController.text = formatDate(selectedDate);
  }

  Future<dynamic> funSend(String typeD) async {
    const apiUrl = 'http://192.168.1.6:3000/user/submitDonation';
    var ret;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "type": typeD,
          "userName": userData["name"],
          "address": userData["address"],
          "preferredDate": dateController.text,
          "donationAmount": int.tryParse(amountController.text) ??
              0, // Ensure conversion to integer
        }),
      );
      if (response.statusCode == 200)
   {
          var da = json.decode(response.body);
          ret = da["msg"];
        } else {
          ret = "Error: ${response.body}";
        }
      } catch (error) {
        print('Error occurred: $error');
        ret = 'Error: $error';
      }

      return ret;
    }

    String? _validateDonationAmount(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter an amount.';
      }
      if (int.tryParse(value) == null) {
        return 'Please enter a valid number.';
      }
      return null;
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.Donation_Details.tr(),
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFD3D3D3), // Light Gray
                Color.fromARGB(255, 187, 168, 187),
              ], // Adjust colors as needed
            ),
          ),
          padding: const EdgeInsets.all(20.0), // Adjust padding as needed
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 400.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: userData["name"] ?? "",
                        border: const OutlineInputBorder(),
                      ),
                      enabled: false,
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: _validateDonationAmount,
                      controller: amountController,
                      decoration: InputDecoration(
                          labelText: LocaleKeys.Donation_Amount.tr()),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: userData["address"] ?? "",
                        border: const OutlineInputBorder(),
                      ),
                      enabled: false,
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 10),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            dateController.text = formatDate(selectedDate);
                          });
                        }
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.Preferred_Date_for_Donation.tr(),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var response = await funSend(widget.typeD ?? '');
                          _showDialog(
                              response, response.toLowerCase().contains('success'));
                        }
                      },
                      child: Text(LocaleKeys.Submit_Donation.tr()),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    String formatDate(DateTime dateTime) {
      return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    }

    void _showDialog(String message, bool isSuccess) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(isSuccess ? 'Success' : 'Error'),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
