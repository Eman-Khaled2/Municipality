import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/events.dart';

class Ticket1Screen extends StatefulWidget {
  @override
  static String routeName = "/ticket1";

  const Ticket1Screen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<Ticket1Screen> createState() => _Ticket1ScreenState();
}

class _Ticket1ScreenState extends State<Ticket1Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  List<String> _numberOfTickets = [];
  List<String> _seats = [];
  String _selectedTicket = '';
  String _selectedSeat = '';
  int priceA = 0;
  int priceB = 0;

  var account = GetStorage();
  var userData;

  @override
  void initState() {
    super.initState();
    userData = account.read('keyUser');
    print('Logged-in user data: $userData');
    fetchTicket1Data(); // Fetch ticket data when the screen initializes
  }

  Future<void> fetchTicket1Data() async {
    try {
      final ticket1Response = await http.get(
        Uri.parse('http://192.168.1.6:3000/user/getTicket1Data'), // Adjust the URL
      );
      if (ticket1Response.statusCode == 200) {
        final ticket1Data = json.decode(ticket1Response.body);
        print('Ticket Data: $ticket1Data'); // Print the fetched ticket data
        if (ticket1Data != null && ticket1Data['ticket1Data'] is Map<String, dynamic>) {
          final data = ticket1Data['ticket1Data']; // Access the ticket data directly
          setState(() {
            _numberOfTickets = List<String>.from(data['numberOfTickets'] ?? []);
            _seats = List<String>.from(data['seats'] ?? []);
            print('_numberOfTickets length: ${_numberOfTickets.length}');
            print('_seats length: ${_seats.length}');
            print('_numberOfTickets: $_numberOfTickets');
            print('_seats: $_seats');
            priceA = int.tryParse(data['priceA'].toString()) ?? 0;
            priceB = int.tryParse(data['priceB'].toString()) ?? 0;
            _selectedTicket = _numberOfTickets.isNotEmpty ? _numberOfTickets.first : '';
            _selectedSeat = _seats.isNotEmpty ? _seats.first : '';
            print('_selectedTicket: $_selectedTicket');
            print('_selectedSeat: $_selectedSeat');
          });
        } else {
          print('Invalid ticket data format');
        }
      } else {
        print('Failed to load ticket data: ${ticket1Response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ticket data: $e');
    }
  }

  int calculatePrice() {
    // Extract the seat category from the selected seat
    String seatCategory = _selectedSeat.isNotEmpty ? _selectedSeat.substring(0, 1) : '';
    
    // Determine the price per ticket based on the seat category
    int pricePerTicket = seatCategory == 'A' ? priceA : priceB;
    
    // Calculate the total price by multiplying the price per ticket by the number of tickets
    return pricePerTicket * (_selectedTicket.isNotEmpty ? int.parse(_selectedTicket) : 0);
  }

  Future<void> bookTickets() async {
    // Construct ticket data
    Map<String, dynamic> ticketData = {
      'name': _nameController.text,
      'numberOfTickets': _numberOfTickets.length,
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
        print('Booking response: $responseData');
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
                DropdownButton<String>(
                  value: _selectedTicket,
                  iconEnabledColor: Colors.white, // Set the dropdown arrow color to white
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTicket = newValue!;
                    });
                  },
                  items: _numberOfTickets
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), // Increase text size
                          ),
                        );
                      })
                      .toList(),
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
                  items: _seats
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), // Increase text size
                          ),
                        );
                      })
                      .toList(),
                  dropdownColor: Colors.black,
                ),
                SizedBox(height: 20),
                // Container to display the price
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 239, 232),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Price: \$${calculatePrice()}',
                    style: TextStyle(color: Color.fromARGB(255, 52, 0, 72), fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: bookTickets, // Call function to book tickets
                  child: Text('Book Tickets', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 52, 0, 72), backgroundColor: const Color.fromARGB(255, 239, 242, 239), // Text color
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
      print('User data response: $userData');
      if (userData['name'] != null) {
        // Fetch ticket data from MongoDB
        final ticketResponse = await http.get(
          Uri.parse('http://192.168.1.6:3000/user/getTicket1Data'), // Adjust the URL
        );
        if (ticketResponse.statusCode == 200) {
          final ticketData = json.decode(ticketResponse.body);
          final Map<String, dynamic> userDataMap = {
            'name': userData['name'],
            'ticketData': ticketData, // Pass ticket data to TicketScreen
          };
          print('Ticket data response: $ticketData');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Ticket1Screen(userData: userDataMap),
            ),
          );
        } else {
          print('Failed to load ticket data: ${ticketResponse.statusCode}');
        }
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
