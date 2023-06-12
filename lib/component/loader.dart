import 'package:clima/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kLightColor,
      body: Center(
        child: Column(
          children: [
            SpinKitPulse(
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 10,),
            Text('Fetching data ...',style: TextStyle(
              fontSize: 20,
              color: kMidLightColor,
            ),)
          ],),
      ),
    );
  }
}