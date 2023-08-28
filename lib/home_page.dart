import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const LatLng myLocation = LatLng(26.435, 82.183);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then((loc) {
      print('Current location : ${loc.latitude},${loc..longitude}');
      currentLocation = loc;
    });

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      setState(() {});
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Demo'),
        centerTitle: true,
      ),
      body: currentLocation == null
          ? const Center(
              child: Text('Loading'),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target:
                      // myLocation,
                      LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                  zoom: 14),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('Current locatoin'),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                const Marker(
                    markerId: MarkerId('My Home'),
                    position: myLocation,
                    infoWindow:
                        InfoWindow(title: 'Home', snippet: 'Amit Home')),
              },
            ),
    );
  }
}
