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
  bool isDataLoaded =false;
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
      }else{
        getCurrentLocation();
      }
    }else{
      print('Location permissions are denied');
    }
    
  }else{
      getCurrentLocation();
    }

  }
  void getCurrentLocation() async{
    Location location = Location();
    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;
    NetworkHelper networkHelper = NetworkHelper('https://api.openweathermap.org/data/2.5/weather?lat=$latitude.34&lon=$longitude.99&appid=$kApiKey');
    var weatherData = await networkHelper.getData();
    setState(() {
      
    isDataLoaded =true; 
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const Loader();
    }else{

    return const Scaffold(
      body: Center(),
    );
    }
  }
}
