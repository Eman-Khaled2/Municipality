import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class ReportScreen extends StatefulWidget {
  static String routeName = "/report";

  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<String>> reportTypes;

  @override
  void initState() {
    super.initState();
    reportTypes = fetchReportTypes();
  }

Future<List<String>> fetchReportTypes() async {
  const url = 'http://192.168.1.6:3000/user/getReports';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('reports')) {
        List<dynamic> reportsList = data['reports'];
        List<String> reports = reportsList.map((item) => item['type'].toString()).toList();
        return reports;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load report types');
    }
  } catch (e) {
    throw Exception('Failed to load report types: $e');
  }
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(LocaleKeys.Report_Issue.tr(),
          style: const TextStyle(color: Colors.white)),
    ),
    body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD3D3D3), // Light Gray
              Color.fromARGB(255, 187, 168, 187),
            ], // Adjust colors as needed
          ),
        ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.Select_the_problem_type.tr(),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 111, 110, 110)),

            ),
            const SizedBox(height: 10),
            FutureBuilder<List<String>>(
              future: reportTypes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No report types available'));
                } else {
                  return buildOptions(context, snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}


Widget buildOptions(BuildContext context, List<String> options) {
  return Column(
    children: options.map((option) => buildOptionButton(context, option)).toList(),
  );
}

Widget buildOptionButton(BuildContext context, String option) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 13.0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage(option: option),
          ),
        );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 10),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold, // Add bold font weight for a modern look
            color: Colors.black, // Change text color to black for better visibility
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 155, 154, 156)), // Set text color to grey
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return null; // Use the default button color if disabled
            }
            return Color.fromARGB(255, 255, 255, 255); // Use grey background when enabled
          },
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 50), // Set button width to match screen width
        ),
      ),
      child: Text(option),
    ),
  );
}
}


class MapPage extends StatefulWidget {
  final String option;

  const MapPage({Key? key, required this.option}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController reportController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  File? _image;

  LatLng? _selectedLocation;
  GoogleMapController? _controller;
  var userData;
  var account = GetStorage();
  String? imageBas64;

  XFile? _imageFile;
  String? idRepoet;

  @override
  void initState() {
    super.initState();
    userData = account.read('keyUser');
  }

  Future<bool> sendRequest() async {
    const apiUrl = 'http://192.168.1.6:3000/user/complaints';
    bool ret = false;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "complaintType": widget.option.toLowerCase(),
          "userName": userData["name"] ?? "Teeee",
          "location": {
            "latitude": _selectedLocation?.latitude,
            "longitude": _selectedLocation?.longitude
          },
          "description": reportController.text,
          "image": imageBas64, // Adding the image as part of the body
        }),
      );

      if (response.statusCode == 200) {
        ret = true;
        print("response: $response");
        print("response.body: ${response.body}");
        var resp = json.decode(response.body);

        idRepoet = resp["_id"];
      } else {
        ret = false;
        print("response.statusCode: ${response.statusCode}");
        print("response: $response");
      }
    } catch (e) {
      ret = false;
      print(e);
    }

    return ret;
  }

  // Update the image
  Future<void> updateImage() async {
    if (_image != null) {
      try {
        String base64Image = base64Encode(_image!.readAsBytesSync());
        bool? res = await requestImage(context, base64Image);
        if (res == true) {
          print("Image updated successfully");
          setState(() {
            // Set the updated image as a displayed image
            _image = File(_image!.path);
          });
        }
      } catch (e) {
        print('Error updating image: $e');
      }
    }
  }

  // Send the image to the server
  Future<bool?> requestImage(BuildContext context, String base64Image) async {
    print("http://192.168.1.6:3000/user/uploadImagesReport");
    String apiUrl = 'http://192.168.1.6:3000/user/uploadImagesReport/$idRepoet';
    bool ret = false;
    try {
      if (base64Image.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            _image!.readAsBytesSync(),
            filename: _image!.path.split('/').last,
          ),
        );

        var response = await request.send();
        if (response.statusCode >= 200 && response.statusCode < 300) {
          print("Send image");
          ret = true;
        } else {
          print(response.statusCode.toString());
          print("error");
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return ret;
  }

  String imageToBase64(String imagePath) {
    File imageFile = File(imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(LocaleKeys.Report_Issue.tr(),
            style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD3D3D3), // Light Gray
              Color.fromARGB(255, 187, 168, 187),
            ], // Adjust colors as needed
          ),
        ),
          key: _formKey,
          child: ListView(
            
            children: [
              GestureDetector(
                // onTap: _getImage,
                onTap: () async {
                  await _getImage();
                  // await updateImage();
                },
                child: Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: _imageFile != null
                      ? Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.Report_issue_about.tr(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.Please_enter_your_text.tr();
                  }
                  return null;
                },
                controller: reportController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: LocaleKeys.Enter_your_report.tr(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  hintText: userData["name"] ?? "",
                  border: const OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _selectLocationOnMap();
                },
                icon: const Icon(Icons.location_on),
                label: Text(LocaleKeys.Select_Location_on_Map.tr()),
              ),
              const SizedBox(height: 20),
              if (_selectedLocation != null)
                SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      Text(
                        LocaleKeys.Tap_on_the_map_to_select_the_location.tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _selectedLocation!,
                            zoom: 15,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                          onTap: (position) {
                            setState(() {
                              _selectedLocation = position;
                            });
                            _moveCamera(position);
                          },
                          markers: _selectedLocation != null
                              ? {
                                  Marker(
                                    markerId: MarkerId(
                                        LocaleKeys.selected_location.tr()),
                                    position: _selectedLocation!,
                                  ),
                                }
                              : {},
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedLocation != null &&
                      _formKey.currentState!.validate()) {
                    print('Report submitted for ${widget.option}');
                    print('Selected location: $_selectedLocation');
                    print('Report content: ${reportController.text}');

                    var res = await sendRequest();

                    if (res == true) {
                      if (idRepoet != null && idRepoet != "") {
                        await updateImage();
                        _showDialog("Send success!!", true);
                      } else {
                        _showDialog("Send success __ without image", true);
                      }
                    } else {
                      _showDialog("Send failed", false);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content:
                              const Text("Please select a location on the map"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 18),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return null;
                      }
                      return Color.fromARGB(255, 252, 255, 252);
                    },
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 50),
                  ),
                ),
                child: Text(LocaleKeys.Submit_Report.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveCamera(LatLng position) {
    _controller?.animateCamera(CameraUpdate.newLatLng(position));
  }

  void _selectLocationOnMap() async {
    LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPickerScreen(),
      ),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
      });
      _moveCamera(selectedLocation);
    }
  }

  void _showDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(32.210826, 35.264166),
  zoom: 14,
);

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationPickerState(),
      child: _LocationPickerScreenContent(),
    );
  }
}

class _LocationPickerScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          LocaleKeys.Select_Location.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<LocationPickerState>(
        builder: (context, state, _) {
          return Container(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onTap: (LatLng latLng) {
                      state.setSelectedLocation(latLng);
                      Navigator.pop(
                          context, latLng); // Return the selected location
                    },
                    markers: state.selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId("selected_location"),
                              position: state.selectedLocation!,
                            ),
                          }
                        : {},
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      state.setController(controller);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LocationPickerState with ChangeNotifier {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng? _selectedLocation;

  LatLng? get selectedLocation => _selectedLocation;

  void setSelectedLocation(LatLng latLng) {
    _selectedLocation = latLng;
    notifyListeners();
  }

  void setController(GoogleMapController controller) {
    _controller.complete(controller);
  }
}
