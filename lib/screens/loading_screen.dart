import 'package:clima/component/details.dart';
import 'package:clima/component/loader.dart';
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
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude.34&lon=$longitude.99&appid=$kApiKey');
    var weatherData = await networkHelper.getData();
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
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_city,
                          color: kMidLightColor,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'City Name',
                          style: kLocationTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 250,
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      '00',
                      style: kTempTextStyle,
                    ),
                    Text(
                      'CLEAR SKY',
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
