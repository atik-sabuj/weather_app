import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_08/utils/constants.dart';
import 'package:weather_app_08/utils/weather_preferences.dart';

import '../provider/weather_provider.dart';
import '../utils/helper_functions.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WeatherProvider weatherProvider;
  bool calledOnce = true;

  @override
  void didChangeDependencies() {
    if (calledOnce) {
      weatherProvider = Provider.of<WeatherProvider>(context);
      _getData();
    }
    calledOnce = false;
    super.didChangeDependencies();
  }

  void _getData() async {
    final position = await _determinePosition();
    weatherProvider.setNewLocation(position.latitude, position.longitude);
    final tempUnitStatus = await getBool(tempUnitKey);
    final timeFormatStatus = await getBool(timeFormatKey);
    weatherProvider.setTimePattern(timeFormatStatus);
    weatherProvider.setTempUnit(tempUnitStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.my_location),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _CitySearchDelegate(),
              ).then((city) {
                if(city != null && city.isNotEmpty) {
                  weatherProvider.convertAddressToLatLng(city);
                }
              });
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, SettingsPage.routeName),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: weatherProvider.hasDataLoaded
          ? ListView(
              children: [
                _currentWeatherSection(),
                _forecastWeatherSection(),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Widget _currentWeatherSection() {
    final current = weatherProvider.currentWeatherResponse;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            getFormattedDate(current!.dt!, pattern: 'MMM dd yyyy'),
            style: txtNormal16White54,
          ),
          Text(
            '${current.name}, ${current.sys!.country}',
            style: txtAddressWhite24,
          ),
          Text(
            '${current.main!.temp!.round()}$degree${weatherProvider.tempUnitSymbol}',
            style: txtTempBig80,
          ),
          Text(
            'Feels like ${current.main!.feelsLike!.round()}$degree${weatherProvider.tempUnitSymbol}',
            style: txtTempSmall18,
          ),
          Image.network('$iconPrefix${current.weather![0].icon}$iconSuffix'),
          Text(
            current.weather![0].description!,
            style: txtNormalWhite16,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Text(
                  'Humidity ${current.main!.humidity}%  ',
                  style: txtNormal16White54,
                ),
                Text(
                  'Pressure ${current.main!.pressure} hPa  ',
                  style: txtNormal16White54,
                ),
                Text(
                  'Wind ${current.wind!.speed} m/s  ',
                  style: txtNormal16White54,
                ),
                Text(
                  'Wind Degree ${current.wind!.deg}$degree  ',
                  style: txtNormal16White54,
                ),
                Text(
                  'Visibility ${current.visibility} meter  ',
                  style: txtNormal16White54,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Text(
                  'Sunrise ${getFormattedDate(current.sys!.sunrise!, pattern: weatherProvider.timePattern)}  ',
                  style: txtNormalWhite16,
                ),
                Text(
                  'Sunset ${getFormattedDate(current.sys!.sunset!, pattern: weatherProvider.timePattern)}  ',
                  style: txtNormalWhite16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _forecastWeatherSection() {
    final forecastList = weatherProvider.forecastWeatherResponse!.list!;
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: forecastList.length,
        itemBuilder: (context, index) {
          final item = forecastList[index];
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            width: 130,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black26,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getFormattedDate(item.dt!,
                        pattern: 'EEE ${weatherProvider.timePattern}'),
                    style: txtNormalWhite16,
                  ),
                  Image.network(
                    '$iconPrefix${item.weather![0].icon}$iconSuffix',
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    '${item.main!.tempMax!.round()}/${item.main!.tempMin!.round()}$degree${weatherProvider.tempUnitSymbol}',
                    style: txtNormalWhite16,
                  ),
                  Text(
                    item.weather![0].description!,
                    style: txtNormalWhite16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);;
      },
      title: Text(query),
      leading: const Icon(Icons.search),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty ? cities :
        cities.where((city) => city.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return ListTile(
          onTap: () {
            query = item;
            close(context, query);
          },
          title: Text(item),
        );
      },
    );
  }

}


