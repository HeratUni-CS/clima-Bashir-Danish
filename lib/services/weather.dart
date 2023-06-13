import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/utilities/constants.dart';

class Weather {
  Future<dynamic> getLocationWeather()async{
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$kApiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
  Future<dynamic> getCityWeather(String city)async{
    NetworkHelper networkHelper = NetworkHelper(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$kApiKey&units=metric'
    );
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
}