// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// final attendanceProvider = NotifierProvider<AttendanceProvider, AttendanceState>(
//   () => AttendanceProvider(),
// );

// class AttendanceState {
//   // final LatLng? currentPosition;
//   // final String currentAddress;
//   // final Marker? marker;

//   const AttendanceState({
//     // this.currentPosition,
//     // this.currentAddress = "Alamat tidak ditemukan",
//     // this.marker,
//   });

//   AttendanceState copyWith({LatLng? currentPosition, String? currentAddress, Marker? marker}) {
//     return AttendanceState(
//       // currentPosition: currentPosition ?? this.currentPosition,
//       // currentAddress: currentAddress ?? this.currentAddress,
//       // marker: marker ?? this.marker,
//     );
//   }
// }

// class AttendanceProvider extends Notifier<AttendanceState> {

//   @override
//   AttendanceState build() => const AttendanceState();

// }
