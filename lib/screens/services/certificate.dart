import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../translation/locale_keys.g.dart';

class CertificateScreen extends StatelessWidget {
  static String routeName = "/certificate";

  const CertificateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Crtificate_Services.tr(),
            style: TextStyle(color: Colors.white)), // Set text color to white
        backgroundColor: Colors.green,
        iconTheme:
            IconThemeData(color: Colors.white), // Set arrow color to white
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
                      LocaleKeys.Crtificate_Services.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Changed text color to green
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/images/cert.png',
                      width: 90,
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
                        padding: EdgeInsets.all(
                            20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Address verification',
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
                        padding: EdgeInsets.all(
                            20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Proof of residence with specification of distance',
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
                        // Action for Stop water subscription
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(150, 150), // Setting button size
                        padding: EdgeInsets.all(
                            20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Evicting a property Owning a property',
                        style: TextStyle(fontSize: 18), // Larger text
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for Objection to an invoice
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(150, 150), // Setting button size
                        padding: EdgeInsets.all(
                            20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Not owning a property',
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
                        // Action for Change subscription line
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(150, 150), // Setting button size
                        padding: EdgeInsets.all(
                            20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Emergency preparedness and response',
                        style: TextStyle(fontSize: 18), // Larger text
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for Subscription Waiver
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(150, 150), // Setting button size
                        padding: EdgeInsets.all(
                            20), // Adding padding for square shape
                      ),
                      child: Text(
                        'Practicing',
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
