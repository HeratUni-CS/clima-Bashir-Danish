import 'package:flutter/material.dart';

const kApiKey = 'f669ffef321c0f3cf928deb7a7a4164a';
const kLightColor = Colors.white;
const kMidLightColor = Colors.white60;
const kOverlayColor = Color.fromRGBO(255, 255, 255, 0.102);
const kDarkColor = Colors.white24;

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 70.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);
const kDetailsTextStyle = TextStyle(
  fontSize: 20.0,
  color: kMidLightColor,
  fontWeight: FontWeight.bold,
);
const kDetailsTitleTextStyle = TextStyle(
  fontSize: 16.0,
  color: kDarkColor,
);
const kDetailsSuffixTextStyle = TextStyle(
  fontSize: 12.0,
  color: kMidLightColor,
);
const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);
const kTextFieldTextStyle = TextStyle(
  fontSize: 16.0,
  color: kMidLightColor
);
const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);
const kLocationTextStyle = TextStyle(
  fontSize: 20.0,
  color: kMidLightColor
);

const kTextFiledDecoration =InputDecoration(
    fillColor: kOverlayColor,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide.none
    ),
    hintText: 'Enter City Name',
    prefixIcon: Icon(Icons.search)
);