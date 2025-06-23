// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:kaistable_website/secert.dart';

// class MapWithDirectionWidget extends StatefulWidget {
//   final double destLat;
//   final double destLng;

//   const MapWithDirectionWidget({
//     super.key,
//     required this.destLat,
//     required this.destLng,
//   });

//   @override
//   State<MapWithDirectionWidget> createState() => _MapWithDirectionWidgetState();
// }

// class _MapWithDirectionWidgetState extends State<MapWithDirectionWidget> {
//   GoogleMapController? _mapController;
//   LatLng? _userLocation;
//   List<LatLng> _polylineCoordinates = [];
//   String _distance = "";
//   final Set<Polyline> _polylines = {};
//   final Set<Marker> _markers = {};

//   final String apiKey = googleApiKey; // 🔐 Replace with your actual API key

//   @override
//   void initState() {
//     super.initState();
//     _initMap();
//   }

//   Future<void> _initMap() async {
//     Position position = await _getCurrentLocation();
//     _userLocation = LatLng(position.latitude, position.longitude);

//     await _getDirections();

//     setState(() {
//       _markers.add(Marker(
//         markerId: const MarkerId('user'),
//         position: _userLocation!,
//         infoWindow: const InfoWindow(title: "You"),
//       ));

//       _markers.add(Marker(
//         markerId: const MarkerId('destination'),
//         position: LatLng(widget.destLat, widget.destLng),
//         infoWindow: const InfoWindow(title: "Restaurant"),
//       ));

//       _polylines.add(Polyline(
//         polylineId: const PolylineId('route'),
//         points: _polylineCoordinates,
//         color: Colors.blue,
//         width: 5,
//       ));
//     });
//   }

//   Future<Position> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (!serviceEnabled || permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   Future<void> _getDirections() async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=${widget.destLat},${widget.destLng}&key=$apiKey');

//     final response = await http.get(url);
//     final data = json.decode(response.body);

//     final route = data['routes'][0];
//     final leg = route['legs'][0];

//     setState(() {
//       _distance = leg['distance']['text'];
//     });

