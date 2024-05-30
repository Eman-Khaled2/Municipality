import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,  // Adjusted height
      width: 100,   // Adjusted width
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Image(
            image: AssetImage("assets/images/user.png"),
            fit: BoxFit.cover,
          ),
          Positioned(
            right: -16,
            bottom: 12,
            child: SizedBox(
              height: 46,
              width: 46,
            ),
          ),
        ],
      ),
    );
  }
}
