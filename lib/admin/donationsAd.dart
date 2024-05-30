import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DonationAd {
  String type;
  String description;

  DonationAd(this.type, this.description);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DonationAdPage(),
    );
  }
}

class DonationAdPage extends StatefulWidget {
  const DonationAdPage({Key? key}) : super(key: key);
  static String routeName = "/DonationAdPage";

  @override
  State<DonationAdPage> createState() => _DonationAdPageState();
}

class _DonationAdPageState extends State<DonationAdPage> {
  DonationAd? _selectedDonation;
  String? type;
  String? description;
  List<DonationAd> donations = [];

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  void fetchDonations() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:3000/user/getDonations'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> donationList = data['donations'];

      setState(() {
        donations = donationList
            .map((donation) =>
                DonationAd(donation['type'], donation['description']))
            .toList();
      });
    } else {
      throw Exception('Failed to load donations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Donations Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187),
           ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
             padding: const EdgeInsets.only(bottom: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: donations
                      .map(
                        (donation) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          donation.type,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          donation.description,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _editDonation(context, donation);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteDonation(donation);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                      .toList(),
                ),
                if (_selectedDonation != null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (type != null && type != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonationDetailsPage(
                              typeD: type ?? '',
                              description: description ?? '',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        
                        'Fill in the information for payment',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDonationDialog(context);
        },

         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),

      ),
    );
  }

  void _showAddDonationDialog(BuildContext context) {
    String newType = '';
    String newDescription = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Donation Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Type'),
                onChanged: (value) {
                  newType = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  newDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://192.168.1.6:3000/user/addDonation'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "type": newType,
                    "description": newDescription,
                  }),
                );

                if (response.statusCode == 201) {
                  setState(() {
                    donations.add(DonationAd(newType, newDescription));
                  });
                  Navigator.of(context).pop();
                } else {
                  print('Error adding donation: ${response.body}');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editDonation(BuildContext context, DonationAd donation) async {
    String type = donation.type;
    String description = donation.description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Donation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Type'),
                controller: TextEditingController(text: type),
                onChanged: (value) {
                  type = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                controller: TextEditingController(text: description),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.put(
                  Uri.parse('http://192.168.1.6:3000/user/editDonation'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "oldType": donation.type,
                    "newType": type,
                    "description": description,
                  }),
                );

               
                if (response.statusCode == 200) {
                  setState(() {
                    donation.type = type;
                    donation.description = description;
                  });
                  Navigator.of(context).pop();
                } else {
                  print('Error editing donation: ${response.body}');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteDonation(DonationAd donation) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.0.4:3000/user/deleteDonation'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "type": donation.type,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          donations.removeWhere((element) => element.type == donation.type);
        });
        print('Donation deleted successfully');
      } else {
        print('Error deleting donation: ${response.body}');
      }
    } catch (error) {
      print('Error deleting donation: $error');
    }
  }
}

class DonationDetailsPage extends StatefulWidget {
  final String? typeD;
  final String? description;

  const DonationDetailsPage({Key? key, this.typeD, this.description})
      : super(key: key);

  @override
  _DonationDetailsPageState createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dateController.text = formatDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                    hintText: "User Name",
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: amountController,
                  decoration:
                      const InputDecoration(labelText: 'Donation Amount'),
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
                      decoration: const InputDecoration(
                        labelText: 'Preferred Date for Donation',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Implement sending donation details
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                  child: const Text('Submit Donation'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
