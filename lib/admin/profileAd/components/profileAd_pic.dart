import 'package:flutter/material.dart';

class ProfileAdPic extends StatelessWidget {
  const ProfileAdPic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,  // Adjusted height to make the image smaller
      width: 100,   // Adjusted width to make the image smaller
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Image(
            image: AssetImage("assets/images/adIcon.png"),
            fit: BoxFit.cover,
          ),
          Positioned(
            right: -16,
            bottom: 12,
            child: SizedBox(
              height: 46,
              width: 46,
            ),
          )
        ],
      ),
    );
  }
}
