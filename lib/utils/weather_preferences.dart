import 'package:shared_preferences/shared_preferences.dart';

const String tempUnitKey = 'tempUnit';
const String timeFormatKey = 'timeFormat';
const String defaultCityKey = 'defaultCity';

Future<bool> setBool(String key, bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool(key, status);
}

Future<bool> getBool(String key) async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(key) ?? false;
}