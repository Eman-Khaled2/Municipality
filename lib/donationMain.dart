import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop_app/events.dart';
import 'package:shop_app/report.dart';

class DonationMainScreen extends StatefulWidget {
  static String routeName = "/donationmain";

  const DonationMainScreen({Key? key}) : super(key: key);

  @override
  State<DonationMainScreen> createState() => _DonationMainState();
}

class _DonationMainState extends State<DonationMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/donationMain.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(.5),
                Colors.black.withOpacity(.5),
                Colors.black.withOpacity(.5),
                Colors.black.withOpacity(.5),
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
                      'Support Now!',
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
                      'Make a difference today by joining us in our mission.',
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
                        MaterialPageRoute(builder: (context) => ReportScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Tell us your complaint',
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
