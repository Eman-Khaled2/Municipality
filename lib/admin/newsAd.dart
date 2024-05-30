import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/translation/locale_keys.g.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'resources/langs',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const NewsAdPage(),
    );
  }
}

class NewsAdPage extends StatefulWidget {
  static String routeName = "/News";

  const NewsAdPage({super.key});

  @override
  _NewsAdPageState createState() => _NewsAdPageState();
}

class _NewsAdPageState extends State<NewsAdPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> events = [];
  bool isLoading = true;
  String errorText = '';
  int _currentEventIndex = 0;

  Future<void> fetchEvents() async {
    isLoading = true;
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.6:3000/user/getNew'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['news'];
        setState(() {
          events = data
              .map<Map<String, dynamic>>((item) => {
                    'id': item['_id'].toString(),
                    'title': item['title'],
                    'details': item['details'],
                    'image': item['image']
                  })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorText =
              'Failed to load events. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorText = 'Error fetching events: $error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void goToNextEvent() {
    setState(() {
      _currentEventIndex = (_currentEventIndex + 1) % events.length;
    });
  }

  void goToPreviousEvent() {
    setState(() {
      _currentEventIndex = (_currentEventIndex - 1) % events.length;
    });
  }

  Future<void> _deleteEvent(BuildContext context, String eventTitle) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.6:3000/user/deleteNew'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': eventTitle,
        }),
      );
      if (response.statusCode == 200) {
        fetchEvents(); // Reload events after successful deletion
      } else {
        // Handle error
        print('Failed to delete event. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error deleting event: $error');
    }
  }

  void goToEditEvent(BuildContext context, Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditEventPage(event: event)),
    );
  }

  void goToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEventPage(onAddEvent: _addEventToList)),
    );
  }

  void _addEventToList(Map<String, dynamic> newEvent) {
    setState(() {
      events.add(newEvent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(LocaleKeys.News.tr(),
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 238, 227, 240),Color.fromARGB(255, 187, 168, 187)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                color: Colors.white,
                child: TableCalendar(
                  locale: context.locale.toString(),
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2024, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 213, 201, 217),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 140, 79, 160),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    defaultTextStyle: const TextStyle(color: Colors.black),
                    todayTextStyle: const TextStyle(color: Colors.white),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Events',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : events.isEmpty
                      ? Center(
                          child: Text(errorText.isEmpty
                              ? 'No events available'
                              : errorText))
                      : ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            return EventListItem(
                              title: events[index]['title'],
                              details: events[index]['details'],
                              imageAssetPath: events[index]['image'],
                              onPressedEdit: () =>
                                  goToEditEvent(context, events[index]),
                              onPressedDelete: () =>
                                  _deleteEvent(context, events[index]['title']),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () => goToAddEvent(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final String title;
  final String details;
  final String imageAssetPath;
  final VoidCallback onPressedEdit;
  final VoidCallback onPressedDelete;

  const EventListItem({
    super.key,
    required this.title,
    required this.details,
    required this.imageAssetPath,
    required this.onPressedEdit,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: [
        ListTile(
          title: Text(details),
        ),
        if (imageAssetPath.isNotEmpty) Image.asset(imageAssetPath),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onPressedEdit,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: onPressedDelete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
  }
}

class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EditEventPage({super.key, required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event['title']);
    _detailsController = TextEditingController(text: widget.event['details']);
    _imageController = TextEditingController(text: widget.event['image']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _updateEvent() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.6:3000/user/updateNew'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.event['id'],
          'title': _titleController.text,
          'details': _detailsController.text,
          'image': _imageController.text,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to update event. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating event: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set app bar color to green[900]
        title: const Text(
          'Edit Event',
          style:
              TextStyle(color: Colors.white), // Set title text color to white
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Set arrow icon color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateEvent,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEventPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddEvent;

  const AddEventPage({super.key, required this.onAddEvent});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
    _imageController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addEvent() async {
    try {
      final newEvent = {
        'title': _titleController.text,
        'details': _detailsController.text,
        'image': _imageController.text,
      };

      final response = await http.post(
        Uri.parse('http://192.168.1.6:3000/user/addNew'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newEvent),
      );

      if (response.statusCode == 200) {
        // If the event was added successfully, update the local list of events
        widget.onAddEvent(newEvent);
        Navigator.pop(context);
      } else {
        // Handle the case when the server returns an error status code
        print('Failed to add event. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error adding event: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.green, // Set the app bar color to green[900]
        title: const Text(
          'Add Event',
          style:
              TextStyle(color: Colors.white), // Set title text color to white
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Set arrow icon color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addEvent,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
