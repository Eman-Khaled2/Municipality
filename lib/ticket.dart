import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/events.dart';

class TicketScreen extends StatefulWidget {
  @override
  static String routeName = "/ticket";

  const TicketScreen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  int _numberOfTickets = 1;
  String _selectedSeat = 'A1';
  Map<String, int> seatPrices = {
    'A': 20,
    'B': 10,
  };

  var acount = GetStorage();
  var userData;

@override
void initState() {
  super.initState();
  userData = acount.read('keyUser');
  print(userData);
  if (userData != null && userData.containsKey("name")) {
    _nameController.text = userData["name"]; // Set the user's name as the initial value of the text field
  } else {
    print("User data or 'name' key is missing.");
    // Handle the case where user data or the 'name' key is missing
  }
}

  int calculatePrice() {
    String seatCategory = _selectedSeat.substring(0, 1);
    int pricePerTicket = seatPrices[seatCategory] ?? 0;
    return pricePerTicket * _numberOfTickets;
  }

  Future<void> bookTickets() async {
    // Construct ticket data
    Map<String, dynamic> ticketData = {
      'name': _nameController.text,
      'numberOfTickets': _numberOfTickets,
      'selectedSeat': _selectedSeat,
      'price': calculatePrice(),
    };

    // Send ticket data to server
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/user/bookTicket'), // Replace with your API endpoint
        body: jsonEncode(ticketData),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print(responseData);
        final snackBar = SnackBar(
          content: Text('Booking successful for ${_nameController.text}! Total Price: \$${calculatePrice()}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventScreen()),
                  );
      } else {
        print('Failed to book tickets: ${response.statusCode}');
        final snackBar = SnackBar(
          content: Text('Failed to book tickets. Please try again later.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error booking tickets: $e');
      final snackBar = SnackBar(
        content: Text('Failed to book tickets. Please try again later. Error: $e'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ticket.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8), // Adjust as needed for spacing between label and text field
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white), // Add white border
                        borderRadius: BorderRadius.circular(8), // Optional: Add border radius
                      ),
                      child: TextField(
                        controller: _nameController,
                        enabled: false, // Make the TextField non-editable
                        decoration: InputDecoration(
                          hintText: '${userData["name"]}', // Use user's name as hint text
                          hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          border: InputBorder.none, // Remove default border
                        ),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Number of Tickets',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                DropdownButton<int>(
                  value: _numberOfTickets,
                  iconEnabledColor: Colors.white, // Set the dropdown arrow color to white
                  onChanged: (int? newValue) {
                    setState(() {
                      _numberOfTickets = newValue!;
                    });
                  },
                  items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), // Increase text size
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.black,
                ),
                SizedBox(height: 20),
                Text(
                  'Select Seat',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                DropdownButton<String>(
                  value: _selectedSeat,
                  iconEnabledColor: Colors.white, // Ensure the dropdown arrow is white
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSeat = newValue!;
                    });
                  },
                  items: <String>['A1', 'A2', 'A3', 'A4', 'B1', 'B2', 'B3', 'B4'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), // Increase text size
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.black,
                ),
                SizedBox(height: 20),
                // Container to display the price
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Price: \$${calculatePrice()}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed:bookTickets, // Call function to book tickets
                  child: Text('Book Tickets', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green[900], // Text color
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
      if (userData['name'] != null) {
        final Map<String, dynamic> userDataMap = {
          'name': userData['name'],
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TicketScreen(userData: userDataMap),
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
        content: Text(
          'Failed to fetch user data. Please try again later.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}