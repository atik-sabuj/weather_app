import 'package:flutter/material.dart';

const String weatherApiKey = 'b51a561936b869bad59234c36dd69284';
const String metric = 'metric';
const String imperial = 'imperial';
const String celsius = 'C';
const String fahrenheit = 'F';
const String degree = '\u00B0';
const String iconPrefix = 'https://openweathermap.org/img/wn/';
const String iconSuffix = '@2x.png';
const String timePattern12 = 'hh:mm a';
const String timePattern24 = 'HH:mm';

const cities = [
  'Athens',
  'Barishal',
  'Bangalore',
  'Berlin',
  'Capetown',
  'Dhaka',
  'Doha',
  'Dublin',
  'Dubai',
  'Faridpur',
  'Gopalgonj',
  'Hobigonj',
  'Istanbul',
  'Jakarta',
  'Jamalpur',
  'Keranigonj',
  'Kualalampur',
  'London',
  'Milan',
  'Moscow',
  'New York',
  'Oslo',
  'Paris',
  'Riadh',
  'Rome',
  'Sydney',
  'Tongi',
];

const txtTempBig80 = TextStyle(
  fontSize: 80,
  color: Colors.white,
);
const txtTempSmall18 = TextStyle(
  fontSize: 18,
  color: Colors.white,
);
const txtAddressWhite24 = TextStyle(
  fontSize: 24,
  color: Colors.white,
  letterSpacing: 1.5,
);
const txtNormalWhite16 = TextStyle(
  fontSize: 16,
  color: Colors.white,
);
const txtNormal16White54 = TextStyle(
  fontSize: 16,
  color: Colors.white54,
);
