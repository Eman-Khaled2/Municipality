import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/events.dart';

class Ticket2Screen extends StatefulWidget {
  static String routeName = "/ticket2";

  const Ticket2Screen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<Ticket2Screen> createState() => _Ticket2ScreenState();
}

class _Ticket2ScreenState extends State<Ticket2Screen> {
  final TextEditingController _nameController = TextEditingController();
  List<String> _numberOfTickets = [];
  List<String> _seats = [];
  String _selectedTicket = '';
  String _selectedSeat = '';
  int priceA = 0;
  int priceB = 0;

  @override
  void initState() {
    super.initState();
    fetchTicketData();
  }

  Future<void> fetchTicketData() async {
    try {
      final ticketResponse = await http.get(
        Uri.parse('http://192.168.1.6:3000/user/getTicket2Data'),
      );
      if (ticketResponse.statusCode == 200) {
        final ticketData = json.decode(ticketResponse.body);
        print('Ticket Data: $ticketData');
        if (ticketData != null && ticketData['ticket2Data'] is Map<String, dynamic>) {
          final data = ticketData['ticket2Data'];
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
        print('Failed to load ticket data: ${ticketResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching ticket data: $e');
    }
  }

  int calculatePrice() {
    String seatCategory = _selectedSeat.isNotEmpty ? _selectedSeat.substring(0, 1) : '';
    int pricePerTicket = seatCategory == 'A' ? priceA : priceB;
    return pricePerTicket * (_selectedTicket.isNotEmpty ? int.parse(_selectedTicket) : 0);
  }

  Future<void> bookTickets() async {
    Map<String, dynamic> ticketData = {
      'name': _nameController.text,
      'numberOfTickets': _numberOfTickets.length,
      'selectedSeat': _selectedSeat,
      'price': calculatePrice(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/user/bookTicket'),
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
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _nameController,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: '${widget.userData["name"]}',
                          hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          border: InputBorder.none,
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
                  iconEnabledColor: Colors.white,
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
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
                  iconEnabledColor: Colors.white,
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
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        );
                      })
                      .toList(),
                  dropdownColor: Colors.black,
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 247, 237),
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
                  onPressed: bookTickets,
                  child: Text('Book Tickets', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 52, 0, 72),
                    backgroundColor: Color.fromARGB(255, 239, 242, 239),
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
        final ticketResponse = await http.get(
          Uri.parse('http://192.168.1.6:3000/user/getTicket2Data'),
        );
        if (ticketResponse.statusCode == 200) {
          final ticketData = json.decode(ticketResponse.body);
          final Map<String, dynamic> userDataMap = {
            'name': userData['name'],
            'ticketData': ticketData,
          };
          print('Ticket data response: $ticketData');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Ticket2Screen(userData: userDataMap),
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
