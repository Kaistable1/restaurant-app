import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:savrly/controllers/add_event_controller.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';

class MapWidget extends StatefulWidget {
  MapWidget({super.key, this.latitude, this.longitude});
  double? latitude;
  double? longitude;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final AddRestaurantTabController addController =
      Get.put(AddRestaurantTabController());
  final AddEventController addEventController = Get.put(AddEventController());

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  // Your valid Google Maps API key
  final String _googleApiKey = 'AIzaSyDJjiynZugIjtXiZI4AIMU9srY1AkSmtto';
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    // // Initialize map with current location if no coordinates are provided
    // if (widget.latitude == null && widget.longitude == null) {
    //   _getCurrentLocation();
    // }

    // Add listener to locationController to update map when address changes
    // Use debounce to prevent excessive API calls
    addEventController.locationController.addListener(() {
      if (addEventController.locationController.text.isNotEmpty) {
        if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          final address = addEventController.locationController.text;
          if (address.isNotEmpty && address.length >= 5) {
            _updateMapFromAddress(address);
          }
        });
      }
    });

    addController.areaController.addListener(() {
      if (addController.areaController.text.isNotEmpty) {
        if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          final address = addController.areaController.text;
          if (address.isNotEmpty && address.length >= 5) {
            _updateMapFromAddress(address);
          }
        });
      }
    });

    addController.zipCodeController.addListener(() {
      if (addController.zipCodeController.text.isNotEmpty) {
        if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          final address = addController.zipCodeController.text;
          if (address.isNotEmpty && address.length >= 5) {
            _updateMapFromAddress(address);
          }
        });
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        _setFallbackLocation();
        return;
      }

      // Request location permission if not granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          _setFallbackLocation();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        _setFallbackLocation();
        return;
      }

      double latitude;
      double longitude;
      // Use restaurant model coordinates if available, otherwise get current position
      if (addController.restaurantModel != null) {
        latitude = addController.restaurantModel!.latitude;
        longitude = addController.restaurantModel!.longitude;
      } else {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        latitude = position.latitude;
        longitude = position.longitude;
      }

      // Validate coordinates
      if (latitude == 0.0 ||
          longitude == 0.0 ||
          latitude.isNaN ||
          longitude.isNaN ||
          latitude < -90 ||
          latitude > 90 ||
          longitude < -180 ||
          longitude > 180) {
        print('Invalid location coordinates');
        _setFallbackLocation();
        return;
      }

      addController.latitude.value = latitude;
      addController.longitude.value = longitude;

      await _fetchAddress(latitude, longitude);

      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching location: $e');
      _setFallbackLocation();
    }
  }

  Future<void> _getDirections(double destLat, double destLng) async {
    Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final startLat = position.latitude;
    final startLng = position.longitude;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$destLat,$destLng&key=$_googleApiKey',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['routes'].isEmpty) return;

    String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
    _polylineCoordinates = PolylinePoints()
        .decodePolyline(encodedPolyline)
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: _polylineCoordinates,
          color: Colors.red,
          width: 5,
        ),
      };
    });
  }

  Future<void> _fetchAddress(double latitude, double longitude) async {
    // Try using the geocoding package first to get address from coordinates
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        addEventController.cityController.text = placemark.locality ?? '';
        addEventController.countryController.text = placemark.country ?? '';
        addEventController.update();
        return;
      }
    } catch (e) {
      print('Geocoding package error: $e');
    }

    // Fallback to HTTP request if geocoding package fails
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_googleApiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          // String address =
          //     data['results'][0]['formatted_address'] ?? 'Unknown address';
          // addEventController.locationController.text = address;

          String city = '';
          var cityComponent =
              data['results'][0]['address_components'].firstWhere(
            (component) =>
                component is Map &&
                (component['types'] as List<dynamic>?)?.contains('locality') ==
                    true,
            orElse: () => <String, dynamic>{'long_name': ''},
          );
          city = cityComponent['long_name'] as String? ?? '';

          String country = '';
          var countryComponent =
              data['results'][0]['address_components'].firstWhere(
            (component) =>
                component is Map &&
                (component['types'] as List<dynamic>?)?.contains('country') ==
                    true,
            orElse: () => <String, dynamic>{'long_name': ''},
          );
          country = countryComponent['long_name'] as String? ?? '';

          addEventController.cityController.text = city;
          addEventController.countryController.text = country;
          addEventController.update();
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      addEventController.update();
      print('HTTP geocoding error: $e');
    }
  }

  Future<void> _updateMapFromAddress(String address) async {
    print('address ----------------- $address');
    // Validate the input address
    if (address.trim().isEmpty || address.length < 5) {
      print('Please enter a valid address');
      return;
    }

    try {
      print('Geocoding address: $address');
      // Use HTTP-based geocoding to convert address to coordinates
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$_googleApiKey';
      final response = await http.get(Uri.parse(url));
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          double latitude = data['results'][0]['geometry']['location']['lat'];
          double longitude = data['results'][0]['geometry']['location']['lng'];

          addController.latitude.value = latitude;
          addController.longitude.value = longitude;

          final GoogleMapController controller = await _mapController.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 14,
              ),
            ),
          );
          await _getDirections(latitude, longitude);

          setState(() {});
        } else {
          print('No locations found for address: $address');
        }
      } else {
        throw 'HTTP error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error geocoding address: _updateMapFromAddress function $e');
    }
  }

  void _setFallbackLocation() {
    const double fallbackLatitude = 37.7749;
    const double fallbackLongitude = -122.4194;

    addController.latitude.value = fallbackLatitude;
    addController.longitude.value = fallbackLongitude;
    addEventController.cityController.text = 'San Francisco';
    addEventController.countryController.text = 'USA';
    addEventController.update();

    _fetchAddress(fallbackLatitude, fallbackLongitude);
    _getDirections(fallbackLatitude, fallbackLongitude); // ⬅️ Add this

    _mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(fallbackLatitude, fallbackLongitude),
            zoom: 14,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    // Cancel any active debounce timer to prevent memory leaks
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine map height based on screen size and platform
          double mapHeight = kIsWeb
              ? MediaQuery.of(context).size.height * 0.5
              : constraints.maxWidth > 600
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.4;

          return Obx(() {
            // Render the Google Map with dynamic coordinates
            return SizedBox(
                height: mapHeight,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.latitude ?? addController.latitude.value,
                      widget.longitude ?? addController.longitude.value,
                    ),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(
                        addController.latitude.value,
                        addController.longitude.value,
                      ),
                    ),
                  },
                  polylines: _polylines,
                  myLocationButtonEnabled:
                      false, // hide current location button
                  myLocationEnabled: true,
                ));
          });
        },
      ),
    );
  }
}
