import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/events.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class EventMainScreen extends StatefulWidget {
  static String routeName = "/eventmain";

  const EventMainScreen({Key? key}) : super(key: key);

  @override
  State<EventMainScreen> createState() => _EventMainState();
}

class _EventMainState extends State<EventMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(.4),
                Colors.black.withOpacity(.7),
                Colors.black.withOpacity(.7),
                Colors.black.withOpacity(.4),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    Text(
                     LocaleKeys.Find_the_best_events_near_you_for_agreat_day.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      LocaleKeys.Experiencethethrillfwith_The_ultimate_destination_for_you.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 115,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 75, horizontal: 20),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: MaterialButton(
                    onPressed: () {
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventScreen()),
            );


                     },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                         LocaleKeys.Find_nearest_events.tr(),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}