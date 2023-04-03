import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  final location = Location();
  late GoogleMapController _controller;
  late LocationData _currentLocation;

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  void initState() {
    super.initState();

    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          _currentLocation = locationData;

          setState(() {
            _markers.add(Marker(
              markerId: const MarkerId('User Location'),
              position: LatLng(locationData.latitude!, locationData.longitude!),
            ));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target:
                LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
          ),
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
            15,
          ));
        },
        label: const Text('Your Location'),
        icon: const Icon(Icons.my_location_outlined),
      ),
    );
  }
}
