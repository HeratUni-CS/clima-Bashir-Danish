import 'package:clima/component/details.dart';
import 'package:clima/component/loader.dart';
import 'package:clima/models/weather_model.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isDataLoaded = false;
  double? latitude, longitude;
  WeatherModel? weatherModel;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;

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
          print('Permission permanently denied');
        } else {
          getCurrentLocation();
        }
      } else {
        print('Location permissions are denied');
      }
    } else {
      getCurrentLocation();
    }
  }

  void getCurrentLocation() async {
    Location location = Location();
    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$kApiKey&units=metric');
    var weatherData = await networkHelper.getData();
    weatherModel = WeatherModel(
      location: weatherData['name']+', '+weatherData['sys']['country'],
      description:weatherData['weather'][0]['description'],
      icon: weatherData['weather'][0]['icon'],
      temperature: weatherData['main']['temp'],
      feelsLikes: weatherData['main']['feels_like'],
      humidity: weatherData['main']['humidity'],
      wind: weatherData['main']['speed'],
    );
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const Loader();
    } else {
      return Scaffold(
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
                          print(typename);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ElevatedButton(
                        onPressed: () {},
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
                  const  SizedBox(
                      height: 25,
                    ),
                  const  Icon(
                      Icons.wb_sunny_outlined,
                      size: 250,
                    ),
                  const  SizedBox(
                      width: 40,
                    ),
                    Text(
                      '${weatherModel!.temperature!}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherModel!.description!,
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
                    child:const  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Details( title: 'FEELS LIKE',value: '31°',),
                        VerticalDivider(thickness: 1,),
                        Details( title: 'HUMIDITY',value: '13%' ,),
                        VerticalDivider(thickness: 1,),
                        Details( title: 'WIND',value: '7',),
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