//     String encodedPolyline = route['overview_polyline']['points'];
//     _polylineCoordinates = PolylinePoints()
//         .decodePolyline(encodedPolyline)
//         .map((e) => LatLng(e.latitude, e.longitude))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _userLocation == null
//         ? const Center(child: CircularProgressIndicator())
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   'Map',
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: SizedBox(
//                     height: 200,
//                     width: double.infinity,
//                     child: GoogleMap(
//                       onMapCreated: (controller) => _mapController = controller,
//                       initialCameraPosition: CameraPosition(
//                         target: _userLocation!,
//                         zoom: 14,
//                       ),
//                       markers: _markers,
//                       polylines: _polylines,
//                       myLocationEnabled: true,
//                       myLocationButtonEnabled: true,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   'Distance: $_distance',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           );
//   }
// }

//................

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kaistable_website/secert.dart'; // Make sure apiKey is correct

class MapWithDirectionWidget extends StatefulWidget {
  final double destLat;
  final double destLng;

  const MapWithDirectionWidget({
    super.key,
    required this.destLat,
    required this.destLng,
  });

  @override
  State<MapWithDirectionWidget> createState() => _MapWithDirectionWidgetState();
}

class _MapWithDirectionWidgetState extends State<MapWithDirectionWidget> {
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  List<LatLng> _polylineCoordinates = [];
  String _distance = "";
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  final String apiKey = googleApiKey;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    if (widget.destLat == 0.0 && widget.destLng == 0.0) {
      setState(() {
        _distance = "Invalid destination coordinates.";
      });
      return;
    }

    Position? position = await _getCurrentLocation();
    if (position == null) return;
    _userLocation = LatLng(position.latitude, position.longitude);

    await _getDirections();

    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('user'),
        position: _userLocation!,
        infoWindow: const InfoWindow(title: "You"),
      ));

      _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.destLat, widget.destLng),
        infoWindow: const InfoWindow(title: "Restaurant"),
      ));

      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: _polylineCoordinates,
        color: Colors.red,
        width: 5,
      ));
    });

    _setCameraBounds();
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      setState(() {
        _distance = "Location services are disabled.";
      });
      return null;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _distance = "Permission denied";
        });
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _distance = "Permission permanently denied";
      });
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _getDirections() async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=${widget.destLat},${widget.destLng}&key=$apiKey');

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['routes'].isEmpty) {
      setState(() {
        _distance = "Route not found.";
      });
      return;
    }

    final route = data['routes'][0];
    final leg = route['legs'][0];

    // 📏 Convert miles to km if needed
    String distanceText = leg['distance']['text'];
    if (distanceText.contains('mi')) {
      final miles = double.tryParse(distanceText.split(' ').first) ?? 0.0;
      final km = (miles * 1.60934).toStringAsFixed(1);
      _distance = "$km km";
    } else {
      _distance = distanceText; // Already in km
    }

    String encodedPolyline = route['overview_polyline']['points'];
    _polylineCoordinates = PolylinePoints()
        .decodePolyline(encodedPolyline)
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  void _setCameraBounds() {
    if (_userLocation == null) return;

    LatLngBounds bounds;

    if (_userLocation!.latitude > widget.destLat) {
      bounds = LatLngBounds(
        southwest: LatLng(widget.destLat, widget.destLng),
        northeast: _userLocation!,
      );
    } else {
      bounds = LatLngBounds(
        southwest: _userLocation!,
        northeast: LatLng(widget.destLat, widget.destLng),
      );
    }

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future<void> _launchGoogleMapsDirections() async {
    if (_userLocation == null) return;

    final origin = "${_userLocation!.latitude},${_userLocation!.longitude}";
    final destination = "${widget.destLat},${widget.destLng}";

    final googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving";

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch Google Maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.destLat == 0.0 && widget.destLng == 0.0) {
      return const Center(
        child: Text("Destination coordinates not available."),
      );
    }

    if (_userLocation == null) {
      return Center(
        child: Text(
          _distance.isNotEmpty ? _distance : "Fetching location...",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Map',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 350,
              width: double.infinity,
              child: GestureDetector(
                onTap: _launchGoogleMapsDirections,
                child: GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _userLocation!,
                    zoom: 14,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Distance: $_distance',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapWithDirectionWidget extends StatefulWidget {
//   final double destLat;
//   final double destLng;

//   const MapWithDirectionWidget({
//     super.key,
//     required this.destLat,
//     required this.destLng,
//   });

//   @override
//   State<MapWithDirectionWidget> createState() => _MapWithDirectionWidgetState();
// }

// class _MapWithDirectionWidgetState extends State<MapWithDirectionWidget> {
//   LatLng? _userLocation;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (!serviceEnabled || permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//         setState(() {
//           _errorMessage = "Permission denied";
//         });
//         return;
//       }
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _userLocation = LatLng(position.latitude, position.longitude);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_errorMessage != null) {
//       return Center(child: Text(_errorMessage!));
//     }

//     if (_userLocation == null) {
//       return const SizedBox(); // No loader shown
//     }

//     // Check if destination is valid
//     bool isDestinationValid = widget.destLat != 0.0 && widget.destLng != 0.0;

//     LatLng center = isDestinationValid
//         ? LatLng(widget.destLat, widget.destLng)
//         : _userLocation!;

//     Set<Marker> markers = {
//       Marker(
//         markerId: const MarkerId("user_location"),
//         position: _userLocation!,
//         infoWindow: const InfoWindow(title: "You"),
//       ),
//     };

//     if (isDestinationValid) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId("destination"),
//           position: LatLng(widget.destLat, widget.destLng),
//           infoWindow: const InfoWindow(title: "Restaurant"),
//         ),
//       );
//     }

//     return SizedBox(
//       height: 200,
//       child: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: center,
//           zoom: 14,
//         ),
//         markers: markers,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         zoomControlsEnabled: false,
//         onMapCreated: (controller) {},
//       ),
//     );
//   }
// }
