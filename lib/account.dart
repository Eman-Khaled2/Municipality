import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shop_app/account.dart';
import 'package:shop_app/translation/locale_keys.g.dart';

class AccountScreen extends StatefulWidget {
  static String routeName = "/account";

  const AccountScreen({Key? key, required this.userData}) : super(key: key);

  final Map<String, dynamic> userData;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? _image;
  var account = GetStorage();
  var userData;
  String imagePathKey = 'imagePath';

  @override
  void initState() {
    super.initState();
    userData = account.read('keyUser');
    // Load the saved image path if available
    String? savedImagePath = account.read(imagePathKey);
    if (savedImagePath != null) {
      _image = File(savedImagePath);
    }
    if (widget.userData != null) {
      nameController =
          TextEditingController(text: widget.userData['name'] ?? '');
      emailController =
          TextEditingController(text: widget.userData['email'] ?? '');
      passwordController =
          TextEditingController(text: widget.userData['password'] ?? '');
    }
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
    String apiUrl =
        'http://192.168.1.6:3000/user/uploadImages/${userData["id"]}';
    bool ret = false;
    try {
      if (base64Image.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.files.add(
          http.MultipartFile.fromBytes(
            'picture',
            _image!.readAsBytesSync(),
            filename: _image!.path.split('/').last,
          ),
        );

        var response = await request.send();
        if (response.statusCode == 200) {
          ret = true;
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return ret;
  }

  // Save the user changes
  Future<bool> updateUser() async {
    final apiUrl = 'http://192.168.1.6:3000/user/update';
    bool ret = false;
    try {
      if (_formKey.currentState!.validate()) {
        final response = await http.patch(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "id": userData["id"],
            "email": emailController.text,
            "password": passwordController.text,
            "name": nameController.text,
          }),
        );
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          Map<String, dynamic> user = {
            "name": data["name"],
            "email": data["email"],
            "password": data["password"],
            "id": data["_id"]
          };

          account.write("keyUser", user);

          setState(() {
            userData = account.read("keyUser");
            nameController.text = userData['name'];
            emailController.text = userData['email'];
            passwordController.text = userData['password'];
          });
          ret = true;
        }
      }
      return ret;
    } catch (e) {
      print("$e");
      return ret;
    }
  }

  // Open the image gallery or camera
  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          // Save the selected image path
          if (imagePathKey != null) {
            account.write(imagePathKey, pickedFile.path.toString());
            print('Image path updated successfully: ${pickedFile.path}');
          }
        });
        updateImage(); // Update the image after selecting it
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
           Color.fromARGB(255, 255, 255, 255),Color.fromARGB(255, 187, 168, 187),
         
        ],
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'My Account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 100), // Adjusted size and padding
            painter: HeaderCurvedContainer(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 120), // Adjusted padding
              child: Column(
                children: [
                  // Your existing widget tree goes here
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(LocaleKeys.Select_Image.tr()),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  GestureDetector(
                                    child: Text(LocaleKeys.Gallery.tr()),
                                    onTap: () async {
                                      _pickImage(
                                          ImageSource.gallery, context);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    child: Text(LocaleKeys.Camera.tr()),
                                    onTap: () {
                                      _pickImage(
                                          ImageSource.camera, context);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(0),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255), width: 5),
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: _image != null
                          ? CircleAvatar(
                        backgroundImage:
                        FileImage(_image!),
                        radius: 50,
                      )
                          : CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/profile.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name: ${userData["name"]}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 50, 49, 49),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${userData["email"]}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 50, 49, 49),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Your existing form fields go here
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: userData["name"],
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys
                                  .Please_enter_your_name
                                  .tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: userData["email"],
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys
                                  .Enter_valid_email_as_Muheebgmail
                                  .tr();
                            } else if (!value.contains('@')) {
                              return LocaleKeys
                                  .Enter_valid_email_as_Muheebgmail
                                  .tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: userData["password"],
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys
                                  .Please_enter_a_password
                                  .tr();
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            bool ret = await updateUser();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Text(ret
                                      ? LocaleKeys.success.tr()
                                      : 'Update Failed'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text(LocaleKeys.OK.tr()),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            padding: EdgeInsets.symmetric(
                              vertical: 1,
                              horizontal: 24,
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 118, 117, 117),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


}
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color.fromARGB(255, 242, 233, 243);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
