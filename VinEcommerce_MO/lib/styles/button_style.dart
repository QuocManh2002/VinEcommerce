import 'package:flutter/material.dart';

import 'color.dart';

final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  foregroundColor: Colors.white,
  elevation: 0,
  textStyle: const TextStyle(fontSize: 18),
  minimumSize: const Size(340, 45),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(7),
    ),
  ),
);


final outlinedButtonStyle = OutlinedButton.styleFrom(
  side: const BorderSide(width: 2, color: primaryColor),
  foregroundColor: primaryColor,
  textStyle: const TextStyle(fontSize: 18),
  minimumSize: const Size(340, 45),
);
