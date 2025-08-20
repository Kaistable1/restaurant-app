import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  MapWidget({
    super.key,
    required this.lat,
    required this.long,
  });

  final double lat, long;
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
      child: Stack(
        children: [
          googleMap(),
          Positioned(
            right: 10,
            top: 10,
            child: Column(
              children: [
                _mapButton(Icons.add, _zoomIn),
                const SizedBox(height: 8),
                _mapButton(Icons.remove, _zoomOut),
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 80,
            child: Column(
              children: [
                _mapButton(Icons.keyboard_arrow_up, _panUp),
                Row(
                  children: [
                    _mapButton(Icons.keyboard_arrow_left, _panLeft),
                    const SizedBox(width: 8),
                    _mapButton(Icons.keyboard_arrow_right, _panRight),
                  ],
                ),
                _mapButton(Icons.keyboard_arrow_down, _panDown),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onPressed) {
    return ClipOval(
      child: Material(
        color: Colors.white.withOpacity(0.9),
        child: InkWell(
          splashColor: Colors.grey,
          onTap: onPressed,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 22),
          ),
        ),
      ),
    );
  }

  Future<void> _setMapStyle() async {
    String style = await rootBundle.loadString('assets/map_style.json');
    _controller?.setMapStyle(style);
  }

  GoogleMap googleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, long),
        zoom: 14.0,
      ),
      onMapCreated: (GoogleMapController mapController) {
        _controller = mapController;
        _setMapStyle(); // Apply custom map style
      },
      markers: {
        Marker(
          markerId: const MarkerId('location'),
          position: LatLng(lat, long),
        ),
      },
      mapType: MapType.terrain,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
    );
  }

  void _zoomIn() {
    _controller?.getZoomLevel().then((zoom) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: zoom + 1),
        ),
      );
    });
  }

  void _zoomOut() {
    _controller?.getZoomLevel().then((zoom) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: zoom - 1),
        ),
      );
    });
  }

  void _panUp() {
    _panBy(0, -0.01);
  }

  void _panDown() {
    _panBy(0, 0.01);
  }

  void _panLeft() {
    _panBy(-0.01, 0);
  }

  void _panRight() {
    _panBy(0.01, 0);
  }

  void _panBy(double dx, double dy) {
    _controller?.moveCamera(
      CameraUpdate.scrollBy(dx * 1000, dy * 1000),
    );
  }
}
