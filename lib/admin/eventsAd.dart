import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/admin/ticketAd.dart';
import 'package:shop_app/auction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EventAdScreen(),
    );
  }
}

class EventAdScreen extends StatefulWidget {
  static String routeName = "/eventad";

  const EventAdScreen({Key? key}) : super(key: key);

  @override
  _EventAdScreenState createState() => _EventAdScreenState();
}

class _EventAdScreenState extends State<EventAdScreen> {
  late Future<List<Map<String, dynamic>>> _futureEvents;
  late TextEditingController _searchController;
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _monthController;
  late TextEditingController _timeController;
  late TextEditingController _imageController;

  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _futureEvents = fetchEvents();
    _searchController = TextEditingController();
    _titleController = TextEditingController();
    _dateController = TextEditingController();
    _monthController = TextEditingController();
    _timeController = TextEditingController();
    _imageController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _monthController.dispose();
    _timeController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addEvent() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.6:3000/user/addEvent'),
      body: jsonEncode({
        'title': _titleController.text,
        'date': _dateController.text,
        'month': _monthController.text,
        'time': _timeController.text,
        'image': _imageController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _titleController.clear();
        _dateController.clear();
        _monthController.clear();
        _timeController.clear();
        _imageController.clear();
      });
      _futureEvents = fetchEvents();
    } else {
      print('Failed to add event. Error: ${response.statusCode}');
    }
  }

  Future<void> _deleteEvent(String eventTitle) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.6:3000/user/deleteEvent'),
      body: jsonEncode({'title': eventTitle}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _events.removeWhere((event) => event['title'] == eventTitle);
      });
    } else {
      print('Failed to delete event. Error: ${response.statusCode}');
    }
  }

  Future<void> _updateEvent(Map<String, dynamic> updatedEventData) async {
    final response = await http.put(
      Uri.parse('http://192.168.1.6:3000/user/updateEvent'),
      body: jsonEncode(updatedEventData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      setState(() {
        int index = _events.indexWhere((event) => event['title'] == updatedEventData['title']);
        if (index != -1) {
          _events[index] = updatedEventData;
        }
      });
    } else {
      print('Failed to update event. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Events',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187)
            ], // Adjust colors as needed
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              height: 65,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  color: const Color.fromARGB(255, 255, 255, 255)),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Search Event',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '        Upcoming Events',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.5),
            ),
            SizedBox(height: 12.5),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureEvents,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    _events = snapshot.data ?? [];
                    List<Map<String, dynamic>> filteredEvents =
                        _searchController.text.isNotEmpty
                            ? _events
                                .where((event) => event['title']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(
                                        _searchController.text.toLowerCase()))
                                .toList()
                            : _events;
                    return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EventListItem(
                          event: filteredEvents[index],
                          onDelete: () {
                            _deleteEvent(filteredEvents[index]['title']);
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEventScreen(
                                  event: filteredEvents[index],
                                  onUpdate: (updatedEventData) {
                                    setState(() {});
                                    _updateEvent(updatedEventData);
                                  },
                                ),
                              ),
                            );
                          },
                          onTicket: index < 3
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TicketAdScreen(userData: {}, onSaveChanges: (Map<String, dynamic> updatedData) {  },)),
                                  );
                                }
                              : null,
                          onAuction: index == 3
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AuctionScreen()),
                                 
);
}
: null,
);
},
);
}
},
),
),
],
),
),
floatingActionButton: FloatingActionButton(
onPressed: () {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text('Add New Event'),
content: SingleChildScrollView(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: _titleController,
decoration: InputDecoration(labelText: 'Title'),
),
TextField(
controller: _dateController,
decoration: InputDecoration(labelText: 'Date'),
),
TextField(
controller: _monthController,
decoration: InputDecoration(labelText: 'Month'),
),
TextField(
controller: _timeController,
decoration: InputDecoration(labelText: 'Time'),
),
TextField(
controller: _imageController,
decoration: InputDecoration(labelText: 'Image URL'),
),
],
),
),
actions: <Widget>[
TextButton(
onPressed: () {
Navigator.of(context).pop();
},
child: Text('Cancel'),
),
ElevatedButton(
onPressed: () {
_addEvent();
Navigator.of(context).pop();
},
child: Text('Add'),
),
],
);
},
);
},
backgroundColor: const Color.fromARGB(255, 255, 255, 255),
child: Icon(Icons.add),
),
);
}
}

