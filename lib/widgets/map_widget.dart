import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
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

  // Replace with your Google Maps API key
  final String? _googleApiKey =
      'AIzaSyAGSu_k6uEQT8siB78VTkI-u3_K05IeCOI'; // Set to 'YOUR_API_KEY' for production

  @override
  void initState() {
    super.initState();
    if (widget.latitude == null && widget.longitude == null)
      _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
        _setFallbackLocation();
        return;
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          _setFallbackLocation();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permissions are permanently denied')),
        );
        _setFallbackLocation();
        return;
      }

      // Get coordinates
      double latitude;
      double longitude;
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid location coordinates')),
        );
        _setFallbackLocation();
        return;
      }

      // Update controller values
      addController.latitude.value = latitude;
      addController.longitude.value = longitude;

      // Fetch address
      await _fetchAddress(latitude, longitude);

      // Update map camera
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
      _setFallbackLocation();
    }
  }

  Future<void> _fetchAddress(double latitude, double longitude) async {
    // Try geocoding package first
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
        // apiKey: _googleApiKey, // Uncomment if you have an API key
      );

      if (placemarks.isNotEmpty && placemarks.first != null) {
        Placemark placemark = placemarks.first;
        String address = [
          placemark.street ?? '',
          placemark.locality ?? '',
          placemark.administrativeArea ?? '',
          placemark.country ?? '',
        ].where((element) => element.isNotEmpty).join(', ');

        addEventController.locationController.text =
            address.isNotEmpty ? address : 'Unknown address';
        addEventController.cityController.text = placemark.locality ?? '';
        addEventController.countryController.text = placemark.country ?? '';
        addEventController.update(); // Force GetX update
      } else {
        addEventController.locationController.text =
            'No address found for ($latitude, $longitude)';
        addEventController.update();
      }
      return; // Success, no need to try HTTP
    } catch (e) {
      print('Geocoding package error: $e');
      // Don’t show snackbar yet; try HTTP fallback
    }

    // Fallback to HTTP-based geocoding
    if (_googleApiKey != null) {
      try {
        final url =
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_googleApiKey';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['results'] != null && data['results'].isNotEmpty) {
            String address =
                data['results'][0]['formatted_address'] ?? 'Unknown address';
            addEventController.locationController.text = address;
            // Extract city
            // Extract city
            String city = '';
            var cityComponent =
                data['results'][0]['address_components'].firstWhere(
              (component) =>
                  component is Map &&
                  (component['types'] as List<dynamic>?)
                          ?.contains('locality') ==
                      true,
              orElse: () => <String, dynamic>{'long_name': ''},
            );
            city = cityComponent['long_name'] as String? ?? '';

// Extract country
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
          } else {
            addEventController.locationController.text =
                'No address found for ($latitude, $longitude)';
            addEventController.update();
          }
        } else {
          throw 'HTTP error: ${response.statusCode}';
        }
      } catch (e) {
        addEventController.locationController.text = 'Failed to fetch address';
        addEventController.update();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geocoding error: $e')),
        );
        print('Error $e');
      }
    } else {
      addEventController.locationController.text =
          'Failed to fetch address (no API key)';
      addEventController.update();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Geocoding failed. Please add a Google Maps API key.')),
      );
    }
  }

  void _setFallbackLocation() {
    const double fallbackLatitude = 37.7749;
    const double fallbackLongitude = -122.4194;
    addController.latitude.value = fallbackLatitude;
    addController.longitude.value = fallbackLongitude;
    addEventController.locationController.text = 'San Francisco, CA, USA';
    addEventController.cityController.text = 'San Francisco';
    addEventController.countryController.text = 'USA';
    addEventController.update();

    // Fetch address for fallback location
    _fetchAddress(fallbackLatitude, fallbackLongitude);

    // Update map camera
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
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive map height
          double mapHeight = kIsWeb
              ? MediaQuery.of(context).size.height * 0.5
              : constraints.maxWidth > 600
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.4;

          return Obx(() {
            return SizedBox(
              height: mapHeight,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.latitude == null
                        ? addController.latitude.value != 0.0
                            ? addController.latitude.value
                            : 37.7749
                        : widget.latitude!,
                    widget.latitude == null
                        ? addController.longitude.value != 0.0
                            ? addController.longitude.value
                            : -122.4194
                        : widget.longitude!,
                  ),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                markers: {
                  if (addController.latitude.value != 0.0 &&
                      addController.longitude.value != 0.0)
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(
                        addController.latitude.value,
                        addController.longitude.value,
                      ),
                    ),
                },
                myLocationButtonEnabled: true,
                onCameraMove: (CameraPosition position) {
                  addController.latitude.value = position.target.latitude;
                  addController.longitude.value = position.target.longitude;
                  _fetchAddress(
                    position.target.latitude,
                    position.target.longitude,
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }
}
