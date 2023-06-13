import 'package:clima/component/details.dart';
import 'package:clima/component/error_message.dart';
import 'package:clima/component/loader.dart';
import 'package:clima/models/weather_model.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/utilities/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isDataLoaded = false;
  bool isErrorOcurred = false;
  double? latitude, longitude;
  WeatherModel? weatherModel;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  int code = 0;
  Weather weather =Weather();
  var weatherData;
  String? title,message;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          // print('Permission permanently denied');
          setState(() {
            isDataLoaded = true;
            isErrorOcurred = true;
            title = 'Permission permanently denied';
            message = 'Please enable the location service to see weather condition for your location';
            return;
          });
        } else {
          updateUI();
        }
      } else {
        // print('Location permissions are denied');
      }
    } else {
      updateUI();
    }
  }

  void updateUI({String? city}) async {
    weatherData =null;
    if(city ==null || city == ''){
      if (!await geolocatorPlatform.isLocationServiceEnabled()) {
      setState(() {
        isDataLoaded = true;
        isErrorOcurred = true;
        title = 'Location is turned off';
        message = 'Please enable the location service to see weather condition for your location';
        return;
      });
    }
      weatherData= await weather.getLocationWeather();
    }else{
      weatherData =await weather.getCityWeather(city);
    }
    if (weatherData == null) {
      setState(() {
        title='City not found';
        message='Please enter right city name';
        isDataLoaded = true;
        isErrorOcurred = true;
        return;
      });
    }else{

    code = weatherData['weather'][0]['id'];
    weatherModel = WeatherModel(
      location: weatherData['name'] + ', ' + weatherData['sys']['country'],
      description: weatherData['weather'][0]['description'],
      icon:
          'images/weather-icons/${getIconPrefix(code)}${kWeatherIcons[code.toString()]!['icon']!}.svg',
      temperature: weatherData['main']['temp'],
      feelsLikes: weatherData['main']['feels_like'],
      humidity: weatherData['main']['humidity'],
      wind: weatherData['wind']['speed'],
    );
    setState(() {
      isDataLoaded = true;
      isErrorOcurred = false;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const Loader();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kOverlayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        decoration: kTextFiledDecoration,
                        onSubmitted: (String typename) {
                          setState(() {
                          isDataLoaded =false;
                          });
                          updateUI(city:typename);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isDataLoaded =false;
                            getPermission();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          backgroundColor: Colors.white10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Text(
                                'My Location',
                                style: kTextFieldTextStyle,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.gps_fixed,
                                color: Colors.white60,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isErrorOcurred ?
              ErrorMessage(title: title!, message: message!) :
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_city,
                          color: kMidLightColor,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          weatherModel!.location!,
                          style: kLocationTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SvgPicture.asset(
                      weatherModel!.icon!,
                      height: 250,
                      color: kLightColor,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      '${weatherModel!.temperature!.round()}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherModel!.description!.toUpperCase(),
                      style: kLocationTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  color: kOverlayColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Details(
                          title: 'FEELS LIKE',
                          value: '${weatherModel != null ? weatherModel!.feelsLikes! :0}°',
                        ),
                        VerticalDivider(
                          thickness: 1,
                        ),
                        Details(
                          title: 'HUMIDITY',
                          value: '${weatherModel != null ? weatherModel!.humidity! :0}%',
                        ),
                        VerticalDivider(
                          thickness: 1,
                        ),
                        Details(
                          title: 'WIND',
                          value: '${weatherModel != null ? weatherModel!.wind! :0}',
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
