import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

void main() => runApp(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('es')],
        path: 'resources/langs',
        fallbackLocale: Locale('en'),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: EventsPage(),
    );
  }
}

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> events = [];
  bool isLoading = true;
  String errorText = '';

  Future<void> fetchEvents() async {
    isLoading = true;
    try {
      final response = await http.get(Uri.parse('http://192.168.1.6:3000/user/getNew'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['news'];
        setState(() {
          events = data.map<Map<String, dynamic>>((item) => {
            'id': item['_id'].toString(),
            'title': item['title'],
            'details': item['details'],
            'image': item['image'] 
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorText = 'Failed to load events. Status code: ${response.statusCode}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(LocaleKeys.News_Page.tr(), style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),  // Set the icon theme for AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 238, 227, 240), Color.fromARGB(255, 187, 168, 187)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10), // Add space between app bar and calendar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust padding
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white, // Set the background color of the calendar
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TableCalendar(
                locale: context.locale.toString(),
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2024, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(fontSize: 20.0, color: Colors.black), // Customize the title text style
                  formatButtonTextStyle: TextStyle(fontSize: 15.0, color: Colors.white), // Customize the format button text style
                  formatButtonDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 205, 196, 204), // Customize the format button background color
                    borderRadius: BorderRadius.circular(10.0), // Customize the format button border radius
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black), // Customize the weekday text style
                  weekendStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.red), // Customize the weekend text style
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 205, 196, 204), // Customize the today cell background color
                    shape: BoxShape.circle, // Set the shape of the today cell
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue, // Customize the selected cell background color
                    shape: BoxShape.circle, // Set the shape of the selected cell
                  ),
                ),
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
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                tr('Important_Events'),
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : events.isEmpty
                    ? Center(child: Text(errorText.isEmpty ? 'No events available' : errorText))
                    : RefreshIndicator(
                        onRefresh: fetchEvents,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            var event = events[index];
                            return EventItem(
                              image: event['image'],
                              title: event['title'],
                              details: event['details'],
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  final String image;
  final String title;
  final String details;

  EventItem({required this.image, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr(),
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  details.tr(),
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
