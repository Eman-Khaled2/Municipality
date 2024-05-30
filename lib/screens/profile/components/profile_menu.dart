import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
    this.imagePath, // إضافة imagePath كمتغير جديد
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;
  final String? imagePath; // تعريف imagePath كمتغير جديد

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            // تحديث استخدام الصورة بناءً على imagePath
            if (imagePath != null)
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(imagePath!),
              ),
            if (imagePath == null)
              SvgPicture.asset(
                icon,
                color: kPrimaryColor,
                width: 22,
              ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
