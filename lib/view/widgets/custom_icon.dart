import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  const CustomIcon({super.key, required this.backgroundColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 30,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 38,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(7)),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 38,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7)),
          ),
          Center(
            child: Container(
              height: double.infinity,
            width: 38,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(7)),
                child: Icon(Icons.add ,color: iconColor,size: 20,),
          ),
          )
        ],
      ),
    );
  }
}
