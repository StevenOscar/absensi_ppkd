import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final navigationProvider = NotifierProvider<LocationProvider, NavigationState>(
  () => LocationProvider(),
);

class NavigationState {
  final LatLng? currentPosition;
  final String currentAddress;
  final Marker? marker;

  const NavigationState({
    this.currentPosition,
    this.currentAddress = "Alamat tidak ditemukan",
    this.marker,
  });

  NavigationState copyWith({LatLng? currentPosition, String? currentAddress, Marker? marker}) {
    return NavigationState(
      currentPosition: currentPosition ?? this.currentPosition,
      currentAddress: currentAddress ?? this.currentAddress,
      marker: marker ?? this.marker,
    );
  }
}

class LocationProvider extends Notifier<NavigationState> {
  GoogleMapController? mapController;

  @override
  NavigationState build() => const NavigationState();

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final LatLng latLng = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final Placemark place = placemarks.first;
    final String address = "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

    final marker = Marker(
      markerId: const MarkerId("lokasi_saya"),
      position: latLng,
      infoWindow: InfoWindow(title: "Lokasi Anda", snippet: "${place.street}, ${place.locality}"),
    );

    state = state.copyWith(currentPosition: latLng, currentAddress: address, marker: marker);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)),
    );
  }
}
