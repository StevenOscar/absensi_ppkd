import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final locationProvider = NotifierProvider<LocationProvider, LocationState>(
  () => LocationProvider(),
);

const targetLatLng = LatLng(
  -6.210868134288406,
  106.81294508218784,
); //Pusat Pelatihan Kerja Daerah Jaarta Pusat

class LocationState {
  final LatLng? currentPosition;
  final String currentAddress;
  final Marker? marker;
  final double? distanceInMeter;

  const LocationState({
    this.currentPosition,
    this.currentAddress = "Address Not Found",
    this.marker,
    this.distanceInMeter,
  });

  LocationState copyWith({
    LatLng? currentPosition,
    String? currentAddress,
    Marker? marker,
    double? distanceInMeter,
  }) {
    return LocationState(
      currentPosition: currentPosition ?? this.currentPosition,
      currentAddress: currentAddress ?? this.currentAddress,
      marker: marker ?? this.marker,
      distanceInMeter: distanceInMeter ?? this.distanceInMeter,
    );
  }
}

class LocationProvider extends Notifier<LocationState> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStream;

  @override
  LocationState build() {
    ref.onDispose(() {
      _mapController?.dispose();
    });
    return const LocationState();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void startTrackingLocation() async {
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((position) async {
      final currentLatLng = LatLng(position.latitude, position.longitude);
      final placemarks = await placemarkFromCoordinates(
        currentLatLng.latitude,
        currentLatLng.longitude,
      );
      final place = placemarks.first;
      final address = "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

      final targetMarker = Marker(
        markerId: const MarkerId("target_location"),
        position: targetLatLng,
        infoWindow: const InfoWindow(title: "Target"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      final distanceInMeters = Geolocator.distanceBetween(
        currentLatLng.latitude,
        currentLatLng.longitude,
        targetLatLng.latitude,
        targetLatLng.longitude,
      );

      state = state.copyWith(
        currentPosition: currentLatLng,
        marker: targetMarker,
        distanceInMeter: distanceInMeters,
        currentAddress: address,
      );

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: currentLatLng, zoom: 17)),
      );
    });
  }
}
