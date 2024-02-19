import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase/View/home/drawer.dart';
import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  HomeTitle({
    super.key,
  });

  final colorizeColors = [
    Color.fromARGB(255, 0, 102, 255),
    Color.fromARGB(255, 1, 6, 73),
    Color.fromARGB(255, 51, 144, 206),
    Color.fromARGB(255, 31, 195, 204),
  ];

  final colorizeTextStyle = const TextStyle(
    fontSize: 38.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DrawerHome(),
                  ));
            },
            child: const Icon(Icons.menu, size: 40)),
        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'NoteStock',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
              speed: const Duration(seconds: 2),
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,
        ),
        Image.asset(
          "assets/icons/userprofile.png",
          height: 40,
          width: 40,
        ),
      ],
    );
  }
}
