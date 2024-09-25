import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:einlogica_hr/Models/locationModel.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:url_launcher/url_launcher.dart';

class locationServices{


  //Check Location Services

  Future<bool> checkLocationServices()async{
    print("Executing check location services method");
    bool serviceEnabled;
    bool status=false;
    LocationPermission permission;
    // Position _position = Position(longitude: 0.00, latitude: 0.00, timestamp: DateTime.now(), accuracy: 0.00, altitude: 0.00, altitudeAccuracy: 0.00,
    //     heading: 0.00, headingAccuracy: 0.00, speed: 0.00, speedAccuracy: 0.00);

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // print("serviceEnabled = $serviceEnabled");

    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pleae enable Location Services")));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // print("Permission denied");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Need permission to proceed")));
        status=false;
      }
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // print("Permission denied");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Need permission to proceed")));
      status=true;
    }
    // print(permission.toString());

    return status;


  }




  //Fetch current position
  Future<Position> getCurrentLocation()async{

    bool serviceEnabled;
    LocationPermission permission;
    Position _position = Position(longitude: 0.00, latitude: 0.00, timestamp: DateTime.now(), accuracy: 0.00, altitude: 0.00, altitudeAccuracy: 0.00,
        heading: 0.00, headingAccuracy: 0.00, speed: 0.00, speedAccuracy: 0.00);

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          // return Future.error('Location permissions are denied');
          return _position;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
        return _position;
      }
    }
    else{
      _position = await Geolocator.getCurrentPosition();
    }

    return _position;

  }

  //prepare attendance data
  Future<locationModel> prepareModel()async{
    print("Calling prepareModel function in location services");

    //Get Current location
    // Position _position = await getCurrentLocation();
    Position _position = await Geolocator.getCurrentPosition();

    locationModel currLocation = locationModel(ID: "",locationName: "Remote", posLat: _position.latitude, posLong: _position.longitude,range: 0);
    locationModel badLocation = locationModel(ID:"",locationName: "Unknown", posLat: _position.latitude, posLong: _position.longitude,range: 0);

    if(_position.longitude==0.00){
      return badLocation;
    }

    List<locationModel> defLocations = await apiServices().getDefaultLocations();
    // print(defLocations.length);

    for (var data in defLocations){
      // print(data.posLat);
      // print(data.posLong);
      // print(_position.latitude);
      // print(_position.longitude);
      // print(Geolocator.distanceBetween(data.posLat, data.posLong, _position.latitude, _position.longitude));
      if(Geolocator.distanceBetween(data.posLat, data.posLong, _position.latitude, _position.longitude)<data.range){
        // print("Current location is ${data.locationName}");
        currLocation=locationModel(ID:"",locationName: data.locationName, posLat: _position.latitude, posLong: _position.longitude,range: 0);
        return currLocation;
      }

    }

    return currLocation;


  }

  //Open location on Google maps
  Future<void> openMap(double latitude, double longitude) async {
    print("Executing open map");
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String iosUrl = 'https://maps.apple.com/?q=$latitude,$longitude';

    if (Platform.isAndroid) {
      try {
        await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
      } catch(e){
        throw 'Could not open the map.';
      }

    } else if (Platform.isIOS) {
      print("detected ios platform");
      try {
        await launchUrl(Uri.parse(iosUrl), mode: LaunchMode.externalApplication);
      } catch(e){
        throw 'Could not open the map.';
      }
    }


    try {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
    } catch(e){
      throw 'Could not open the map.';
    }
  }


}