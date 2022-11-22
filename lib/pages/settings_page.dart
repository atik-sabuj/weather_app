import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_08/provider/weather_provider.dart';
import 'package:weather_app_08/utils/weather_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isTempUnitSwitchedOn = false;
  bool is24HourFormat = false;
  bool isDefaultCity = false;
  @override
  void initState() {
    getBool(tempUnitKey).then((value) {
      setState(() {
        isTempUnitSwitchedOn = value;
      });
    });
    getBool(timeFormatKey).then((value) {
      setState(() {
        is24HourFormat = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SwitchListTile(
            value: isTempUnitSwitchedOn,
            onChanged: (value) async {
              setState(() {
                isTempUnitSwitchedOn = value;
              });
              await setBool(tempUnitKey, value);
              Provider.of<WeatherProvider>(context, listen: false)
              .setTempUnit(value);
            },
            title: const Text('Show temperature in Fahrenheit'),
            subtitle: const Text('Default is Celsius'),
          ),
          SwitchListTile(
            value: is24HourFormat,
            onChanged: (value) async {
              setState(() {
                is24HourFormat = value;
              });
              await setBool(timeFormatKey, value);
              Provider.of<WeatherProvider>(context, listen: false)
                  .setTimePattern(value);
            },
            title: const Text('Show time in 24 hour format'),
            subtitle: const Text('Default is 12 hour'),
          ),
          SwitchListTile(
            value: isDefaultCity,
            onChanged: (value) {
              setState(() {
                isDefaultCity = value;
              });
            },
            title: const Text('Set current city as default'),
            subtitle: const Text(
                'Your location will no longer be detected. Data will be shown based on default city location'),
          ),
        ],
      ),
    );
  }
}
