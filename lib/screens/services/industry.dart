import 'package:flutter/material.dart';



class CraftScreen extends StatelessWidget {
    static String routeName = "/craft";

  const CraftScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Industry services',
         style: TextStyle(color: Colors.white)), // Set text color to white
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white), // Set arrow color to white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Text(
                      'Industry services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Changed text color to green
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/images/i.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for Water subscription request
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(150, 150), // Setting button size
                        padding: EdgeInsets.all(20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Requests to issue a crafts and industries license',
                        style: TextStyle(fontSize: 18), // Larger text
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for Water subscription transfer
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(150, 150), // Setting button size
                        padding: EdgeInsets.all(20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Cancellation of crafts and industries license',
                        style: TextStyle(fontSize: 18), // Larger text
                      ),
                    ),
                  ),
        
                ],
              ),
               SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for Water subscription request
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(150, 150), // Setting button size
                        padding: EdgeInsets.all(20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Certificate of non-verification of a crafts and industries license/non-practice of a profession​',
                        style: TextStyle(fontSize: 18), // Larger text
                      ),
                    ),
                  ),
                
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