class EventListItem extends StatefulWidget {
final Map<String, dynamic> event;
final VoidCallback onDelete;
final VoidCallback onEdit;
final VoidCallback? onTicket;
final VoidCallback? onAuction;

const EventListItem({
Key? key,
required this.event,
required this.onDelete,
required this.onEdit,
this.onTicket,
this.onAuction,
}) : super(key: key);

@override
_EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
bool isExpanded = false;

@override
Widget build(BuildContext context) {
return Column(
children: [
ListTile(
title: Text(widget.event['title'] ?? ''),
trailing: IconButton(
icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
onPressed: () {
setState(() {
isExpanded = !isExpanded;
});
},
),
),
if (isExpanded)
Column(
children: [
Image.asset(widget.event['image'] ?? ''),
Text('Date: ${widget.event['date']} ${widget.event['month']}'),
Text('Time: ${widget.event['time']}'),
Row(
mainAxisAlignment: MainAxisAlignment.end,
children: [
IconButton(
icon: Icon(Icons.edit),
onPressed: widget.onEdit,
),
IconButton(
icon: Icon(Icons.delete),
onPressed: widget.onDelete,
),
if (widget.onTicket != null)
ElevatedButton(
onPressed: widget.onTicket!,
child: Text('Tickets'),
),
if (widget.onAuction != null)
ElevatedButton(
onPressed: widget.onAuction!,
child: Text('Auction'),
),
],
),
],
),
],
);
}
}

class EditEventScreen extends StatefulWidget {
final Map<String, dynamic> event;
final Function(Map<String, dynamic>) onUpdate;

const EditEventScreen({Key? key, required this.event, required this.onUpdate})
: super(key: key);

@override
_EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
late TextEditingController _titleController;
late TextEditingController _dateController;
late TextEditingController _monthController;
late TextEditingController _timeController;
late TextEditingController _imageController;

@override
void initState() {
super.initState();
_titleController = TextEditingController(text: widget.event['title']);
_dateController = TextEditingController(text: widget.event['date']);
_monthController = TextEditingController(text: widget.event['month']);
_timeController = TextEditingController(text: widget.event['time']);
_imageController = TextEditingController(text: widget.event['image']);
}

@override
void dispose() {
_titleController.dispose();
_dateController.dispose();
_monthController.dispose();
_timeController.dispose();
_imageController.dispose();
super.dispose();
}

Future<void> _updateEvent() async {
final updatedEventData = {
'id': widget.event['id'],
'title': _titleController.text,
'date': _dateController.text,
'month': _monthController.text,
'time': _timeController.text,
'image': _imageController.text,
};


widget.onUpdate(updatedEventData);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
backgroundColor: Colors.green,
iconTheme: IconThemeData(color: Colors.white),
title: Text(
'Edit Event',
style: TextStyle(color: Colors.white),
),
),
body: SingleChildScrollView(
padding: EdgeInsets.all(20.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
TextField(
controller: _titleController,
decoration: InputDecoration(labelText: 'Title'),
),
TextField(
controller: _dateController,
decoration: InputDecoration(labelText: 'Date'),
),
TextField(
controller: _monthController,
decoration: InputDecoration(labelText: 'Month'),
),
TextField(
controller: _timeController,
decoration: InputDecoration(labelText: 'Time'),
),
TextField(
controller: _imageController,
decoration: InputDecoration(labelText: 'Image URL'),
),
SizedBox(height: 30.0),
ElevatedButton(
onPressed: _updateEvent,
child: Text('Update Event'),
),
],
),
),
);
}
}

Future<List<Map<String, dynamic>>> fetchEvents() async {
final response =
await http.get(Uri.parse('http://192.168.1.6:3000/user/getEvent'));
if (response.statusCode == 200) {
return List<Map<String, dynamic>>.from(
jsonDecode(response.body)['events'].asMap().entries.map((entry) {
Map<String, dynamic> event = Map.from(entry.value);
event['id'] = entry.key;
return event;
}).toList());
} else {
throw Exception('Failed to load events');
}
}