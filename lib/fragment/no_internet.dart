import 'package:flutter/material.dart';

Widget build_no_internet() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/img_18.png',
          width: 147,
              ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text(
              'Упс..Немає підключення до інтернету',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF547FA6),
                fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.center,
          ),
        ),

      ],
    ),
  );
}