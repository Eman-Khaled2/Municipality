import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shop_app/services.dart';

class ImageSlider extends StatefulWidget {
  static String routeName = "/slider";

  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentPage = 0;
  late Timer timer;
  late PageController pageController;
  List<Map<String, String>> splashData = [
    {"text": 'Water Services', "image": "assets/images/1.png"},
    {"text": 'Electricity Services', "image": "assets/images/2.png"},
    {"text": 'Street Services', "image": "assets/images/3.png"},
    {"text": 'Sanitation Services', "image": "assets/images/4.png"},
    {"text": 'Fees Services', "image": "assets/images/5.png"},
    {"text": 'Advertising Services', "image": "assets/images/6.png"},
    {"text": 'Transaction Services', "image": "assets/images/7.png"},
    {"text": 'Administrative Services', "image": "assets/images/8.png"},
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      setState(() {
        currentPage = (currentPage + 1) % splashData.length;
        pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD3D3D3), // Light Gray
              Color.fromARGB(255, 187, 168, 187),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Our Services',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 105, 104, 104),
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 60), // Add a space between "Our Services" and the text
              Expanded(
                child: PageView.builder(
                  itemCount: splashData.length,
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) => Column(
                    children: [
                      Text(
                        splashData[index]["text"]!,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 105, 104, 104),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        splashData[index]["image"]!,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(90),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    splashData.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 5),
                      height: 6,
                      width: currentPage == index ? 20 : 6,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Color.fromARGB(255, 75, 0, 113)
                            : const Color(0xFFD8D8D8),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 12,
                margin: EdgeInsets.only(bottom: 50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceScreen(),
                settings: const RouteSettings(),
              ),
            );
                    },
                    style: ElevatedButton.styleFrom(
                     
                    ),
                    child: Text('Next'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
